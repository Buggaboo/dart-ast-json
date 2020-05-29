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
  static final recordName = (string('struct ') | string('union ')).trim() &
    wordPlusFlatten &
    ((string('::(anonymous at ') &
      (noneOf(":").plus().flatten() & char(':') & digitPlusFlatten & char(':') &
        digitPlusFlatten).flatten()
        & char(')'))).pick(1);

  static final second = (string('0 | ') & (recordName | wordPlusFlatten)).pick(1);
  static final prefix = (((digitPlusFlatten & char(':') & digitPlusFlatten & char('-') & digitPlusFlatten) | digitPlusFlatten) & string(' |   ')).pick(0);

  static final fieldPattern = prefix & (word().plus() & any().plus()).flatten();

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
  final bool hasBitFields;

  Field(this.name, this.offset, this.hasBitFields);

  // known from IRgen
  String declId;
  String type, desugaredType;
}

enum RecordType {
  struct, union
}

class Record {

  final String identifier;
  final bool isAnon;
  final fields = <Field>{};

  Record(this.identifier, [this.isAnon = false]);

  // known from IRgen
  // this can be used for debugging, when considering
  // generating a new class (e.g. project_arch_os.s.dart) // TODO
  String declId;

  // known from CG
  String generatedName; // e.g. struct_anon_23, union_anon_20, ma_channel_converter
  RecordType type;// if anon the type is declared on the 2nd line, otherwise no.
  // although offset 0 for all fields, is a strong clue // TODO

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