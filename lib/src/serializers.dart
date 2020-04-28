import 'package:json_annotation/json_annotation.dart';

part 'serializers_generated.dart';

class Type {
  final String desugaredQualType, qualType, typeAliasDeclId;
  const Type({this.desugaredQualType, this.qualType, this.typeAliasDeclId});

  factory Type.fromJson(Map<String, dynamic> json) => _$TypeFromJson(json);

  @override
  String toString() {
    return """${qualType} ${desugaredQualType}""";
  }
}

class Decl {
  final String id, kind, tagUsed, name, opcode;
  final List<Decl> inner;
  final Type type;
  final String valueCategory, value;

  const Decl({this.id, this.kind, this.tagUsed, this.name, this.opcode, this.inner, this.type, this.valueCategory, this.value});

  factory Decl.fromJson(Map<String, dynamic> json) => _$DeclFromJson(json);

  @override
  String toString() {
    return """${kind} ${type}""";
  }

  String concatTree(List<String> group, int depth) {

    group.add("  " * depth);
    group.add(toString());

    if (inner != null) {
      inner.forEach((n) { n.concatTree(group, depth+1); });
    }

    return group.join("\n");
  }
}