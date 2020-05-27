import 'package:petitparser/petitparser.dart';

final pointer = char('*');
final array = (char('[') & digit().plus() & char(']')).flatten();
final basicType = (char('_').star() & letter() & word().star()).flatten();
final type = string('const ').optional() &
  basicType & (char(' ') & pointer.star().flatten() & array.star().flatten()).optional();

// let's hope we never bump into a fn ptr, with a fn ptr as an argument
final fnPtr = basicType & (char(' ') & pointer.star() &
  string('(*)(') & type & (string(', ') & type).star() & char(')')).flatten();

class AstRecordLayoutPatterns {
  static final wordPlusFlatten = word().plus().flatten();
  static final space = char(' ');
  static final first = string('*** Dumping AST Record Layout');
  static final second = (string('0 | ') & wordPlusFlatten).pick(1);
  static final prefix = digit().plus().flatten() & string(' |   ');
  static final varName = wordPlusFlatten;
  static final i = prefix &
    (((fnPtr & space & varName)..pick(2))
        .or((type & space & varName)..pick(2))
        .or((basicType & space & varName).pick(2)));
  static final last = string('| [sizeof=') & digit().plus().flatten() & string(', align=') & digit().plus().flatten() & char(']');
}