import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart' show Logger;
import 'toolbox.dart';

part '_serializers.dart';

final ASTERISK = '*'.codeUnitAt(0);
int countPointersBackwards(String s) {
  var counter = 0;
  for (var i = 0; i<s.length; i++) {
    if (s.codeUnitAt(s.length - (1 + i)) == ASTERISK) {
      counter++;
    }else {
      return counter;
    }
  }
}

// TODO also offer a UTF8 version of types that contain char
const magic_no_float = 1337;
const magic_no_double = 1338;

final NativeScalar = {
  'void' : 0, 'char': 8, 'short': 16, 'int': 32, 'long': 64,
  'float' : magic_no_float, 'double': magic_no_double,
  'int8_t': 8, 'int16_t': 16, 'int32_t': 32, 'int64_t': 64,
  'uint8_t': 8, 'uint16_t': 16, 'uint32_t': 32, 'uint64_t': 64,
  'long long' : 64, // at least 64-bit...
  'size_t': 32 // TODO correct this
};

class Type {
  final String desugaredQualType, qualType, typeAliasDeclId;
  const Type({this.desugaredQualType, this.qualType, this.typeAliasDeclId});

  factory Type.fromJson(Map<String, dynamic> json) => _$TypeFromJson(json);

  Map<String, dynamic> toJson() => _$TypeToJson(this);

  @override
  String toString() {
    return '$qualType ; ${desugaredQualType ?? ""}';
  }

  // remove useless symbols to us
  String get basicType =>
    (desugaredQualType ?? qualType)
        .replaceAll('volatile ', '')
        .replaceAll('const ', '')
        .trim();

  // remove:
  // - signed / unsigned
  // - asterisks
  String get scrubbed => basicType
      .replaceAll('*', '')
      .replaceAll('unsigned ', '')
      .replaceAll('signed ', '')
      .trim();

  bool get resemblesNative => NativeScalar[scrubbed] != null;

  // float: 1337, double: 1338
  int get bits => NativeScalar[scrubbed];

  bool get isEnum =>
    qualType.startsWith("enum ");

  bool get isUnion =>
    qualType.contains("union ");

  bool get isStruct =>
    qualType.contains("struct ");

  bool get isFuncPtr =>
    qualType.replaceAll('const', '').contains("(*)(");

  bool get isUnsigned {
    if (basicType.contains("unsigned ")) {
      return true;
    }

    if (basicType.contains("uint")) {
      return true;
    }

    return false;
  }

  int get hasPointers =>
    countPointersBackwards(desugaredQualType ?? qualType);
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

  void gather(String kind, List<Decl> list) {
    if (this.kind == kind) {
      list.add(this);
    }

    if (inner != null) {
      switch(kind) {
        case "FullComment" :
          break;
        default:
          inner.forEach((n) { n.gather(kind, list); });
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