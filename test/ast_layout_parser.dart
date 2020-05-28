import 'package:test/test.dart';
import 'package:dart_ast_json/src/layout_parser.dart';
import 'package:petitparser/petitparser.dart';

void main() {

  test("basics", () {
    final bt = basicType;
    expect(bt.accept('*'), false);
    expect(bt.accept('1'), false);
    expect(bt.accept('__uint64__'), true);
    expect(bt.accept('int'), true);
    expect(bt.accept('int64'), true);
  });

  test("basics pointers", () {
    expect(type.accept('int *'), true);
    expect(type.accept('int **'), true);
    expect(type.accept('int ***'), true);
    expect(type.accept('const int ***'), true);
    expect(type.accept('const int **'), true);
    expect(type.accept('const int *'), true);
  });

  test("basics array", () {
    expect(array.accept('[1]'), true);
    expect(array.accept('[12341234]'), true);
    expect(array.accept('[0000]'), true); // let's assume LLVM is programmed correctly
    expect(array.accept('[a]'), false);
    expect(array.accept('[_]'), false);
  });


  test("basics pointer + array", () {
    expect(type.accept('int *[1]'), true);
    expect(type.accept('int **[12341234]'), true);
    expect(type.accept('const int ***[1]'), true);
    expect(type.accept('int *[1][2][3]'), true);
    expect(type.accept('int **[12341234][12341234]'), true);
    expect(type.accept('const int ***[1]'), true);
    expect(type.accept('int [1][2][3]'), true);
  });

  test("basics function pointers", () {
    expect(fnPtr.accept('int *(*)(void)'), true);
    expect(fnPtr.accept('int *(*)(void ***)'), true);
    expect(fnPtr.accept('int **(*)(void **)'), true);
    expect(fnPtr.accept('int ***(*)(void *)'), true);
    expect(fnPtr.accept('int (*)(void)'), true);
    expect(fnPtr.accept('int (*)(void *)'), true);
    expect(fnPtr.accept('int (*)(void)'), true);
    expect(fnPtr.accept('int (*)(void *)'), true);
    expect(fnPtr.accept('int (*)(void, void *, void, void *)'), true);
    expect(fnPtr.accept('int (*)(void *, void, void *, void)'), true);
    expect(fnPtr.accept('int (*)(const void, void *, void, void *)'), true);
    expect(fnPtr.accept('int (*)(void *, void, const void *, void)'), true);
    expect(fnPtr.accept('void *(*)(void *, size_t, void *)'), true);
    expect(fnPtr.accept('const int (*)(void *, void, void *, void)'), false); // return value is already read-only
  });

  const AST_RECORD_LAYOUT1 =
  '*** Dumping AST Record Layout\n'
           '0 | drflac_frame\n'
           '0 |   drflac_frame_header header\n' // 2
           '0 |     drflac_uint64 pcmFrameNumber\n'
           '8 |     drflac_uint32 flacFrameNumber\n'
          '12 |     drflac_uint32 sampleRate\n'
          '16 |     drflac_uint16 blockSizeInPCMFrames\n'
          '18 |     drflac_uint8 channelAssignment\n'
          '19 |     drflac_uint8 bitsPerSample\n'
          '20 |     drflac_uint8 crc8\n'
          '24 |   drflac_uint32 pcmFramesRemaining\n' // 10
          '32 |   drflac_subframe [8] subframes\n' // 11
             '| [sizeof=160, align=8]'; // 12

  final splitLines = AST_RECORD_LAYOUT1.split('\n');

  test("verify patterns match", () {
    final p = AstRecordLayoutPatterns.i;

    // first line
    expect(AstRecordLayoutPatterns.first.accept(splitLines[0]), true);

    // last line
    expect(AstRecordLayoutPatterns.last.accept(splitLines[12]), true);

    // 2nd, stating the name of the struct/union
    expect(AstRecordLayoutPatterns.second.accept(splitLines[1]), true);

    // >2nd, stating the fields
    expect(p.accept('137 |   int a'), true);
    expect(p.accept('137 |   int * a'), true);
    expect(p.accept('137 |   int [5] a'), true);
    expect(p.accept('337 |   int *[5] a'), true);
    expect(p.accept('137 |   int ** a'), true);
    expect(p.accept('337 |   int *[5] a'), true);
    expect(p.accept('137 |   int **[5] a'), true);
    expect(p.accept('337 |   int **[5][6] a'), true);
    expect(p.accept('337 |   const int a'), true);
    expect(p.accept('137 |   const int [0] a'), true);
    expect(p.accept('137 |   const int * a'), true);
    expect(p.accept('137 |   const int ** a'), true);
    expect(p.accept('137 |   const int *[0] a'), true);
    expect(p.accept('137 |   const int *[1234][1234] a'), true);
    expect(p.accept('137 |   const int **[1234][1234] a'), true);

    expect(p.accept('88 |   const void * pData'), true);
    expect(p.accept('32 |   drflac_subframe [8] subframes'), true);
    expect(p.accept('24 |   drflac_uint32 pcmFramesRemaining'), true);
    expect(p.accept('48 |   void *(*)(void *, size_t, void *) onRealloc'), true);

    // We only want the first degree fields, they're recursively defined anyway
    expect(p.accept('137 | int *[5] a'), false); // bad spacing
    expect(p.accept('137 |     int *[5] a'), false); // bad spacing
  });

  final trickyLines = [
    '88 |   const void * pData',
    '32 |   drflac_subframe [8] subframes',
    '48 |   void *(*)(void *, size_t, void *) onRealloc'
  ];

  test("read offsets, get names from first degree fields", () {
    final p = AstRecordLayoutPatterns.i;

    for (var l in trickyLines) {
      final r = p.parse(l);
      expect(r.map((v) => v[0]).value, l.substring(0, l.indexOf('|')-1));
      expect(r.map((v) => v[2][v[2].length - 1]).value, l.substring(l.lastIndexOf(' ')+1));
    }

    // When implementing, check for 'is List<dynamic>' before calling length
    final r = p.parse('24 |   drflac_uint32 pcmFramesRemaining');
    expect (r.map((v) => '${v[0]} ${v[2]}').value, '24 pcmFramesRemaining');
  });

  test("read struct/union name", () {
    final v = AstRecordLayoutPatterns.second.parse('0 | drflac_frame').value;
    expect(v, 'drflac_frame');
  });

  test("read sizeof, align", () {
    final r = AstRecordLayoutPatterns.last.parse('| [sizeof=160, align=8]')
        .map((v) => '${v[1]} ${v[3]}')
        .value;
    expect(r, '160 8');
  });
}