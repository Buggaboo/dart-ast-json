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
  (char(' ') & pointer.star().flatten() & array.star().flatten()).optional();

// let's hope we never bump into a fn ptr, with a fn ptr as an argument, TODO
// we have an extractor tho...
final fnPtr = (basicType & (char(' ') & pointer.star()).flatten() &
string('(*)(') & type & (string(', ') & type).star() & char(')')).flatten();

class AstRecordLayoutPatterns {
  static final first = string('*** Dumping AST Record Layout');
  static final second = (string('0 | ') & wordPlusFlatten).pick(1); // TODO test on nested type
  static final prefix = digitPlusFlatten & string(' |   ');
  static final varName = wordPlusFlatten;
  static final fieldPattern = prefix &
    (((fnPtr & space & varName)..pick(2))
        .or((type & space & varName)..pick(2))
        .or((basicType & space & varName).pick(2)));
  static final bitFields = digitPlusFlatten & char(':') & digitPlus & char('-') & digitPlus &
    string(' |   ') & (basicType & space & varName).pick(2); // TODO at least give a warning
  static final last = string('| [sizeof=') & digitPlusFlatten & string(', align=') & digitPlusFlatten & char(']');
}

class IRgenRecordLayoutPatterns {
  static final lineNumber = (string('line:') & digitPlus & char(':') & digitPlus).flatten();
  static final colNumber = (string('col:') & digitPlus).flatten();
  static final definition = (string(' union ') | string(' struct ')) & (wordPlusFlatten & char(' ')).optional() & string('definition');
  static final first = string('*** Dumping IRgen Record Layout');
  static final hexId = (string('0x') & word().plus()).flatten();
  static final second = string('Record: RecordDecl ') &
  ((hexId & string(' prev ') & hexId) | hexId) &
  string(' <') & noneOf(',').plus().flatten() & string(', ') & (lineNumber | colNumber) &
  string('> ') & (lineNumber | colNumber) &
  (
      string(' struct definition') | string(' union definition') |
      string(' struct ') & wordPlusFlatten & string(' definition') |
      string(' union ') & wordPlusFlatten & string(' definition')
  );

  static final fieldName = wordPlusFlatten;
  static final startApost = string(" '");
  static final middleApost = string("':'");
  static final endApost = char("'");
  static final nonOfApostPlus = noneOf("'").plus().flatten();

  static final fieldPattern = (string('`-') | string('|-')) & string('FieldDecl ') &
      hexId & (string(' <') & noneOf('>').plus() & string('> ') & colNumber).flatten() &
      (string(' referenced ') | space) & fieldName &
      (
        (startApost & nonOfApostPlus & middleApost & nonOfApostPlus & endApost).pick(3) |
        (startApost & nonOfApostPlus & endApost).pick(1)
      );
}

class CGRecordLayoutPatterns {
  // we don't use these types due to info loss
  // also bitfields can be derived from the AST Record
  static final recordType = string('%struct.') | string('%union.');
  static final LLVMTypePattern = string('  LLVMType:') & recordType & wordPlusFlatten &
  (char('.') & digit().plus()).optional() &
  (string(' = type { ') & noneOf('}').plus().flatten().trim() & string('}')).pick(1);

  static final last = string(']>');
}

class Field {
  final String name;
  final int offset;
  final bool hasBitFields;

  Field(this.name, this.offset, this.hasBitFields);

  // known from IRgen
  String declId;
  String typedefType, type;
}

enum RecordType {
  struct, union
}

class Record {

  final String identifier; // use md5(filename:line:column) as identifier
  final bool isAnon;
  final List<Field> fields;

  Record(this.identifier, this.fields, [this.isAnon = false]);

  // known from IRgen
  String declId;

  // known from CG
  String generatedName; // e.g. struct_anon_23, union_anon_20, ma_channel_converter
  RecordType type;// if anon the type is declared on the 2nd line, otherwise no.
  // although offset 0 for all fields, is a strong clue
}