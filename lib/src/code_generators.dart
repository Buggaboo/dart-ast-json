import 'serializers.dart';
import 'layout_parser.dart';
import 'package:logging/logging.dart' show Logger;

String opCodeWithInteger(Decl e, int i) {
  if (e.inner == null) return " = $i";

  final list = <Decl>[];
  e.gather("IntegerLiteral", list);

  if (list.isEmpty) return " = $i";

  final literal = list[0];

  return " = ${literal.opcode ?? ""}${literal.value ?? i}";
}

String disabledEnumLayout(String classDef) =>
'''
/*
$classDef
*/
''';

String declareClassLayout(Decl e, String fields) =>
'''
// ${e.id}
class ${e.name} {
  $fields
}
''';


String enumToClass (Decl e, [Logger log]) {
  if (e.inner == null) return "";

  final constants = <Decl>[];
  e.gather("EnumConstantDecl", constants);

  var disable = false;

  if (e.name == null) {
    disable = true;
    if (log != null) {
      log.warning('Found enum with missing name (${e.id})');
    }
  }

  int i = 0;

  // ComplexOperator? CompoundOperator???
  var addWarning = (Decl d) => d.find("BinaryOperator") == null ?
    "" : " // TODO check actual value ${d.id} "; // TODO translate the operator?

  final fields = constants.map((c) =>
    'static const int ${c.name}${opCodeWithInteger(c, i++)};${addWarning(c)}')
    .toList().join("\n  ");

  final classDef = declareClassLayout(e, fields);

  return disable ? disabledEnumLayout(classDef) : classDef;
}

String desugar(Type origType, Map<String, Decl> typedefs) {
  final scrubbed = origType.scrubbed;
  final td = typedefs[scrubbed];

  if (td == null) { return origType.qualType; }

  // TODO confirm this
  // enum <name> -> int
  if (origType.isEnum) {
    return td.type.qualType;
  }

  // <name> -> enum <name> -> int
  if (td.type.isEnum) {
    final secondDegree = typedefs[td.type.qualType];
    if (secondDegree != null) {
      return secondDegree.type.qualType;
    }
  }

  // function pointer
  if (td.type.qualType.contains('(*)')) {
    return origType.qualType.replaceFirst(scrubbed, 'fn_ptr $scrubbed');
  }

  return origType.qualType.replaceFirst(scrubbed, td.type.qualType);
}

String pointerize(String p) => 'Pointer<$p>';

String ffiType(Decl d, Map<String, Decl> typedefs, Logger log) {
  final t = Type(qualType: desugar(d.type, typedefs));

  String result = t.qualType;
  String replaceWith = '';
  if (t.resemblesNative) {
    final bits = t.bits;
    switch(bits) {
      case 0 : { replaceWith = 'Void'; } break;
      case 8 : { replaceWith = 'nt8'; } break;
      case 16 : { replaceWith = 'nt16'; } break;
      case 32 : { replaceWith = 'nt32'; } break;
      case 64 : { replaceWith = 'nt64'; } break;
      case magic_no_float  : { replaceWith = 'Float'; } break;
      case magic_no_double : { replaceWith = 'Double'; } break;
      default: log.warning("This should (almost) never happen, ${d.id} "
          "is detected as a native scalar,"
          "but does not conform to the usual signature");
    }
    if (bits >= 8 && bits <= 64) {
      replaceWith = '${t.isUnsigned ? 'Ui' : 'I'}$replaceWith';
    }

    result = replaceWith;
  }

  if (result.startsWith('fn_ptr ')) {
    // TODO check if really necessary (the fn ptr is a ptr)
    // otherwise it's pass by value-ish for dart?
    // https://stackoverflow.com/questions/6893285/why-do-function-pointer-definitions-work-with-any-number-of-ampersands-or-as
    result = 'Pointer<NativeFunction<${result.substring(7)}>>';
  }

  if (result.startsWith('union ')) {
    result = result.substring(5);
  }

  if (result.startsWith('struct ')) {
    result = result.substring(6);
  }

  // replace pointers
  if (result.endsWith('*')) {
    result = result.substring(0, result.length - t.hasPointers).trim();
  }

  for (var _i=0; _i<t.hasPointers; _i++) {
    result = pointerize(result);
  }

  return result;
}

final _dartTypeInt = 'int';
final _dartTypeFloat = 'double';
final _ffiBasicType2DartTable = {
  'Void': 'void',
  'Int8': _dartTypeInt,
  'Int16': _dartTypeInt,
  'Int32': _dartTypeInt,
  'Int64': _dartTypeInt,
  'Uint8': _dartTypeInt,
  'Uint16': _dartTypeInt,
  'Uint32': _dartTypeInt,
  'Uint64': _dartTypeInt,
  'Float': _dartTypeFloat,
  'Double': _dartTypeFloat
};

String funStringsFns(String ids, String rawParams, String tdFfi, String tdDart, String funBody) =>
'''
  // ${ids}
  // $rawParams
  // $tdFfi
  // $tdDart
  $funBody
''';

String funStringsTds(String ids, String rawParams, String tdFfi, String tdDart, String funBody) =>
'''
// $ids
// $rawParams
$tdFfi
$tdDart
''';

typedef FunStrings = String Function(String, String, String, String, String);
String funPrep(Decl fun, Map<String, Decl> typedefs, Logger log, [FunStrings fnLayout = funStringsFns]) {
  final parmDecls = <Decl>[];

  final rawFunReturnType = fun.type.qualType.split('(')[0].trim();
  /// Don't remove the empty name param, because 'null' will pop up
  parmDecls.add(Decl(id: fun.id, name: '', type: Type(qualType: rawFunReturnType)));
  fun.gather("ParmVarDecl", parmDecls, cutOff:['CompoundStmt']);

  final rawParams = parmDecls.map((p) => desugar(p.type, typedefs)).toList();

  final ffiParams = <String>[];
  final dartParams = <String>[];
  var isTranslatable2Dart = false;
  for (var p in parmDecls) {
    String pname = p.name ?? String.fromCharCode(Decl.randomLetter(97));

    var translatedFfiType = ffiType(p, typedefs, log);

    ffiParams.add('$translatedFfiType ${pname}');
    var dartType = _ffiBasicType2DartTable[translatedFfiType];

    var hasTranslation = dartType != null;
    isTranslatable2Dart = isTranslatable2Dart || hasTranslation;
    dartParams.add((hasTranslation ? dartType : translatedFfiType) + ' ${pname}');
  }

  var dartTypedef = !isTranslatable2Dart ? "" :
    genTypedef("dart", fun.name, dartParams);

  final ids = fun.id != null ?
    '${fun.id} (${parmDecls.sublist(1).map((p) => p.id).toList().join(', ')})' : '';


  String funName = fun.name;
  String funBody = (fun.useAsTypedef ?? false) ? '' :
  'final ${funName}_${isTranslatable2Dart ? 'dart' : 'ffi'} ${funName} = _fn<${funName}_ffi>("${funName}").asFunction();';

  /// Dart restricts typedefs declarations in types
  return fnLayout(
    ids,
    '${rawParams[0]} (${rawParams.sublist(1).join(', ')})',
    '${genTypedef("ffi", funName, ffiParams)}',
    '${dartTypedef}',
    funBody
  );
}

String genTypedef(String suffix, String funName, List<String> params) =>
'typedef ${funName}_${suffix} = ${params[0].trim()} Function(${params.sublist(1).join(', ')});';

String signatures(List<Decl> funs, List<Decl> typedefs, Logger log) =>
  funs.map((f) => funPrep(f,
    Map.fromIterable(typedefs, key: (t) => t.name, value: (t) => t), log)) // TODO process earlier in the ASTBuilder
    .toList().join('\n\n');

// Add when necessary to see the typedefs
String functionBinding(String importRoot, List<Decl> funs, List<Decl> typedefs, Logger log) =>
'''
import "dart:ffi";
import "dart:io" show Platform;
import 'package:ffi/ffi.dart';
import "$importRoot.t.dart";
import "$importRoot.s.dart";

// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

class Binding {
  final DynamicLibrary lib;

  Binding._(this.lib);
  
  factory fromLibrary(DynamicLibrary lib) =>
    Binding._(lib);
    
  Pointer<NativeFunction<T>> _fn<T extends Function>(String name) {
    return lib.lookup<NativeFunction<T>>(name);
  }

${signatures(funs, typedefs, log)}
}
''';

String declareCommentedTypedefs(funs, typedefs, log) => funs.map((f) => funPrep(f,
    Map.fromIterable(typedefs, key: (t) => t.name, value: (t) => t), log, funStringsTds))
    .toList().join('\n');

String declareTypedefs(String importRoot, List<Decl> funs, List<Decl> typedefs, Logger log) =>
'''
import "dart:ffi";
import '$importRoot.s.dart';
import 'package:ffi/ffi.dart';

// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

${declareCommentedTypedefs(funs, typedefs, log)}
''';


String declareFieldType(Decl field, Map<String, Decl> typedefs, Logger log) {
  final translatedFfiType = ffiType(field, typedefs, log);
  final dartType = _ffiBasicType2DartTable[translatedFfiType];

  return dartType != null ? '@$translatedFfiType() $dartType' :
    translatedFfiType;
}

/// Don't finalize
String declareField(Decl field, Map<String, Decl> typedefs, Logger log) {

  final td = typedefs[field.type.qualType];
  final type = td?.type?.qualType ?? '';
  final generatedType = declareFieldType(field, typedefs, log);

  bool disable = true;
  if (generatedType.startsWith('@')) {
    disable = false;
  }

  // allow multiple pointers
  if (generatedType.contains('Pointer')) {
    if (generatedType.contains('Void')) {
      disable = false;
    }
    if (generatedType.contains('NativeFunction')) {
      disable = false;
    }
    if (generatedType.contains('Float') || generatedType.contains('Double')) {
      disable = false;
    }
    if (generatedType.contains('Uint') || generatedType.contains('Int')) {
      for (var t in ['8', '16', '32', '64']) {
        if (generatedType.contains(t)) {
          disable = false;
          break;
        }
      }
    }
  }

  return '// ${field.id} ${type}'
      '\n  ${disable ? '// ' : ''}${generatedType} ${field.name};';
}

String declareStructMembers(Decl decl, Map<String, Decl> typedefs, Logger log) {

  if (decl?.tagUsed == 'union') {
    return 'Pointer<Void> offset;';
  }

  final fieldsDecl = <Decl>[];
  decl.gather('FieldDecl', fieldsDecl, cutOff: ['CompoundStmt']);

  final fields = fieldsDecl.map((f) => declareField(f, typedefs, log)).toList();

  // disable fields
  for (int i=0; i<fields.length; i++) {
    if (fields[i].lastIndexOf('//') > 0) {
      fields.insert(i, '/*');
      fields.add('*/');
      break;
    }
  }

  return declareStructClass(decl, fields.join('\n  '));
}

String declareStructClass(Decl decl, String fields) =>
'''
// ${decl.id} ${decl?.tagUsed == 'union' ? 'union' : ''}
class ${decl.name} extends Struct {
  $fields
}
''';

/// Note: IntPtr seems to be the the correct representation for size_t:
/// "Represents a native pointer-sized integer in C."
String declareStructs(String importRoot, List<Decl> recordDecls, Map<String, Decl> typedefMap, Logger log) =>
'''
import 'dart:ffi';
import "dart:typed_data";
import "package:ffi/ffi.dart";
import '$importRoot.t.dart';

// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

${recordDecls.map((r) => declareStructMembers(r, typedefMap, log)).toList().join("\n")}
''';

String Function(Record) declareClassFromIrgenRecords(Map<String, Record> ast,
  Map<String, Record> irgen, Logger log) {

  return (Record record) {

    final fieldTypeAndName = record.fields.values.map((v) => '// ${v.desugaredType} ${v.name}\n').join('\n  ');
    final isUnion = record.type == RecordType.union;
    if (isUnion) {
      return
          '// union\n'
          'class ${record.generatedName} extends Struct {\n'
          '  $fieldTypeAndName\n'
          '}\n\n';
    }

    final astRecord = ast[record.identifier] ?? ast[record.generatedName];

    if (astRecord == null) {
      log.warning("No offsets found for ${record} with keys: ${record.identifier} ${record.generatedName}");
    }

    final astFields = astRecord.fields.values.toList();
    astFields.sort((s, t) => s.offset.compareTo(t.offset));
    final offsets = astFields.map((s) => s.offset).toList().join(', ');

    return
      'class ${record.generatedName} extends Struct {\n'
      '  Pointer<Uint8> __origin__;\n' // offsets from AST are in bytes
      '  $fieldTypeAndName\n'
      '}\n\n'
      'extension on ${record.generatedName} {\n'
      '  static final byteOffsets = [ ${offsets} ];\n'
      '}\n\n';
  };


}

String sortIrgenRecords(Map<String, Record> ast, Map<String, Record> irgen, Logger log) {

  final uniqIrgen = Set<Record>.from(irgen.values);

  // ascending (it won't impact the offsets in any way, just easier to debug)
  final irgenList = uniqIrgen.toList();
  irgenList.sort((s, t) => s.counter.compareTo(t.counter));

  final generate = declareClassFromIrgenRecords(ast, irgen, log);
  return irgenList.map((i) => generate(i)).toList().join('\n');
}

String declareExtensions(String importRoot,
    Map<String, Record> ast, Map<String, Record> irgen, Logger log) =>
'''
import 'dart:ffi';
import "dart:typed_data";
import "package:ffi/ffi.dart";
//import '$importRoot.t.dart'; // TODO decide to keep or remove

// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

${sortIrgenRecords(ast, irgen, log)}

''';