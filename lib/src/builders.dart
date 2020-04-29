import 'package:build/build.dart';
import 'dart:convert' show JsonDecoder, JsonEncoder;
import 'package:glob/glob.dart';

import 'package:dart_ast_json/src/serializers.dart';
import 'package:dart_ast_json/src/code_generators.dart';

final jsonDecoder = JsonDecoder();
final jsonEncoder = JsonEncoder();

enum Infix {
  e, f, s
}

String _removeTag(Infix i) => i.toString().substring(i.toString().indexOf('.')+1);

class ASTResolver implements Builder {

  static final outputs = Infix.values.map((s) => '''.${_removeTag(s)}json''').toList();


  @override
  final buildExtensions = {
    '''.json''': outputs
  };

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

    root.gather("EnumDecl", enumDeclList);
    root.gather("EnumType", enumTypeList); // contains the actual names

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

    root.gather("TypedefDecl", typedefList);
    writeJson(step, inputId, typedefList, Infix.t.index);

    root.gather("FunctionDecl", functionList);
    writeJson(step, inputId, functionList, Infix.f.index);

    // TODO why doesn't the RecordDecl contain its own name? Same thing for the enum
    root.gather("RecordDecl", structList);
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

  String get output => '.${_removeTag(this.infix)}.dart';

  const _Builder(this.infix);

  get _buildExtensions {
    final untagged = _removeTag(this.infix);
    return {'''.${untagged}json''' : [output]};
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

    await step.writeAsString(inputId.changeExtension(output),
        functionBinding(functionDecls, typedefDecls, log));

  }
}

class StructBuilder extends _Builder {

  const StructBuilder(): super(Infix.s);

  @override
  Future<void> build(BuildStep step) async {
  }
}
