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
  // we want to modify these, in case its empty (e.g. typedef'ed types)
  // or initialized elsewhere (e.g. opcode)
  String name, opcode;
  final String id, kind, tagUsed;
  final Type type;
  final Decl decl;
  final List<Decl> inner;
  final String valueCategory, value;

  Decl({this.id, this.kind, this.tagUsed, this.name, this.opcode, this.decl, this.inner, this.type, this.valueCategory, this.value});

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

  Decl find(String kind) {
    if (inner != null) {
      for (Decl e in inner) {
        if (kind == e.kind) {
          return e;
        }
      }

      for (Decl e in inner) {
        return e.find(kind);
      }
    }
    return null;
  }
}