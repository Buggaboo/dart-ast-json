import 'package:logging/logging.dart' show Logger;
import 'dart:math' show Random;

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
  return 0;
}

int normalizeSymbol(int i) {
  if (i < 48) {
    return 48; // corrective
  }

  if (i < 58) {
    return i;
  }

  if (i < 65) {
    return 65;
  }

  if (i < 91) {
    return i;
  }

  if (i < 97) {
    return 97;
  }

  if (i < 123) {
    return i;
  }

  return i % 48;
}

// TODO also offer a UTF8 version of types that contain char
const magic_no_float = 1337;
const magic_no_double = 1338;

final NativeScalar = {
  'void' : 0, 'char': 8, 'short': 16, 'int': 32, 'long': 64,
  'float' : magic_no_float, 'double': magic_no_double,
  'long long' : 64, // at least 64-bit...
  'size_t': 32
};

class Type {
  final String desugaredQualType, qualType, typeAliasDeclId;
  const Type({this.desugaredQualType, this.qualType, this.typeAliasDeclId});

  factory Type.fromJson(Map<String, dynamic> json) => _$TypeFromJson(json);

  Map<String, dynamic> toJson() => _$TypeToJson(this);

  @override
  String toString() {
    return '$qualType ; ${desugaredQualType ?? ""}'.trim();
  }

  // remove:
  // - signed / unsigned
  // - asterisks
  String get scrubbed => qualType
      .replaceAll('*', '')
      .replaceFirst('unsigned ', '')
      .replaceFirst('signed ', '')
      .replaceFirst('restrict', '')
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
    qualType.contains("(*)");

  bool get isUnsigned {
    if (qualType.contains("unsigned ")) {
      return true;
    }

    /// Clang: char is signed on x86
    /// unsigned on an arm target.
//    if (qualType.contains("signed char")) {
//      return false;
//    }

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
  final bool useAsTypedef; // don't actually generate a function for this

  Decl({this.id, this.kind, this.tagUsed, this.name, this.opcode, this.decl,
    this.inner, this.type, this.valueCategory, this.value, this.useAsTypedef});

  factory Decl.fromJson(Map<String, dynamic> json) => _$DeclFromJson(json);

  static final random = Random(1337);
  static int randomLetter(int code) {
    return code + random.nextInt(5);
  }

  /// For the purpose of generating function ptr typedefs for dart
  factory Decl.fromTypedefDecl2FunctionDecl(Decl decl) {
    assert(decl.kind == 'TypedefDecl');

    // Replacing first, due to nested fun ptrs
    final qualType = decl.type.qualType.replaceFirst('(*)', '');
    final paramGroup = qualType
        .substring(qualType.indexOf('(') + 1, qualType.length - 1);
    List<Decl> parmVarDecls = 'void' != paramGroup ? paramGroup
        .split(', ').map((p) => Decl(
          name:
            String.fromCharCode(normalizeSymbol(randomLetter(p[0].codeUnitAt(0))))
          , kind: 'ParmVarDecl'
          , type: Type(qualType: p))).toList() : [];
    return Decl(
        useAsTypedef: true,
        kind: 'FunctionDecl',
        name: decl.name,
        type: Type(qualType: qualType),
        inner: parmVarDecls
    );
  }

  Map<String, dynamic> toJson() => _$DeclToJson(this);

  @override
  String toString() {
    return '${id} ${kind} ${name}, type: ${type}';
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
        case "CompoundStmt" :
          break; // ignore the implementation details
        case "FunctionProtoType":
          break;
        default:
          inner.forEach((n) { n.concatTree(depth + 1, logger); });
      }
    }
  }

  void gather(String kind, List<Decl> list, {List<String> cutOff}) {
    if (this.kind == 'FullComment') {
      return;
    }else if(cutOff != null && cutOff.contains(this.kind)) {
      return;
    }else if (this.kind == kind) {
      list.add(this); // 1st case
      return; // once you've found it, do not go further
    }

    if (inner != null) {
      for (var n in inner) {
        n.gather(kind, list, cutOff:cutOff); // recursion case
      }
    }
  }

  Decl find(String kind) {
    if (this.kind == 'FullComment') {
      return null;
    }

    if (this.kind == kind) {
      return this;
    }

    Decl firstResult;
    if (inner != null) {
      for (Decl e in inner) {
        firstResult = e.find(kind);
        if (firstResult != null) {
          return firstResult;
        }
      }
    }

    return null;
  }
}