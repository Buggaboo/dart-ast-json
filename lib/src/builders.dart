import 'package:build/build.dart';
import 'dart:convert' show JsonDecoder, JsonEncoder;
import 'package:glob/glob.dart';

import 'package:dart_ast_json/src/code_generators.dart';
import 'package:dart_ast_json/src/serializers.dart';
import 'parser.dart';

final jsonDecoder = JsonDecoder();
final jsonEncoder = JsonEncoder();

enum Infix {
  e, f, s, t
}

String removeTag(Infix i) =>
    i.toString().substring(i.toString().indexOf('.') + 1);

class ASTResolver implements Builder {

  static final outputs = Infix.values.map((s) => '.${removeTag(s)}json').toList();

  @override
  final buildExtensions = {
    '''.json''': outputs
  };

  // sanitize double accounting of types etc.
  static Type simplifyType(Type old) {
    if ((old.isEnum || old.isStruct) || old.isUnion) {
      return Type(qualType: old.qualType);
    }

    // this is usually accompanied by 'typeAliasDeclId'
    if (old.desugaredQualType != null /* && typeAliasDeclId?.isNotEmpty */) {
      return Type(qualType: old.desugaredQualType);
    }

    return Type(qualType: old.qualType);
  }

  static Decl simplifyDeclType(Decl decl) {
    return Decl(
      id: decl.id,
      name: decl.name,
      type: simplifyType(decl.type)
    );
  }

  @override
  Future<void> build(BuildStep step) async {
    final inputId = step.inputId;

    // TODO stream this instead, also the conversion
    // if there's a perf penalty, tested with ~512mb JSON file, seems okay
    final inputString = await step.readAsString(inputId);
    final astJson = jsonDecoder.convert(inputString);
    final root = Decl.fromJson(astJson);

    // Debugging
//    root.concatTree(0, log);

    final enumDeclList = <Decl>[];
    final enumTypeList = <Decl>[];
    final structList   = <Decl>[];
    final functionList = <Decl>[];
    final typedefList  = <Decl>[];

    root.gather("EnumDecl", enumDeclList,
        cutOff: ['FunctionDecl', 'CompoundStmt', 'RecordDecl']);
    // EnumType contains the actual names
    root.gather("EnumType", enumTypeList,
        cutOff: ['FunctionDecl', 'CompoundStmt', 'RecordDecl']);

    final typedefEnumNames = Map.fromIterable(
        enumTypeList.where((e) => e.decl != null && e.type != null).toList(),
        key: (e) => e.decl.id, value: (e) => e.type.qualType);

    // assign "-" to enum values
    final enumConstants = <Decl>[];
    enumDeclList.forEach((e) { e.gather("UnaryOperator", enumConstants); });
    enumConstants.forEach((e) {
      e.find("IntegerLiteral").opcode = e.opcode;
    });

    enumDeclList
        .where((e) => e.name == null).toList()
        .forEach((e) { e.name = typedefEnumNames[e.id]; });

    writeJson(step, inputId, enumDeclList, Infix.e.index);

    /// Cut off for nested TypedefDecl in FunctionDecls
    root.gather("TypedefDecl", typedefList,
        cutOff: ['FunctionDecl', 'CompoundStmt', 'RecordDecl']);

    final simpleTypedefList = typedefList.map((t) => simplifyDeclType(t)).toList();

    final filtered = simpleTypedefList.where((t) =>
        !t.type.qualType.contains('(')
    ).toList();

    final filteredFunPtrs = simpleTypedefList.where((t) =>
        t.type.qualType.contains('(') &&
        (t.type.qualType.indexOf(')') + 1) == t.type.qualType.lastIndexOf('(')
    ).toList();

//    print(filteredFunPtrs);
//    print('====');

    final extractable = simpleTypedefList.where((t) =>
      t.type.qualType.contains('(') &&
      (t.type.qualType.indexOf(')') + 1) < t.type.qualType.lastIndexOf('(') &&
      !t.type.qualType.contains('anonymous') && // struct (anonymous...
      !t.type.qualType.startsWith('__')
    ).toList();

//    print(extractable);

    extractNestedFunPtrs(extractable, filtered..addAll(filteredFunPtrs));
    writeJson(step, inputId, filtered, Infix.t.index);

    /// Cut off for nested FunctionDecls in CompoundStmts (aka function body)
    // TODO ignore FunctionDecl within FunctionDecl (premature opt?)
    root.gather("FunctionDecl", functionList, cutOff: ['CompoundStmt']);
    // filter out underscored functions
    writeJson(step, inputId,
        functionList.where((f) => !f.name.startsWith("_")).toList(), Infix.f.index);

    /// Cut off for nested RecordDecl in FunctionDecl,
    /// i.e. structs in the function body)
    // TODO match by Decl.id on the typedefs, i.e. both for enums and structs
    root.gather("RecordDecl", structList, cutOff: ['FunctionDecl', 'CompoundStmt']);
    writeJson(step, inputId, structList, Infix.s.index);
  }

  writeJson(BuildStep step, AssetId assetId, List<Decl> list, int index) async {
    final json = jsonEncoder.convert(list.map((e) => e.toJson()).toList());
    final newAssetId = assetId.changeExtension(outputs[index]);
    await step.writeAsString(newAssetId, json);
  }

}

abstract class _Builder implements Builder {

  final Infix infix;

  String get output => '.${removeTag(this.infix)}.dart';

  const _Builder(this.infix);

  get _buildExtensions {
    final untagged = removeTag(this.infix);
    return {'.${untagged}json' : [output]};
  }

  @override
  Map<String, List<String>> get buildExtensions => _buildExtensions;

  Future<List<Decl>> listDecl(BuildStep step, AssetId inputId) async {
    final inputString = await step.readAsString(inputId);
    final listOfMaps = jsonDecoder.convert(inputString);

    final result = <Decl>[];

    // using a forEach instead of map due to List<dynamic> result
    listOfMaps.forEach((i) { result.add(Decl.fromJson(i)); });

    return result;
  }

}

class EnumBuilder extends _Builder {

  const EnumBuilder(): super(Infix.e);

  @override
  Future<void> build(BuildStep step) async {

    final inputId = step.inputId;
    final enumDecls = await listDecl(step, inputId);

    await step.writeAsString(inputId.changeExtension(output),
        enumDecls.map((e) => enumToClass(e, log)).toList().join("\n"));
  }
}

class FunctionBuilder extends _Builder {

  const FunctionBuilder(): super(Infix.f);

  @override
  Future<void> build(BuildStep step) async {

    final inputId = step.inputId;
    final functionDecls = await listDecl(step, inputId);

    final typeDefsInputId = await step.findAssets(new Glob('**tjson')).first;
    final typedefDecls = await listDecl(step, typeDefsInputId);

    var functionFromTypedefs = typedefDecls.where(
        (t) =>
            (!t.name.startsWith('__') && // skip internal typedefs
            !t.type.qualType.startsWith('__')) && // skip internal types
            t.type.qualType.contains('(')) // most likely a typedef for a function (ptr) type
            .map((d) => Decl.fromTypedefDecl2FunctionDecl(d)).toList();

    await step.writeAsString(inputId.changeExtension(output),
        functionBinding(functionFromTypedefs + functionDecls, typedefDecls, log));

  }
}

/// Also translates unions
class StructBuilder extends _Builder {

  const StructBuilder(): super(Infix.s);

  @override
  Future<void> build(BuildStep step) async {

  }
}
