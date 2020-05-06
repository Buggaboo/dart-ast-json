import 'serializers.dart';
import 'package:logging/logging.dart' show Logger;

// IDEA: TODO use @annotation to generate what you need

String opCodeWithInteger(Decl e, int i) {
  if (e.inner == null) return " = $i";

  final list = <Decl>[];
  e.gather("IntegerLiteral", list);

  if (list.isEmpty) return " = $i";

  final literal = list[0];

  return " = ${literal.opcode ?? ""}${literal.value ?? i}";
}

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
    "" : " /* TODO check actual value ${d.id} */";

  final fields = constants.map((c) =>
    'static const int ${c.name}${opCodeWithInteger(c, i++)};${addWarning(c)}')
    .toList().join("\n  ");

  final classDef =
  '''
  /* ${e.id} */
  class ${e.name} {
    ${fields}
  }
  
  ''';

  return disable ?
    '''
    /*
    $classDef
    */
    ''' : classDef;
}

// TODO remove
/** Example
  typedef obx_query_visit_native_t = Int32 Function(Pointer<Void> query,
    Pointer<NativeFunction<obx_data_visitor_native_t>> visitor, Pointer<Void> user_data, Uint64 offset, Uint64 limit);

  typedef obx_query_visit_dart_t = int Function(Pointer<Void> query,
    Pointer<NativeFunction<obx_data_visitor_native_t>> visitor, Pointer<Void> user_data, int offset, int limit);
*/

String desugar(Type origType, Map<String, Decl> typedefs) {
  final scrubbed = origType.scrubbed;
  final typedef = typedefs[scrubbed];
  if (typedef == null) { return origType.qualType; }

  // function pointer
  if (typedef.type.qualType.contains('(*)')) {
    return origType.qualType.replaceAll(scrubbed, 'fn_ptr $scrubbed');
  }

  return origType.qualType.replaceAll(scrubbed, typedef.type.qualType);
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

String funPrep(Decl fun, Map<String, Decl> typedefs, Logger log) {
  final parmDecls = <Decl>[];

  final rawFunReturnType = fun.type.qualType.split('(')[0].trim();
  // Don't remove the empty name param, because 'null' will pop up
  parmDecls.add(Decl(id: fun.id, name: '', type: Type(qualType: rawFunReturnType)));
  fun.gather("ParmVarDecl", parmDecls, cutOff:['CompoundStmt']);

  final rawParams = parmDecls.map((p) => desugar(p.type, typedefs)).toList();

  final ffiParams = <String>[];
  final dartParams = <String>[];
  var isTranslatable2Dart = false;
  for (var p in parmDecls) {
    var translatedFfiType = ffiType(p, typedefs, log);

    ffiParams.add('$translatedFfiType ${p.name}');
    var dartType = _ffiBasicType2DartTable[translatedFfiType];

    var hasTranslation = dartType != null;
    isTranslatable2Dart = isTranslatable2Dart || hasTranslation;
    dartParams.add((hasTranslation ? dartType : translatedFfiType) + ' ${p.name}');
  }

  var dartTypedef = !isTranslatable2Dart ? "" :
    genTypedef("dart", fun.name, dartParams);

  final ids = fun.id != null ?
    '${fun.id} (${parmDecls.sublist(1).map((p) => p.id).toList().join(', ')})' : '';


  // TODO log.warning("Detected anonymous struct");

  return
    '''
    /*
    // ${ids}
    // ${rawParams[0]} (${rawParams.sublist(1).join(', ')})
    ${genTypedef("ffi", fun.name, ffiParams)}
    ${dartTypedef}
    */
    ''';
}

String genTypedef(String suffix, String funName, List<String> params) =>
'typedef ${funName}_${suffix} = ${params[0].trim()} Function(${params.sublist(1).join(', ')});';

String signatures(List<Decl> funs, List<Decl> typedefs, Logger log) =>
'''
${funs.map((f) => funPrep(f,
    Map.fromIterable(typedefs, key: (t) => t.name, value: (t) => t), log))
    .toList().join('\n\n')}
''';

String functionBinding(List<Decl> funs, List<Decl> typedefs, Logger log) =>
'''
import "dart:ffi";
import "dart:io";
import "dart:typed_data"
import 'package:ffi/ffi.dart';

class Binding {
  final DynamicLibrary lib;

  Binding._(this.lib);
  
  factory fromLibrary(DynamicLibrary lib) =>
    Binding._(lib);

  /*
  ${typedefs.map((s) => '${s.name}: ' + s.type.toString()).toList().join("\n  ")}
  */
    
  ${signatures(funs, typedefs, log)}
}
''';
