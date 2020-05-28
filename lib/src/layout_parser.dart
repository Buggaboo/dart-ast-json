import 'package:petitparser/petitparser.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

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
  static final space = char(' ');
  static final first = string('*** Dumping AST Record Layout');
  static final second = (string('0 | ') & wordPlusFlatten).pick(1); // TODO test on nested type
  static final prefix = digitPlusFlatten & string(' |   ');
  static final varName = wordPlusFlatten;
  static final i = prefix &
    (((fnPtr & space & varName)..pick(2))
        .or((type & space & varName)..pick(2))
        .or((basicType & space & varName).pick(2)));
  static final bitFields = digitPlusFlatten & char(':') & digitPlus & char('-') & digitPlus &
    string(' |   ') & (basicType & space & varName).pick(2); // TODO at least give a warning
  static final last = string('| [sizeof=') & digitPlusFlatten & string(', align=') & digitPlusFlatten & char(']');
}

class IRgenRecordLayoutPatterns {
  static final lineNumber = (string('line:') & digitPlus & char(':') & digitPlus).flatten();
  static final definition = (string(' union ') | string(' struct ')) & (wordPlusFlatten & char(' ')).optional() & string('definition');
  static final first = string('*** Dumping IRgen Record Layout');
  static final hexId = (string('0x') & word().plus()).flatten();
  static final second = string('Record: RecordDecl ') &
    (hexId | (hexId & string(' prev ') & hexId)) &
    string(' <') & noneOf(',').plus().flatten() & char(',') &
    lineNumber & string('> ').flatten() &
    lineNumber & definition;

  static final fieldName = wordPlusFlatten;
  static final startApost = string(" '");
  static final middleApost = string("':'");
  static final endApost = char("'");

  // TODO |-FieldDecl 0x7fb20b24a530 <line:2025:5, col:15> col:15 format 'ma_format':'ma_format'
  // TODO |-FieldDecl 0x7fb20b0d0e80 <col:5, col:29> col:29 referenced code_tab_width 'drmp3_uint8':'unsigned char'
  // TODO |-FieldDecl 0x7fb20780dca8 <<invalid sloc>> <invalid sloc> overflow_arg_area 'void *'
  static final lineColCol = (string(' <line:') & any().plus() & string('> col:') & digitPlus & string(' referenced ')).flatten();
//  static final fileNameLineCol =
//  static final i = ((string('|-') | string('`-')) & string('FieldDecl ')).flatten() & hexId &
//    lineColCol & fieldName &
//    (
//      string(" 'union (anonymous union at ") | fileNameLineCol
//      string(" 'struct (anonymous struct at ") | any().plus() & char
//      (startApost & type & middleApost & type & endApost).pick(3) |
//      (startApost & type & endApost).pick(1)
//    );

  // we don't use these types due to info loss
  // also bitfields can be derived from the AST Record
  static final recordType = string('%struct.') | string('%union.');
  static final LLVMType = string('LLVMType:') & recordType & wordPlusFlatten &
    (string(' = type { ') & any().plus() & string(' }')).flatten();

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