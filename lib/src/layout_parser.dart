import 'dart:io';
import 'package:logging/logging.dart' show Logger;
import 'package:petitparser/petitparser.dart';

final space = char(' ');

final wordPlusFlatten = word().plus().flatten();

final digitPlus = digit().plus();
final digitPlusFlatten = digitPlus.flatten();

final pointer = char('*');
final array = (char('[') & digitPlus & char(']')).flatten();
final basicType = (char('_').star() & letter() & word().star()).flatten();
final fieldName = basicType.plus().flatten(); // same
final type = (string('struct ') | string('union ') | string('const ').optional() | string('volatile ')) & basicType &
  (space & pointer.star().flatten() & array.star().flatten()).optional();

// TODO reimplement as: fnPtr = undefined(); fnPtr.set(...);
// let's hope we never bump into a fn ptr, with a fn ptr as an argument
// we have an extractor tho...
final fnPtr = (basicType & (space & pointer.star()).flatten() &
(string('(*)(') | (string('(* ') & basicType & string(')('))) & type & (string(', ') & type).star() & char(')')).flatten();

// TODO replace some of the picks with 'and', to get rid of awkward parentheses
class AstRecordLayoutPatterns {
  static final first = string('*** Dumping AST Record Layout');
  static final structOrUnion = ((string('struct') | string('union')) & space).pick(0);
  static final anonIdentifier = (noneOf(":").plus().flatten() & char(':') &
    digitPlusFlatten & char(':') & digitPlusFlatten).flatten();
  static final anon = structOrUnion & (string('(anonymous at ') & anonIdentifier & char(')')).pick(1);
  static final anonAndNested = structOrUnion &
    wordPlusFlatten & (string('::(anonymous at ') & anonIdentifier & char(')')).pick(1);

  static final second = (string('0 | ') & (anonAndNested | anon | (structOrUnion & wordPlusFlatten).pick(1) | wordPlusFlatten)).pick(1);
  static final offsetBitFieldRange = (digitPlusFlatten & char(':')).pick(0) & (digitPlusFlatten & char('-')).pick(0) & digitPlusFlatten;
  static final offsets = offsetBitFieldRange | digitPlusFlatten;
  static final fieldPattern = (offsets & string(' |   ')).pick(0) &
    (
      (fnPtr & space & fieldName) |
//      (letter() & noneOf(')').plus() & (char(')').end().not() | (string(') ')) & fieldName))
      (char('_').star() & letter() & noneOf(')').plus() & ((string(') ') & fieldName) | char(')').end().not()).flatten())
    ).flatten();

  static final last = (string('| [sizeof=') & digitPlusFlatten).pick(1) & (string(', align=') & digitPlusFlatten & char(']')).pick(1);
}

class IRgenRecordLayoutPatterns {
  static final lineNumber = (string('line:') & digitPlus & char(':') & digitPlus).flatten();
  static final colNumber = (string('col:') & digitPlus).flatten();
  static final definition = (string(' union ') | string(' struct ')) & (wordPlusFlatten & space).optional() & string('definition');
  static final first = string('*** Dumping IRgen Record Layout');
  static final hexId = (string('0x') & word().plus()).flatten();
  static final second = (string('Record: RecordDecl ') &
    ((hexId & string(' prev ') & hexId).pick(0) | hexId)).pick(1) &
    (string(' <') & noneOf(',').plus().flatten() & string(', ') & (lineNumber | colNumber) &
    string('> ') & (lineNumber | colNumber) & space).pick(1) &
    (
        ((string('struct ') & wordPlusFlatten & string(' definition')).pick(1)) |
        (string('union ') & wordPlusFlatten & string(' definition')).pick(1) |
        string('struct definition') | string('union definition')
    );

  static final startApost = string(" '");
  static final middleApost = string("':'");
  static final endApost = char("'");
  static final nonOfApostPlus = noneOf("'").plus().flatten();

  static final fieldPattern = ((string('`-FieldDecl ') | string('|-FieldDecl ')) & hexId).pick(1) &
    ((string(' <') & noneOf('>').plus() & string('> ') & colNumber).flatten() &
//    (string(' implicit referenced ').not() | string(' implicit ').not()) &
    string(' implicit ').not() &
    (string(' referenced ') | space) & wordPlusFlatten).pick(3) &
    (
      (startApost & nonOfApostPlus & middleApost & nonOfApostPlus & endApost).pick(3) |
      (startApost & nonOfApostPlus & endApost).pick(1)
    );
}

class CGRecordLayoutPatterns {
  // we don't use these types due to info loss
  // also bitfields can be derived from the AST Record
  static final first = string('Layout: <CGRecordLayout');

  static final recordType = (char('%') & (string('struct') | string('union')) & char('.')).pick(1);
  static final LLVMTypePattern = (string('LLVMType:') & recordType).pick(1) &
  ((string('anon.') & digit().plus()) | wordPlusFlatten).flatten() &
  ((string(' = type { ') | string(' = type <{ ')) & noneOf('}').plus().flatten().trim() & string('}')).pick(1);

  static final penultimatelyIgnored = string("IsZeroInitializable:") |
    string('BitFields:[') | string("<CGBitFieldInfo");

  static final last = string(']>');
}

class Field {
  final String name;
  final int offset;
  final int bitFieldStart, bitFieldEnd;
  int counter = 0; // TODO this deserves its own ctor

  // known from IRgen
  String declId;
  String type, desugaredType;

  Field(this.name, this.type, [this.offset, this.bitFieldStart,this.bitFieldEnd]);

  factory Field.fromAstParserResult(List<dynamic> result) {
    final r1 = result[1];
    final split = r1.lastIndexOf(' ');
    final name = r1.substring(split + 1);

    final typeSplit = r1.substring(0, split);
    final anonTypeResult = (AstRecordLayoutPatterns.anonAndNested |
      AstRecordLayoutPatterns.anon).parse(typeSplit);

    final type = anonTypeResult.isSuccess ? anonTypeResult.value[2] : typeSplit;

//    // TODO remove start
//    print ('r1: $r1');
//    print ('split: $split');
//    print ('name: $name');
//    print ('typesplit: $typeSplit');
//    print ('type: $type');
//    // TODO remove end

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
  bool isAnon;
  final fields = <String, Field>{};
  final String parentIdentifier;
  int counter; // TODO deserves its own place in a ctor

  // known from IRgen
  // this can be used for debugging, when considering
  // generating a new class (e.g. project_arch_os.s.dart)
  String declId;

  // known from CG
  String generatedName; // e.g. struct_anon_23, union_anon_20, ma_channel_converter
  RecordType type;// if anon the type is declared on the 1st line in AST, otherwise no.
  // although offset 0 for all fields, is a strong clue
  String csFieldTypes; // cs == comma separated

  Record(this.identifier, [this.isAnon = false, this.type, this.parentIdentifier = null]);

  static RecordType typeFromString(String s) =>
    s == 'struct' ? RecordType.struct : RecordType.union;

  factory Record.fromAstParserResult(dynamic result) {
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

//    throw Exception("Bad result from parser");
    return null;
  }

  @override
  String toString() => '$identifier, $isAnon, $type, $parentIdentifier';
}

// poor person's state machine
final transitions = <Parser, List<Parser>>{
  AstRecordLayoutPatterns.first : [ AstRecordLayoutPatterns.second ],
  AstRecordLayoutPatterns.second : [ AstRecordLayoutPatterns.fieldPattern ],
  // TODO do cheap startsWith check to detect breaks
  AstRecordLayoutPatterns.fieldPattern : [ AstRecordLayoutPatterns.fieldPattern, AstRecordLayoutPatterns.last ],
  AstRecordLayoutPatterns.last : [ AstRecordLayoutPatterns.first, IRgenRecordLayoutPatterns.first ],
  IRgenRecordLayoutPatterns.first : [ IRgenRecordLayoutPatterns.second ],
  IRgenRecordLayoutPatterns.second : [ IRgenRecordLayoutPatterns.fieldPattern ],
  // TODO do cheap check to detect breaks
  IRgenRecordLayoutPatterns.fieldPattern : [ IRgenRecordLayoutPatterns.fieldPattern, CGRecordLayoutPatterns.first ],
  CGRecordLayoutPatterns.first : [ CGRecordLayoutPatterns.LLVMTypePattern ],
  CGRecordLayoutPatterns.LLVMTypePattern : [ CGRecordLayoutPatterns.penultimatelyIgnored ],
  CGRecordLayoutPatterns.penultimatelyIgnored : [ CGRecordLayoutPatterns.penultimatelyIgnored, CGRecordLayoutPatterns.last ],
  CGRecordLayoutPatterns.last : [ AstRecordLayoutPatterns.first, IRgenRecordLayoutPatterns.first ]
};

Record _astSecond (dynamic v) => Record.fromAstParserResult(v);
Field  _astField (dynamic v) =>  Field.fromAstParserResult(v);

String fromIrgenSecondIdentifier(List<dynamic> v) {
  var last = v[v.length - 1];
  if (last.endsWith('definition')) { return v[1]; }
  return v[2];
}

dynamic Function(List<dynamic>) fromIrgenSecondUpdateRecord(String identifier, int counter) {
  return (dynamic d) {
    final v = d as List<dynamic>;
    Record record = Record(identifier);
    record.counter = counter;
    record.declId = v[0];
    record.type = v[2].contains('union') ? RecordType.union : RecordType.struct;
    return record;
  };
}

dynamic Function(List<dynamic>) fromIrgenFieldUpdateField(Record record, int counter) {
  return (dynamic d) {
    final v = d as List<dynamic>;

    final result = (AstRecordLayoutPatterns.anonAndNested |
      AstRecordLayoutPatterns.anon).parse(v[2]);

    final type = result.isSuccess ? result.value[2] : v[2];

    Field field = Field(v[1], type);
    field.counter = counter;
    field.declId = v[0];
    field.desugaredType = v[2];
    record.fields[v[1]] = field;
    // for anon types: at the end of the file
    // replace the desugaredType with
    // the real generatedName of the anon Records

    return record;
  };
}

dynamic Function(List<dynamic>) fromCGUpdateRecord(Record record) {
  return (dynamic d) {
    final v = d as List<dynamic>;
    record.type = v[0] == 'union' ? RecordType.union : RecordType.struct; // yes, we're doing it again
    record.generatedName = v[1].startsWith("anon") ? '${v[0]}.${v[1]}'.replaceAll('.', "_") : v[1];
    record.csFieldTypes = v[2];

    return record;
  };
}

//// https://git.io/JfKLP
final maps = <Parser, dynamic Function(dynamic)>{
/// create Record with factory, add record to Map
  AstRecordLayoutPatterns.second : _astSecond,
/// create Field with factory insert to Record
  AstRecordLayoutPatterns.fieldPattern : _astField,
/// double entry keep Record with identifier (i.e. name or filename:line:col reference),
/// update declId, assign RecordType
//  IRgenRecordLayoutPatterns.second : ,
/// double entry Field in Record, update declId and desugaredType
//  IRgenRecordLayoutPatterns.fieldPattern : ,
/// double entry Record assign generatedName (if anon replace the '.')
/// also assign the field types
//  CGRecordLayoutPatterns.LLVMTypePattern :
};

// for debugging
final parserName = <Parser, String>{
  AstRecordLayoutPatterns.first :'astFirst',
  AstRecordLayoutPatterns.second :'astSecond',
  AstRecordLayoutPatterns.fieldPattern :'astField',
  AstRecordLayoutPatterns.last :'astLast',

  CGRecordLayoutPatterns.first :'cgFirst',
  CGRecordLayoutPatterns.recordType :'cgRecordType',
  CGRecordLayoutPatterns.LLVMTypePattern :'cgLLVM',
  CGRecordLayoutPatterns.last :'cgLast',

  IRgenRecordLayoutPatterns.first :'irgenFirst',
  IRgenRecordLayoutPatterns.second :'irgenSecond',
  IRgenRecordLayoutPatterns.fieldPattern :'irgenField'
};

void layoutParser(List<Parser> patterns, Map<String, Record> astRecords, Map<String, Record> irgenRecords, List<String> lines, [Logger log, IOSink sink]) {
  Record activeRecord;
  int fieldCounter = 0;
  int irgenCounter = 0;

  for (var _line in lines) {
    final line = _line.trim();
    if (line.isEmpty) { continue; }

    final accepted = patterns.where((p) => p.accept(line)).toList();
    if (accepted.isEmpty) {
      final scannedPatterns = patterns.map((p) => parserName[p]).toList();
      var notice = '';

      sink?.write('patterns: ${scannedPatterns.join(' | ')}\n');
      sink?.write('${notice}skipping line: $line\n');

      // bail out
      if (line.contains('invalid') && patterns.contains(IRgenRecordLayoutPatterns.second)) {
        log?.warning('Skipped entire IRgen block with invalid lines');
        patterns = [ CGRecordLayoutPatterns.last ]; // exit
      }

      continue;
    } // skip all 1> degree fields (i.e. nested)

    final pattern = accepted[0];

    if (pattern == AstRecordLayoutPatterns.first || pattern == IRgenRecordLayoutPatterns.first) {
      activeRecord = null; // wipe clean, just in case
      fieldCounter = 0;
    }

    if (maps[pattern] != null) {
      dynamic r = pattern.map(maps[pattern]).parse(line).value as dynamic;
      if (r is Record) {
        astRecords[r.identifier] = r;
        activeRecord = r;
      }
      if (r is Field) {
        activeRecord.fields[r.name] = r;
      }
    }else if (pattern == IRgenRecordLayoutPatterns.second) {
      final result = pattern.parse(line).value;
      final identifier = fromIrgenSecondIdentifier(result);
      activeRecord = fromIrgenSecondUpdateRecord(identifier, irgenCounter++)(result);
      irgenRecords[identifier] = activeRecord;
    }else if (pattern == IRgenRecordLayoutPatterns.fieldPattern) {
      pattern.map(fromIrgenFieldUpdateField(activeRecord, fieldCounter++)).parse(line);
    }else if (pattern == CGRecordLayoutPatterns.LLVMTypePattern) {
      final rvalue = pattern.map(fromCGUpdateRecord(activeRecord)).parse(line).value;
      irgenRecords[rvalue.isAnon ? rvalue.identifier : rvalue.generatedName] = rvalue;
    }

    patterns = transitions[pattern];

  }

  sink.close();
}