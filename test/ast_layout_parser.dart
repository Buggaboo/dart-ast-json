import 'package:test/test.dart';
import 'package:dart_ast_json/src/layout_parser.dart';
import 'package:petitparser/petitparser.dart';

final firstField =
"""
         0 | drflac_vorbis_comment_iterator
         0 | drflac_cuesheet_track_iterator
         0 | drflac_cuesheet_track
         0 | drmp3dec
         0 | drmp3_L3_gr_info
         0 | drmp3_bs
         0 | drmp3dec_scratch
         0 | drmp3_L12_scale_info
         0 | drmp3dec_frame_info
         0 | drmp3_allocation_callbacks
         0 | struct drmp3::(anonymous at /pyminiaudio/miniaudio/dr_mp3.h:358:5)
         0 | drmp3
         0 | drmp3_seek_point
         0 | drmp3__seeking_mp3_frame_info
         0 | drmp3_config
         0 | union (anonymous at /pyminiaudio/miniaudio/dr_wav.h:296:5)
         0 | drwav_smpl_loop
         0 | union (anonymous at /pyminiaudio/miniaudio/dr_wav.h:1256:5)
         0 | union (anonymous at /pyminiaudio/miniaudio/dr_wav.h:1277:5)
         0 | drwav_chunk_header
         0 | drwav_fmt
         0 | drwav_allocation_callbacks
         0 | drwav_smpl
         0 | drwav__memory_stream
         0 | drwav__memory_stream_write
         0 | struct drwav::(anonymous at /pyminiaudio/miniaudio/dr_wav.h:553:5)
         0 | struct drwav::(anonymous at /pyminiaudio/miniaudio/dr_wav.h:559:5)
         0 | struct drwav::(anonymous at /pyminiaudio/miniaudio/dr_wav.h:570:5)
         0 | drwav
         0 | drwav_data_format
         0 | struct flock
         0 | ma_biquad_coefficient
         0 | ma_biquad
         0 | ma_lpf1
         0 | ma_lpf2
         0 | ma_hpf1
         0 | ma_hpf2
         0 | ma_bpf2
         0 | ma_linear_resampler_config
         0 | union ma_linear_resampler::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2273:5)
         0 | union ma_linear_resampler::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2278:5)
         0 | ma_lpf
         0 | ma_linear_resampler
         0 | struct ma_resampler_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2309:5)
         0 | struct ma_resampler_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2314:5)
         0 | ma_resampler_config
         0 | struct ma_data_converter_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2476:9)
         0 | struct ma_data_converter_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2481:9)
         0 | struct ma_data_converter_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2472:5)
         0 | ma_data_converter_config
         0 | ma_allocation_callbacks
         0 | ma_rb
         0 | struct (anonymous at /pyminiaudio/miniaudio/miniaudio.h:2899:9)
         0 | struct _opaque_pthread_mutex_t
         0 | struct (anonymous at /pyminiaudio/miniaudio/miniaudio.h:2921:9)
         0 | struct _opaque_pthread_cond_t
         0 | struct (anonymous at /pyminiaudio/miniaudio/miniaudio.h:2943:9)
         0 | struct (anonymous at /pyminiaudio/miniaudio/miniaudio.h:2967:9)
         0 | ma_device_id
         0 | struct ma_context::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3485:9)""";

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
    final p = AstRecordLayoutPatterns.fieldPattern;

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
    final p = AstRecordLayoutPatterns.fieldPattern;

    for (var l in trickyLines) {
      final r = p.parse(l);
      expect(r.value[0], l.substring(0, l.indexOf('|')-1));
      expect(r.map((v) {
        final vv = v[1].split(' ');
        return vv[vv.length-1];
      }).value, l.substring(l.lastIndexOf(' ')+1));
    }
  });

  test("read struct/union name", () {
    final v = AstRecordLayoutPatterns.second.parse('0 | drflac_frame')
        .map((v) => v[1]).value;
    expect(v, 'drflac_frame');
  });

  test("read sizeof, align", () {
    final r = AstRecordLayoutPatterns.last.parse('| [sizeof=160, align=8]')
        .map((v) => '${v[1]} ${v[3]}')
        .value;
    expect(r, '160 8');
  });

  test("first degree field", () {
    final firstField0 = firstField.split('\n');
    for (int i=0; i<firstField0.length; i++) {
      if (!AstRecordLayoutPatterns.second.accept(firstField0[i].trim())) {
        fail('Failed at line $i, with:\n"${firstField0[i]}"');
      }
    }
  });
}