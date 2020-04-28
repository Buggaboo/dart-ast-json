import 'package:build/build.dart';
import 'dart:convert' show JsonDecoder, JsonEncoder;
import 'package:glob/glob.dart';

import 'package:dart_ast_json/src/serializers.dart';

enum Infix {
  e, f, s
}

// TODO put in a util in the future
String removeTag(Infix i) => i.toString().substring(i.toString().indexOf('.')+1);

class ASTResolver implements Builder {

  static final outputs = Infix.values.map((s) => '''.${removeTag(s)}.json''').toList();

  static final jsonDecoder = JsonDecoder();
  static final jsonEncoder = JsonEncoder();

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
    root.concatTree(0, log);

    final enumList = <Decl>[];
    final structList = <Decl>[];
    final functionList = <Decl>[];

    root.watch("EnumDecl", enumList);
    writeJson(step, inputId, enumList, Infix.e.index);

    root.watch("FunctionDecl", functionList);
    writeJson(step, inputId, functionList, Infix.f.index);

    // TODO why doesn't the RecordDecl contain its own name?
    root.watch("RecordDecl", structList);
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

  const _Builder(this.infix);

  get _buildExtensions {
    final untagged = removeTag(this.infix);
    return {'''.${untagged}.json''' : [''''.${untagged}.g.dart''']};
  }

  @override
  Map<String, List<String>> get buildExtensions => _buildExtensions;

}

class EnumBuilder extends _Builder {

  const EnumBuilder(): super(Infix.e);

  @override
  Future<void> build(BuildStep step) async {
  }
}

class FunctionBuilder extends _Builder {

  const FunctionBuilder(): super(Infix.f);

  @override
  Future<void> build(BuildStep step) async {
  }
}

class StructBuilder extends _Builder {

  const StructBuilder(): super(Infix.s);

  @override
  Future<void> build(BuildStep step) async {
  }
}
