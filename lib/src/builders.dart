import 'package:build/build.dart';
import 'dart:convert' show JsonDecoder;
import 'package:glob/glob.dart';

import 'package:dart_ast_json/src/serializers.dart';

enum Infix {
  e, f, s
}

// TODO put in a util in the future
String removeTag(Infix i) => i.toString().substring(i.toString().indexOf('.')+1);

class ASTResolver implements Builder {

  static final outputs = Infix.values.map((s) => '''.${removeTag(s)}.txt''').toList();

  static final jsonDecoder = JsonDecoder();

  @override
  final buildExtensions = {
    '''.json''': outputs
  };

  @override
  Future<void> build(BuildStep step) async {
    final inputId = step.inputId;

    // TODO stream this instead, if there's a perf penalty
//    final inputStream = File(inputId).openRead();
//    final await convertStream = JsonDecoder.bind(inputStream);

    final inputString = await step.readAsString(inputId);
    final astJson = jsonDecoder.convert(inputString);

    final enumAssetId = inputId.changeExtension(outputs[Infix.e.index]);

    final str = Decl.fromJson(astJson).concatTree(<String>[], 0, log);

    await step.writeAsString(enumAssetId, str);

    final functionAssetId = inputId.changeExtension(outputs[Infix.f.index]);
    await step.writeAsString(functionAssetId, '''test start''');

    final structAssetId = inputId.changeExtension(outputs[Infix.s.index]);
    await step.writeAsString(structAssetId, '''test start''');
  }


}

abstract class _Builder implements Builder {

  final Infix infix;

  const _Builder(this.infix);

  get _buildExtensions {
    final untagged = removeTag(this.infix);
    return {'''.${untagged}.txt''' : [''''.${untagged}.g.dart''']};
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
