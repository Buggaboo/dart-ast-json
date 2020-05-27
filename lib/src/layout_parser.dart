import 'package:petitparser/petitparser.dart';

final pointer = char('*');

final wordPlusFlatten = word().plus().flatten();
final digitPlus = digit().plus();
final digitPlusFlatten = digitPlus.flatten();

class AstRecordLayoutPatterns {
  static final array = (char('[') & digitPlus & char(']')).flatten();
  static final basicType = (char('_').star() & letter() & word().star()).flatten();
  static final type = string('const ').optional() & basicType &
    (char(' ') & pointer.star().flatten() & array.star().flatten()).optional();

  // let's hope we never bump into a fn ptr, with a fn ptr as an argument, TODO
  static final fnPtr = (basicType & (char(' ') & pointer.star()).flatten() &
    string('(*)(') & type & (string(', ') & type).star() & char(')')).flatten();

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

// TODO test this whole thing
class IRgenRecordLayoutPatterns {
  static final recordType = string('%struct.') | string('%union.');
  static final lineNumber = (string('line:') & digitPlus & char(':') & digitPlus).flatten();
  static final definition = string(' union definition') | string(' struct definition');
  static final first = string('*** Dumping IRgen Record Layout');
  static final second = string('Record: RecordDecl ') &
    (string('0x') & word().star()).flatten() & // prettify later
    string(' <') & any().star().flatten() & char(',') & lineNumber & string('> ') &
    lineNumber & definition;

  // TODO watch out for info loss (char <-> int8)
  // TODO watch out for signedness loss (i8... etc.)
  static final basicType = string('double') | string('float') | string('i8') | string('i16') | string('i32') | string('i64');
  static final nestedType = (recordType & wordPlusFlatten).pick(1);

//  static final fnPtr = ...; // TODO
//  static final arrayType // TODO [32 x [32 x [32 x (basic | nested) & pointer.star()

  static final type = basicType | nestedType; // | fnPtr | arrayType;

  static final types = type & (string(', ') & type).star();

  static final LLVMType = string('LLVMType:') & recordType & word().plus().flatten() &
    string(' = type { ') & types & string(' }');

  static final CGBitFieldInfo = string('<CGBitFieldInfo ') & any().star().flatten() & char('>');

  static final last = string(']>');
}