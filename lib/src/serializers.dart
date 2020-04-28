import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart' show Logger;

part 'serializers_generated.dart';

class Type {
  final String desugaredQualType, qualType, typeAliasDeclId;
  const Type({this.desugaredQualType, this.qualType, this.typeAliasDeclId});

  factory Type.fromJson(Map<String, dynamic> json) => _$TypeFromJson(json);

  Map<String, dynamic> toJson() => _$TypeToJson(this);

  @override
  String toString() {
    return """${qualType} ${desugaredQualType ?? ""}""";
  }
}

class Decl {
  final String id, kind, tagUsed, name, opcode;
  final List<Decl> inner;
  final Type type;
  final String valueCategory, value;

  const Decl({this.id, this.kind, this.tagUsed, this.name, this.opcode, this.inner, this.type, this.valueCategory, this.value});

  factory Decl.fromJson(Map<String, dynamic> json) => _$DeclFromJson(json);

  Map<String, dynamic> toJson() => _$DeclToJson(this);

  @override
  String toString() {
    return """${id} ${kind} ${name} ${type}""";
  }

  void concatTree(int depth, Logger logger) {

    // ignore comments
    if ("FullComment" == kind) { return; };

    final str = ("  " * depth) + toString();

    if (logger != null) {
      logger.info(str);
    }

    if (inner != null) {
      switch(kind) {
        case "FunctionDecl" :
          break; // ignore the implementation details
        case "FullComment" :
          break;
        case "FunctionProtoType":
          break;
        default:
          inner.forEach((n) { n.concatTree(depth + 1, logger); });
      }
    }
  }

  void watch(String kind, List<Decl> list) {

    if (this.kind == kind) {
      list.add(this);
    }

    if (inner != null) {
      switch(kind) {
        case "FullComment" :
          break;
        default:
          inner.forEach((n) { n.watch(kind, list); });
      }
    }
  }
}