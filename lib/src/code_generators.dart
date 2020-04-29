import 'serializers.dart';
import 'package:logging/logging.dart' show Logger;

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
      log.warning('Found enum with missing name');
    }
  }

  int i = 0;

  var addWarning = (Decl d) => d.find("BinaryOperator") == null ?
    "" : "/* please check */ ";

  final fields = constants.map((c) =>
  '${addWarning(c)}static const int ${c.name}${opCodeWithInteger(c, i++)};')
      .toList().join("\n  ");

  final classDef = '''/* ${e.id} */\nclass ${e.name} {
  ${fields}\n}\n''';

  return '${disable ? "/*\n" : ""}$classDef${disable ? "*/\n" : ""}';
}
