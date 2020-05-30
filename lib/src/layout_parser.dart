import 'package:petitparser/petitparser.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

final space = char(' ');

final wordPlusFlatten = word().plus().flatten();

final digitPlus = digit().plus();
final digitPlusFlatten = digitPlus.flatten();

final pointer = char('*');
final array = (char('[') & digitPlus & char(']')).flatten();
final basicType = (char('_').star() & letter() & word().star()).flatten();
final type = (string('const ').optional() | string('volatile ')) & basicType &
  (space & pointer.star().flatten() & array.star().flatten()).optional();

// TODO reimplement as: fnPtr = undefined(); fnPtr.set(...);
// let's hope we never bump into a fn ptr, with a fn ptr as an argument
// we have an extractor tho...
final fnPtr = (basicType & (space & pointer.star()).flatten() &
string('(*)(') & type & (string(', ') & type).star() & char(')')).flatten();

class AstRecordLayoutPatterns {
  static final first = string('*** Dumping AST Record Layout');
  static final structOrUnion = ((string('struct') | string('union')) & space).pick(0);
  static final anonIdentifier = (noneOf(":").plus().flatten() & char(':') &
    digitPlusFlatten & char(':') & digitPlusFlatten).flatten();
  static final anon = structOrUnion & (string('(anonymous at ') & anonIdentifier & char(')')).pick(1);
  static final anonAndNested = structOrUnion &
    wordPlusFlatten & (string('::(anonymous at ') & anonIdentifier & char(')')).pick(1);

  static final second = (string('0 | ') & (anonAndNested | anon | wordPlusFlatten)).pick(1);
  static final offsetBitFieldRange = (digitPlusFlatten & char(':')).pick(0) & (digitPlusFlatten & char('-')).pick(0) & digitPlusFlatten;
  static final offsets = offsetBitFieldRange | digitPlusFlatten;
  static final fieldPattern = (offsets & string(' |   ')).pick(0) & (word().plus() & any().plus()).flatten();

/// Too complicated, you just want the last word
//  static final fieldPattern = prefix &
//    (((fnPtr & space & wordPlusFlatten)..pick(2))
//        .or((type & space & wordPlusFlatten)..pick(2))
//        .or((basicType & space & wordPlusFlatten).pick(2)));

  static final last = (string('| [sizeof=') & digitPlusFlatten).pick(1) & (string(', align=') & digitPlusFlatten & char(']')).pick(1);
}

class IRgenRecordLayoutPatterns {
  static final lineNumber = (string('line:') & digitPlus & char(':') & digitPlus).flatten();
  static final colNumber = (string('col:') & digitPlus).flatten();
  static final definition = (string(' union ') | string(' struct ')) & (wordPlusFlatten & space).optional() & string('definition');
  static final first = string('*** Dumping IRgen Record Layout');
  static final hexId = (string('0x') & word().plus()).flatten();
  static final second = string('Record: RecordDecl ') &
    ((hexId & string(' prev ') & hexId) | hexId) &
    string(' <') & noneOf(',').plus().flatten() & string(', ') & (lineNumber | colNumber) &
    string('> ') & (lineNumber | colNumber) &
    (
        string(' struct definition') | string(' union definition') |
        ((string(' struct ') & wordPlusFlatten & string(' definition')).pick(1)) |
        (string(' union ') & wordPlusFlatten & string(' definition')).pick(1)
    );

  static final startApost = string(" '");
  static final middleApost = string("':'");
  static final endApost = char("'");
  static final nonOfApostPlus = noneOf("'").plus().flatten();

  static final fieldPattern = (string('`-') | string('|-')) & string('FieldDecl ') &
    hexId & (string(' <') & noneOf('>').plus() & string('> ') & colNumber).flatten() &
    (string(' referenced ') | space) & wordPlusFlatten &
    (
      (startApost & nonOfApostPlus & middleApost & nonOfApostPlus & endApost).pick(3) |
      (startApost & nonOfApostPlus & endApost).pick(1)
    );
}

class CGRecordLayoutPatterns {
  // we don't use these types due to info loss
  // also bitfields can be derived from the AST Record
  static final first = string('Layout: <CGRecordLayout');

  static final recordType = string('%struct.') | string('%union.');
  static final LLVMTypePattern = string('LLVMType:') & recordType & wordPlusFlatten &
  (char('.') & digit().plus()).optional() &
  (string(' = type { ') & noneOf('}').plus().flatten().trim() & string('}')).pick(1);

  static final penultimatelyIgnored = string("IsZeroInitializable:") |
    string('BitFields:[') | string("<CGBitFieldInfo");

  static final last = string(']>');
}

class Field {
  final String name;
  final int offset;
  final int bitFieldStart, bitFieldEnd;

  // known from IRgen
  String declId;
  String type, desugaredType;

  Field(this.name, this.type, this.offset, [this.bitFieldStart,this.bitFieldEnd]);

  factory Field.fromParserResult(List<dynamic> result) {
    final r1 = result[1];
    final split = r1.lastIndexOf(' ');
    final name = r1.substring(split + 1);
    final type = r1.substring(0, split);

    if (result[0] is List<dynamic>) {
      List<dynamic> rr = result[0];
      return Field(name, type, int.parse(rr[0]), int.parse(rr[1]), int.parse(rr[2]));
    }else {
      final r0 = result[0] as String;
      return Field(name, type, int.parse(r0));
    }
  }

  @override
  String toString() => '$name, $type, $offset, $bitFieldStart, $bitFieldEnd';
}

enum RecordType {
  struct, union
}

class Record {

  final String identifier;
  final bool isAnon;
  final fields = <Field>{};
  final String parentIdentifier;

  // known from IRgen
  // this can be used for debugging, when considering
  // generating a new class (e.g. project_arch_os.s.dart) // TODO
  String declId;

  // known from CG
  String generatedName; // e.g. struct_anon_23, union_anon_20, ma_channel_converter
  RecordType type;// if anon the type is declared on the 1st line in AST, otherwise no.
  // although offset 0 for all fields, is a strong clue // TODO

  Record(this.identifier, [this.isAnon = false, this.type, this.parentIdentifier = null]);

  static RecordType typeFromString(String s) =>
    s == 'struct' ? RecordType.struct : RecordType.union;

  factory Record.fromParserResult(dynamic result) {
    if (result is String) {
      return Record(result);
    }

    final rtype = typeFromString(result[0]);

    if (result is List) {
      if (result.length == 2) {
        return Record(result[1], true, rtype);
      }

      if (result.length == 3) {
        return Record(result[2], true, rtype, result[1]);
      }
    }

    throw Exception("Bad result from parser");
  }

  @override
  String toString() => '$identifier, $isAnon, $type, $parentIdentifier';
}

// poor person's state machine
final transitions = <Parser, List<Parser>>{
  AstRecordLayoutPatterns.first : [ AstRecordLayoutPatterns.second ],
  AstRecordLayoutPatterns.second : [ AstRecordLayoutPatterns.fieldPattern ],
  // TODO do cheap check when ignoring fields
  AstRecordLayoutPatterns.fieldPattern : [ AstRecordLayoutPatterns.fieldPattern, AstRecordLayoutPatterns.last ],
  AstRecordLayoutPatterns.last : [ AstRecordLayoutPatterns.first, IRgenRecordLayoutPatterns.first ],
  IRgenRecordLayoutPatterns.first : [ IRgenRecordLayoutPatterns.second ],
  IRgenRecordLayoutPatterns.second : [ IRgenRecordLayoutPatterns.fieldPattern ],
  // TODO do cheap check when ignoring fields
  IRgenRecordLayoutPatterns.fieldPattern : [ IRgenRecordLayoutPatterns.fieldPattern, CGRecordLayoutPatterns.first ],
  CGRecordLayoutPatterns.first : [ CGRecordLayoutPatterns.LLVMTypePattern ],
  CGRecordLayoutPatterns.LLVMTypePattern : [ CGRecordLayoutPatterns.penultimatelyIgnored ],
  CGRecordLayoutPatterns.penultimatelyIgnored : [ CGRecordLayoutPatterns.penultimatelyIgnored, CGRecordLayoutPatterns.last ],
  CGRecordLayoutPatterns.last : [ AstRecordLayoutPatterns.first, IRgenRecordLayoutPatterns.first ]
};