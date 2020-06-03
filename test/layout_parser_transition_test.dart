import 'package:test/test.dart';
import 'package:dart_ast_json/src/layout_parser.dart';
import "test_helpers.dart" show StringHelper;

final everything =
'''
*** Dumping AST Record Layout
         0 | struct drmp3::(anonymous at /pyminiaudio/miniaudio/dr_mp3.h:358:5)
         0 |   const drmp3_uint8 * pData
         8 |   size_t dataSize
        16 |   size_t currentReadPos
           | [sizeof=24, align=8]
           
*** Dumping IRgen Record Layout
Record: RecordDecl 0x7fb20b0c9db0 </pyminiaudio/miniaudio/dr_mp3.h:358:5, line:363:5> line:358:5 struct definition
|-FieldDecl 0x7fb20b0c9e60 <line:360:9, col:28> col:28 referenced pData 'const drmp3_uint8 *'
|-FieldDecl 0x7fb20b0c9ec0 <line:361:9, col:16> col:16 referenced dataSize 'size_t':'unsigned long'
`-FieldDecl 0x7fb20b0c9f20 <line:362:9, col:16> col:16 referenced currentReadPos 'size_t':'unsigned long'

Layout: <CGRecordLayout
  LLVMType:%struct.anon.5 = type { i8*, i64, i64 }
  IsZeroInitializable:1
  BitFields:[
]>

*** Dumping AST Record Layout
         0 | drwav_chunk_header
         0 |   union drwav_chunk_header::(anonymous at /pyminiaudio/miniaudio/dr_wav.h:296:5) id
         0 |     drwav_uint8 [4] fourcc
         0 |     drwav_uint8 [16] guid
        16 |   drwav_uint64 sizeInBytes
        24 |   unsigned int paddingSize
           | [sizeof=32, align=8]
           
*** Dumping IRgen Record Layout
Record: RecordDecl 0x7fb209a669e8 </pyminiaudio/miniaudio/dr_wav.h:294:9, line:310:1> line:294:9 struct definition
|-RecordDecl 0x7fb209a66a90 <line:296:5, line:300:5> line:296:5 union definition
| |-FieldDecl 0x7fb209a66bc8 <line:298:9, col:29> col:21 referenced fourcc 'drwav_uint8 [4]'
| `-FieldDecl 0x7fb209a66ca8 <line:299:9, col:28> col:21 referenced guid 'drwav_uint8 [16]'
|-FieldDecl 0x7fb209a66d58 <line:296:5, line:300:7> col:7 referenced id 'union (anonymous union at /pyminiaudio/miniaudio/dr_wav.h:296:5)':'union drwav_chunk_header::(anonymous at /pyminiaudio/miniaudio/dr_wav.h:296:5)'
|-FieldDecl 0x7fb209a66de0 <line:303:5, col:18> col:18 referenced sizeInBytes 'drwav_uint64':'unsigned long long'
`-FieldDecl 0x7fb209a66e48 <line:309:5, col:18> col:18 referenced paddingSize 'unsigned int'

Layout: <CGRecordLayout
  LLVMType:%struct.drwav_chunk_header = type { %union.anon.9, i64, i32 }
  IsZeroInitializable:1
  BitFields:[
]>

*** Dumping AST Record Layout
         0 | drwav_fmt
         0 |   drwav_uint16 formatTag
         2 |   drwav_uint16 channels
         4 |   drwav_uint32 sampleRate
         8 |   drwav_uint32 avgBytesPerSec
        12 |   drwav_uint16 blockAlign
        14 |   drwav_uint16 bitsPerSample
        16 |   drwav_uint16 extendedSize
        18 |   drwav_uint16 validBitsPerSample
        20 |   drwav_uint32 channelMask
        24 |   drwav_uint8 [16] subFormat
           | [sizeof=40, align=4]

*** Dumping IRgen Record Layout
Record: RecordDecl 0x7fb209a66fb8 </pyminiaudio/miniaudio/dr_wav.h:312:9, line:350:1> line:312:9 struct definition
|-FieldDecl 0x7fb209a67090 <line:318:5, col:18> col:18 referenced formatTag 'drwav_uint16':'unsigned short'
|-FieldDecl 0x7fb209a670f0 <line:321:5, col:18> col:18 referenced channels 'drwav_uint16':'unsigned short'
|-FieldDecl 0x7fb209a67150 <line:324:5, col:18> col:18 referenced sampleRate 'drwav_uint32':'unsigned int'
|-FieldDecl 0x7fb209a671b0 <line:327:5, col:18> col:18 referenced avgBytesPerSec 'drwav_uint32':'unsigned int'
|-FieldDecl 0x7fb209a67210 <line:330:5, col:18> col:18 referenced blockAlign 'drwav_uint16':'unsigned short'
|-FieldDecl 0x7fb209a67270 <line:333:5, col:18> col:18 referenced bitsPerSample 'drwav_uint16':'unsigned short'
|-FieldDecl 0x7fb209a672d0 <line:336:5, col:18> col:18 referenced extendedSize 'drwav_uint16':'unsigned short'
|-FieldDecl 0x7fb209a67330 <line:343:5, col:18> col:18 referenced validBitsPerSample 'drwav_uint16':'unsigned short'
|-FieldDecl 0x7fb209a67390 <line:346:5, col:18> col:18 referenced channelMask 'drwav_uint32':'unsigned int'
`-FieldDecl 0x7fb209a67438 <line:349:5, col:29> col:17 referenced subFormat 'drwav_uint8 [16]'

Layout: <CGRecordLayout
  LLVMType:%struct.drwav_fmt = type { i16, i16, i32, i32, i16, i16, i16, i16, i32, [16 x i8] }
  IsZeroInitializable:1
  BitFields:[
]>           
''';

final check =
'''
records#: 3
keys:
  /pyminiaudio/miniaudio/dr_mp3.h:358:5
  drwav_chunk_header
  drwav_fmt
values:
  /pyminiaudio/miniaudio/dr_mp3.h:358:5, true, RecordType.struct, drmp3
  drwav_chunk_header, false, null, null
  drwav_fmt, false, null, null
fields:
  pData: pData, const drmp3_uint8 *, 0, null, null
  dataSize: dataSize, size_t, 8, null, null
  currentReadPos: currentReadPos, size_t, 16, null, null

  id: id, /pyminiaudio/miniaudio/dr_wav.h:296:5, 0, null, null
  sizeInBytes: sizeInBytes, drwav_uint64, 16, null, null
  paddingSize: paddingSize, unsigned int, 24, null, null

  formatTag: formatTag, drwav_uint16, 0, null, null
  channels: channels, drwav_uint16, 2, null, null
  sampleRate: sampleRate, drwav_uint32, 4, null, null
  avgBytesPerSec: avgBytesPerSec, drwav_uint32, 8, null, null
  blockAlign: blockAlign, drwav_uint16, 12, null, null
  bitsPerSample: bitsPerSample, drwav_uint16, 14, null, null
  extendedSize: extendedSize, drwav_uint16, 16, null, null
  validBitsPerSample: validBitsPerSample, drwav_uint16, 18, null, null
  channelMask: channelMask, drwav_uint32, 20, null, null
  subFormat: subFormat, drwav_uint8 [16], 24, null, null
records#: 6
keys:
  /pyminiaudio/miniaudio/dr_mp3.h:358:5
  struct_anon_5
  /pyminiaudio/miniaudio/dr_wav.h:294:9
  drwav_chunk_header
  /pyminiaudio/miniaudio/dr_wav.h:312:9
  drwav_fmt
values:
  /pyminiaudio/miniaudio/dr_mp3.h:358:5, false, RecordType.struct, null
  /pyminiaudio/miniaudio/dr_mp3.h:358:5, false, RecordType.struct, null
  /pyminiaudio/miniaudio/dr_wav.h:294:9, false, RecordType.struct, null
  /pyminiaudio/miniaudio/dr_wav.h:294:9, false, RecordType.struct, null
  /pyminiaudio/miniaudio/dr_wav.h:312:9, false, RecordType.struct, null
  /pyminiaudio/miniaudio/dr_wav.h:312:9, false, RecordType.struct, null
fields:
  pData: pData, const drmp3_uint8 *, null, null, null
  dataSize: dataSize, unsigned long, null, null, null
  currentReadPos: currentReadPos, unsigned long, null, null, null

  pData: pData, const drmp3_uint8 *, null, null, null
  dataSize: dataSize, unsigned long, null, null, null
  currentReadPos: currentReadPos, unsigned long, null, null, null

  id: id, /pyminiaudio/miniaudio/dr_wav.h:296:5, null, null, null
  sizeInBytes: sizeInBytes, unsigned long long, null, null, null
  paddingSize: paddingSize, unsigned int, null, null, null

  id: id, /pyminiaudio/miniaudio/dr_wav.h:296:5, null, null, null
  sizeInBytes: sizeInBytes, unsigned long long, null, null, null
  paddingSize: paddingSize, unsigned int, null, null, null

  formatTag: formatTag, unsigned short, null, null, null
  channels: channels, unsigned short, null, null, null
  sampleRate: sampleRate, unsigned int, null, null, null
  avgBytesPerSec: avgBytesPerSec, unsigned int, null, null, null
  blockAlign: blockAlign, unsigned short, null, null, null
  bitsPerSample: bitsPerSample, unsigned short, null, null, null
  extendedSize: extendedSize, unsigned short, null, null, null
  validBitsPerSample: validBitsPerSample, unsigned short, null, null, null
  channelMask: channelMask, unsigned int, null, null, null
  subFormat: subFormat, drwav_uint8 [16], null, null, null

  formatTag: formatTag, unsigned short, null, null, null
  channels: channels, unsigned short, null, null, null
  sampleRate: sampleRate, unsigned int, null, null, null
  avgBytesPerSec: avgBytesPerSec, unsigned int, null, null, null
  blockAlign: blockAlign, unsigned short, null, null, null
  bitsPerSample: bitsPerSample, unsigned short, null, null, null
  extendedSize: extendedSize, unsigned short, null, null, null
  validBitsPerSample: validBitsPerSample, unsigned short, null, null, null
  channelMask: channelMask, unsigned int, null, null, null
  subFormat: subFormat, drwav_uint8 [16], null, null, null''';

final irgen2irgen =
'''
*** Dumping IRgen Record Layout
Record: RecordDecl 0x7fb2090cdfd8 </pyminiaudio/miniaudio/dr_flac.h:378:9, line:383:1> line:378:9 struct definition
|-MaxFieldAlignmentAttr 0x7fb2090ce080 <<invalid sloc>> Implicit 16
|-FieldDecl 0x7fb2090ce0e8 <line:380:5, col:19> col:19 referenced firstPCMFrame 'drflac_uint64':'unsigned long long'
|-FieldDecl 0x7fb2090ce148 <line:381:5, col:19> col:19 referenced flacFrameOffset 'drflac_uint64':'unsigned long long'
`-FieldDecl 0x7fb2090ce1d0 <line:382:5, col:19> col:19 referenced pcmFrameCount 'drflac_uint16':'unsigned short'

Layout: <CGRecordLayout
  LLVMType:%struct.drflac_seekpoint = type <{ i64, i64, i16 }>
  IsZeroInitializable:1
  BitFields:[
]>

*** Dumping IRgen Record Layout
Record: RecordDecl 0x7fb2090d5f78 </pyminiaudio/miniaudio/dr_flac.h:430:9, line:434:9> line:430:9 struct definition
|-FieldDecl 0x7fb2090d6030 <line:432:13, col:27> col:27 referenced seekpointCount 'drflac_uint32':'unsigned int'
`-FieldDecl 0x7fb2090d6108 <line:433:13, col:37> col:37 referenced pSeekpoints 'const drflac_seekpoint *'

Layout: <CGRecordLayout
  LLVMType:%struct.anon.1 = type { i32, %struct.drflac_seekpoint* }
  IsZeroInitializable:1
  BitFields:[
]>''';

final irgen2irgenCheck =
'''
records#: 4
keys:
  /pyminiaudio/miniaudio/dr_flac.h:378:9
  drflac_seekpoint
  /pyminiaudio/miniaudio/dr_flac.h:430:9
  struct_anon_1
values:
  /pyminiaudio/miniaudio/dr_flac.h:378:9, false, RecordType.struct, null
  /pyminiaudio/miniaudio/dr_flac.h:378:9, false, RecordType.struct, null
  /pyminiaudio/miniaudio/dr_flac.h:430:9, false, RecordType.struct, null
  /pyminiaudio/miniaudio/dr_flac.h:430:9, false, RecordType.struct, null
fields:
  firstPCMFrame: firstPCMFrame, unsigned long long, null, null, null
  flacFrameOffset: flacFrameOffset, unsigned long long, null, null, null
  pcmFrameCount: pcmFrameCount, unsigned short, null, null, null

  firstPCMFrame: firstPCMFrame, unsigned long long, null, null, null
  flacFrameOffset: flacFrameOffset, unsigned long long, null, null, null
  pcmFrameCount: pcmFrameCount, unsigned short, null, null, null

  seekpointCount: seekpointCount, unsigned int, null, null, null
  pSeekpoints: pSeekpoints, const drflac_seekpoint *, null, null, null

  seekpointCount: seekpointCount, unsigned int, null, null, null
  pSeekpoints: pSeekpoints, const drflac_seekpoint *, null, null, null''';

final astKeyTestInput =
'''
*** Dumping AST Record Layout
         0 | union ma_semaphore::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2958:5)
         0 |   struct ma_semaphore::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2967:9) posix
         0 |     sem_t semaphore
         0 |   int _unused
           | [sizeof=4, align=4]

*** Dumping AST Record Layout
         0 | ma_semaphore
         0 |   ma_context * pContext
         8 |   union ma_semaphore::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2958:5)
         8 |     struct ma_semaphore::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2967:9) posix
         8 |       sem_t semaphore
         8 |     int _unused
           | [sizeof=16, align=8]

*** Dumping IRgen Record Layout
Record: RecordDecl 0x7fb20b27d9d0 </pyminiaudio/miniaudio/miniaudio.h:2967:9, line:2970:9> line:2967:9 struct definition
`-FieldDecl 0x7fb20b27da80 <line:2969:13, col:19> col:19 referenced semaphore 'sem_t':'int'

Layout: <CGRecordLayout
  LLVMType:%struct.anon.49 = type { i32 }
  IsZeroInitializable:1
  BitFields:[
]>

*** Dumping IRgen Record Layout
Record: RecordDecl 0x7fb20b27d930 </pyminiaudio/miniaudio/miniaudio.h:2958:5, line:2973:5> line:2958:5 union definition
|-RecordDecl 0x7fb20b27d9d0 <line:2967:9, line:2970:9> line:2967:9 struct definition
| `-FieldDecl 0x7fb20b27da80 <line:2969:13, col:19> col:19 referenced semaphore 'sem_t':'int'
|-FieldDecl 0x7fb20b27db28 <line:2967:9, line:2970:11> col:11 referenced posix 'struct (anonymous struct at /pyminiaudio/miniaudio/miniaudio.h:2967:9)':'struct ma_semaphore::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2967:9)'
`-FieldDecl 0x7fb20b27db90 <line:2972:9, col:13> col:13 _unused 'int'

Layout: <CGRecordLayout
  LLVMType:%union.anon.48 = type { %struct.anon.49 }
  IsZeroInitializable:1
  BitFields:[
]>''';


interrogateFields(Map<String, Field> fields) =>
  fields.keys.map((k) => '  $k: ${fields[k]}').toList().join('\n');

interrogateRecord(Map<String, Record> records) =>
  'records#: ${records.length}\n'
  'keys:\n${records.keys.map((k) => '  $k').toList().join('\n')}\n'
  'values:\n${records.values.map((o) => '  $o').toList().join('\n')}\n'
  'fields:${records.values.map((o) => '\n${interrogateFields(o.fields)}').toList().join('\n')}'
  ;

void main() {
  test("parser state transition", () {
    final astRecords = <String, Record>{};
    final irgenRecords = <String, Record>{};

    final list = everything.splitMapTrim();
    layoutParser([ AstRecordLayoutPatterns.first ], astRecords, irgenRecords, list);

    // The doubles in IRgen point to the same object
    expect(
      '${interrogateRecord(astRecords)}\n'
      '${interrogateRecord(irgenRecords)}'.trim(),
      check);

//    print(
//        '${interrogateRecord(astRecords)}\n'
//        '${interrogateRecord(irgenRecords)}'.trim());
  });

  test('irgen to irgen transition', () {
    final irgenRecords = <String, Record>{};
    layoutParser([ IRgenRecordLayoutPatterns.first ], {}, irgenRecords, irgen2irgen.splitMapTrim());

    expect(
        '${interrogateRecord(irgenRecords)}'.trim(),
        irgen2irgenCheck);

  });

  test('missing ast key', () {
    final astRecords = <String, Record>{};
    final irgenRecords = <String, Record>{};
    layoutParser([ AstRecordLayoutPatterns.first ], astRecords, irgenRecords, astKeyTestInput.splitMapTrim());
//    print(interrogateRecord(astRecords));
//    print('---');
//    print(interrogateRecord(irgenRecords));
  });
}