import 'serializers.dart';

String opCodeWithInteger(Decl e, int i) {
  if (e.inner == null) return "";

  final list = <Decl>[];
  e.watch("IntegerLiteral", list);

  if (list.isEmpty) return " = $i";

  final literal = list[0];

  return " = ${literal.opcode ?? ""}${literal.value}";
}

String enumToClass (Decl e) {
  if (e.inner == null) return "";

  final constants = <Decl>[];
  e.watch("EnumConstantDecl", constants);

  int i = 0;

  return '''
  class ${e.name} {
    ${constants.map((c) => 'static const int ${c.name}${opCodeWithInteger(c, i++)};').toList().join("\n")}
  }
  ''';
}
