import 'package:test/test.dart';
import 'package:dart_ast_json/src/layout_parser.dart';
import 'package:petitparser/petitparser.dart';

final recordDecls =
"""
Record: RecordDecl 0x7fb2090ce2e8 </pyminiaudio/miniaudio/dr_flac.h:386:9, line:397:1> line:386:9 struct definition
Record: RecordDecl 0x7fb20b296a98 </pyminiaudio/miniaudio/miniaudio.h:5256:9, line:5277:1> line:5256:9 struct definition
Record: RecordDecl 0x7fb20b297418 prev 0x7fb20b2958b0 </pyminiaudio/miniaudio/miniaudio.h:5279:1, line:5306:1> line:5279:8 struct ma_decoder definition
Record: RecordDecl 0x7fb20b2a03a8 </pyminiaudio/miniaudio/miniaudio.h:5395:9, line:5402:1> line:5395:9 struct definition
Record: RecordDecl 0x7fb20b2a0ab8 prev 0x7fb20b29f478 </pyminiaudio/miniaudio/miniaudio.h:5406:1, line:5417:1> line:5406:8 struct ma_encoder definition
Record: RecordDecl 0x7fb20b2a20c8 </pyminiaudio/miniaudio/miniaudio.h:5442:9, line:5450:1> line:5442:9 struct definition
Record: RecordDecl 0x7fb20b2a43c0 </pyminiaudio/miniaudio/miniaudio.h:5488:9, line:5505:1> line:5488:9 struct definition
Record: RecordDecl 0x116294bf8 </pyminiaudio/miniaudio/stb_vorbis.c:762:9, line:766:1> line:762:9 struct definition
Record: RecordDecl 0x7fb2090c1600 </pyminiaudio/miniaudio/stb_vorbis.c:113:9, line:117:1> line:113:9 struct definition
Record: RecordDecl 0x116291a88 </pyminiaudio/miniaudio/stb_vorbis.c:663:9, line:684:1> line:663:9 struct definition
Record: RecordDecl 0x116294e88 prev 0x7fb2090c1860 </pyminiaudio/miniaudio/stb_vorbis.c:768:1, line:884:1> line:768:8 struct stb_vorbis definition
Record: RecordDecl 0x7fb2090c19c8 </pyminiaudio/miniaudio/stb_vorbis.c:124:9, line:134:1> line:124:9 struct definition
Record: RecordDecl 0x7fb209910290 </usr/local/Cellar/llvm/10.0.0_3/Toolchains/LLVM10.0.0.xctoolchain/usr/lib/clang/10.0.0/include/emmintrin.h:3550:3, line:3552:3> line:3550:10 struct __loadu_si128 definition
Record: RecordDecl 0x7fb20b0d0d68 </pyminiaudio/miniaudio/dr_mp3.h:696:9, line:699:1> line:696:9 struct definition
Record: RecordDecl 0x7fb20914b890 </usr/local/Cellar/llvm/10.0.0_3/Toolchains/LLVM10.0.0.xctoolchain/usr/lib/clang/10.0.0/include/xmmintrin.h:1742:3, line:1744:3> line:1742:10 struct __loadu_ps definition
Record: RecordDecl 0x7fb207975550 </pyminiaudio/miniaudio/dr_wav.h:1277:5, line:1280:5> line:1277:5 union definition
Record: RecordDecl 0x7fb2078148f0 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/sys/_pthread/_pthread_types.h:83:1, line:86:1> line:83:8 struct _opaque_pthread_mutexattr_t definition
Record: RecordDecl 0x116084760 </pyminiaudio/miniaudio/miniaudio.h:23529:9, line:23560:1> line:23529:9 struct definition
Record: RecordDecl 0x7fb209b557e8 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/CoreAudio.framework/Headers/CoreAudioTypes.h:756:1, line:767:1> line:756:8 struct SMPTETime definition
Record: RecordDecl 0x7fb209ad21a0 </pyminiaudio/miniaudio/miniaudio.h:9375:9, line:9382:1> line:9375:9 struct definition
Record: RecordDecl 0x11622b730 </pyminiaudio/miniaudio/miniaudio.h:39799:9, line:39808:1> line:39799:9 struct definition
Record: RecordDecl 0x1162ae0a8 </pyminiaudio/miniaudio/stb_vorbis.c:1298:9, line:1301:1> line:1298:9 struct definition""";

final trickyRecordDecls = [
  'Record: RecordDecl 0x7fb20b287118 </pyminiaudio/miniaudio/miniaudio.h:3601:5, line:3646:5> line:3601:5 union definition',
  'Record: RecordDecl 0x7fb209b557e8 </CoreAudio.framework/Headers/CoreAudioTypes.h:756:1, line:767:1> line:756:8 struct SMPTETime definition',
  'Record: RecordDecl 0x7fb20b284750 prev 0x7fb20b22f6c8 </pyminiaudio/miniaudio/miniaudio.h:3275:1, line:3647:1> line:3275:8 struct ma_context definition',
  'Record: RecordDecl 0x7fb20780db08 <<invalid sloc>> <invalid sloc> implicit struct __va_list_tag definition', // policy: ignore the whole IRgen record
  'Record: RecordDecl 0x7fb20799fe60 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/sched.h:35:1, col:80> col:8 struct sched_param definition' // policy: ignore
];

final firstDegreeFields =
"""
|-FieldDecl 0x116084d38 <line:23548:5, col:19> col:19 referenced deviceObjectID 'AudioObjectID':'unsigned int'
|-FieldDecl 0x116084d98 <line:23550:5, col:20> col:20 referenced component 'AudioComponent':'struct OpaqueAudioComponent *'
|-FieldDecl 0x116084df8 <line:23551:5, col:15> col:15 referenced audioUnit 'AudioUnit':'struct ComponentInstanceRecord *'
|-FieldDecl 0x116084e58 <line:23552:5, col:22> col:22 referenced pAudioBufferList 'AudioBufferList *'
|-FieldDecl 0x116084eb8 <line:23553:5, col:15> col:15 referenced formatOut 'ma_format':'ma_format'
|-FieldDecl 0x116084f18 <line:23554:5, col:15> col:15 referenced channelsOut 'ma_uint32':'unsigned int'
|-FieldDecl 0x116084f78 <line:23555:5, col:15> col:15 referenced sampleRateOut 'ma_uint32':'unsigned int'
|-FieldDecl 0x116085020 <line:23556:5, col:45> col:16 referenced channelMapOut 'ma_channel [32]'
|-FieldDecl 0x116085080 <line:23557:5, col:15> col:15 referenced periodSizeInFramesOut 'ma_uint32':'unsigned int'
|-FieldDecl 0x1160850e0 <line:23558:5, col:15> col:15 referenced periodsOut 'ma_uint32':'unsigned int'
|-FieldDecl 0x7fb209b558a0 <line:758:5, col:21> col:21 mSubframes 'SInt16':'short'
|-FieldDecl 0x7fb209b55900 <line:759:5, col:21> col:21 mSubframeDivisor 'SInt16':'short'
|-FieldDecl 0x7fb209b55960 <line:760:5, col:21> col:21 mCounter 'UInt32':'unsigned int'
|-FieldDecl 0x7fb209b559e0 <line:761:5, col:21> col:21 mType 'SMPTETimeType':'unsigned int'
|-FieldDecl 0x7fb209b55a60 <line:762:5, col:21> col:21 mFlags 'SMPTETimeFlags':'unsigned int'
|-FieldDecl 0x7fb209b55ac0 <line:763:5, col:21> col:21 mHours 'SInt16':'short'
|-FieldDecl 0x7fb209b55b20 <line:764:5, col:21> col:21 mMinutes 'SInt16':'short'
|-FieldDecl 0x7fb209b55b80 <line:765:5, col:21> col:21 mSeconds 'SInt16':'short'
|-FieldDecl 0x7fb209b56520 <line:820:5, col:25> col:25 mSampleTime 'Float64':'double'
|-FieldDecl 0x7fb209b565a0 <line:821:5, col:25> col:25 mHostTime 'UInt64':'unsigned long long'
|-FieldDecl 0x7fb209b56600 <line:822:5, col:25> col:25 mRateScalar 'Float64':'double'
|-FieldDecl 0x7fb209b56660 <line:823:5, col:25> col:25 mWordClockTime 'UInt64':'unsigned long long'
|-FieldDecl 0x7fb209b566e0 <line:824:5, col:25> col:25 mSMPTETime 'SMPTETime':'struct SMPTETime'
|-FieldDecl 0x7fb209b56760 <line:825:5, col:25> col:25 mFlags 'AudioTimeStampFlags':'unsigned int'
|-FieldDecl 0x7fb20b37a728 <line:897:2, col:30> col:30 referenced inputProc 'AURenderCallback _Nullable':'OSStatus (*)(void * _Nonnull, AudioUnitRenderActionFlags * _Nonnull, const AudioTimeStamp * _Nonnull, UInt32, UInt32, AudioBufferList * _Nullable)'
|-FieldDecl 0x7fb2090b20d0 <line:36:2, col:26> col:26 referenced tv_sec '__darwin_time_t':'long'
|-FieldDecl 0x7fb209ad2250 <line:9377:5, col:20> col:20 referenced deviceType 'ma_device_type':'ma_device_type'
|-FieldDecl 0x7fb209ad22b0 <line:9378:5, col:25> col:25 referenced pDeviceID 'const ma_device_id *'
|-FieldDecl 0x7fb209ad2318 <line:9379:5, col:11> col:11 referenced pName 'char *'
|-FieldDecl 0x7fb209ad2378 <line:9380:5, col:12> col:12 referenced nameBufferSize 'size_t':'unsigned long'
|-FieldDecl 0x7fb20b09ef60 <col:5, col:51> col:34 qmf_state 'float [960]'
|-FieldDecl 0x7fb20b09f030 <col:5, col:17> col:17 free_format_bytes 'int'
|-FieldDecl 0x7fb20b09e990 <col:5, col:22> col:22 referenced channels 'int'
|-FieldDecl 0x7fb20b09e9f8 <col:5, col:32> col:32 referenced hz 'int'
|-FieldDecl 0x7fb20b09ea60 <col:5, col:36> col:36 referenced layer 'int'
|-FieldDecl 0x7fb20b0d1170 <col:5, col:34> col:34 referenced big_values 'drmp3_uint16':'unsigned short'
|-FieldDecl 0x7fb20b0d11d0 <col:5, col:46> col:46 referenced scalefac_compress 'drmp3_uint16':'unsigned short'
|-FieldDecl 0x7fb20b0d1290 <col:5, col:30> col:30 referenced block_type 'drmp3_uint8':'unsigned char'
|-FieldDecl 0x7fb20b0d12f0 <col:5, col:42> col:42 referenced mixed_block_flag 'drmp3_uint8':'unsigned char'
|-FieldDecl 0x7fb20b0d1350 <col:5, col:60> col:60 referenced n_long_sfb 'drmp3_uint8':'unsigned char'
|-FieldDecl 0x7fb20b0d13b0 <col:5, col:72> col:72 referenced n_short_sfb 'drmp3_uint8':'unsigned char'
|-FieldDecl 0x7fb20b0d1540 <col:5, col:48> col:34 referenced region_count 'drmp3_uint8 [3]'
|-FieldDecl 0x7fb20b0d15e8 <col:5, col:66> col:51 referenced subblock_gain 'drmp3_uint8 [3]'
|-FieldDecl 0x7fb20b0d16a8 <col:5, col:26> col:26 referenced scalefac_scale 'drmp3_uint8':'unsigned char'
|-FieldDecl 0x7fb20b0d1708 <col:5, col:42> col:42 referenced count1_table 'drmp3_uint8':'unsigned char'
|-FieldDecl 0x7fb20b0d1f30 <col:5, col:32> col:26 referenced scf 'float [40]'
|-FieldDecl 0x7fb20b0d2120 <col:5, col:52> col:35 referenced syn 'float [33][64]'
|-FieldDecl 0x7fb20b0d0a80 <col:5, col:30> col:30 referenced stereo_bands 'drmp3_uint8':'unsigned char'
|-FieldDecl 0x7fb20b0d0ba8 <col:5, col:55> col:44 referenced bitalloc 'drmp3_uint8 [64]'
|-FieldDecl 0x116294d10 <col:4, col:23> col:23 referenced page_end 'uint32':'unsigned int'
|-FieldDecl 0x116291bb0 <col:4, col:20> col:20 referenced entries 'int'
|-FieldDecl 0x116293a70 <col:4, col:18> col:18 referenced end 'uint32':'unsigned int'
|-FieldDecl 0x116295640 <col:4, col:24> col:24 p_last 'ProbedPage':'ProbedPage'
|-FieldDecl 0x116295a00 <col:4, col:21> col:21 referenced blocksize_1 'int'
|-FieldDecl 0x116296980 <col:4, col:20> col:17 referenced B 'float *[2]'
|-FieldDecl 0x116296a30 <col:4, col:26> col:23 referenced C 'float *[2]'
|-FieldDecl 0x7fb20b0d0e80 <col:5, col:29> col:29 referenced code_tab_width 'drmp3_uint8':'unsigned char'
|-FieldDecl 0x7fb20799ff18 <col:22, col:26> col:26 referenced sched_priority 'int'
`-FieldDecl 0x7fb20b09f238 <col:5, col:42> col:28 referenced reserv_buf 'drmp3_uint8 [511]'
`-FieldDecl 0x7fb20b09eac8 <col:5, col:43> col:43 referenced bitrate_kbps 'int'
`-FieldDecl 0x7fb20b0d0720 <col:5, col:14> col:14 referenced limit 'int'
`-FieldDecl 0x7fb20b0d1768 <col:5, col:56> col:56 referenced scfsi 'drmp3_uint8':'unsigned char'
`-FieldDecl 0x7fb20b0d0c50 <col:5, col:67> col:58 referenced scfcod 'drmp3_uint8 [64]'
`-FieldDecl 0x7fb20b0d0ee0 <col:5, col:45> col:45 referenced band_count 'drmp3_uint8':'unsigned char'
`-FieldDecl 0x7fb20799ffc0 <col:43, col:77> col:48 __opaque 'char [4]'
`-FieldDecl 0x1162ae1c0 <col:4, col:13> col:13 referenced id 'uint16':'unsigned short'""";

final trickyIrgenFields =
"""
|-FieldDecl 0x7fb20780dc08 <<invalid sloc>> <invalid sloc> gp_offset 'unsigned int'
|-FieldDecl 0x7fb20780dc58 <<invalid sloc>> <invalid sloc> fp_offset 'unsigned int'
|-FieldDecl 0x7fb20780dca8 <<invalid sloc>> <invalid sloc> overflow_arg_area 'void *'""";

final LLVMTypes =
"""
  LLVMType:%struct.Floor1 = type { i8, [32 x i8], [16 x i8], [16 x i8], [16 x i8], [16 x [8 x i16]], [250 x i16], [250 x i8], [250 x [2 x i8]], i8, i8, i32 }
  LLVMType:%union.Floor = type { %struct.Floor1 }
  LLVMType:%struct.Residue = type { i32, i32, i32, i8, i8, i8**, [8 x i16]* }
  LLVMType:%struct.MappingChannel = type { i8, i8, i8 }
  LLVMType:%struct.Mapping = type { i16, %struct.MappingChannel*, i8, [15 x i8], [15 x i8] }
  LLVMType:%struct.Mode = type { i8, i8, i16, i16 }
  LLVMType:%struct.CRCscan = type { i32, i32, i32, i32, i32 }
  LLVMType:%struct.stb_vorbis = type { i32, i32, i32, i32, i32, i8*, i32, i8**, %struct.__sFILE*, i32, i32, i8*, i8*, i8*, i32, i8, i32, %struct.ProbedPage, %struct.ProbedPage, %struct.stb_vorbis_alloc, i32, i32, i32, i32, [2 x i32], i32, i32, i32, %struct.Codebook*, i32, [64 x i16], %union.Floor*, i32, [64 x i16], %struct.Residue*, i32, %struct.Mapping*, i32, [64 x %struct.Mode], i32, [16 x float*], [16 x float*], [16 x float*], i32, [16 x i16*], i32, i32, [2 x float*], [2 x float*], [2 x float*], [2 x float*], [2 x i16*], i32, i32, i32, [255 x i8], i8, i8, i8, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, [4 x %struct.CRCscan], i32, i32 }
  LLVMType:%struct.stb_vorbis_info = type { i32, i32, i32, i32, i32, i32 }
  LLVMType:%struct.stb_vorbis_comment = type { i8*, i32, i8** }
  LLVMType:%struct.drflac_init_info = type { i64 (i8*, i8*, i64)*, i32 (i8*, i32, i32)*, void (i8*, %struct.drflac_metadata*)*, i32, i8*, i8*, i32, i8, i8, i64, i16, i64, i32, i32, %struct.drflac_bs, %struct.drflac_frame_header }
  LLVMType:%struct.__loadu_si128 = type { <2 x i64> }
  LLVMType:%struct.__storeu_si128 = type { <2 x i64> }
  LLVMType:%struct.__storeu_ps = type { <4 x float> }
  LLVMType:%struct.__mm_storeh_pi_struct = type { <2 x float> }
  LLVMType:%struct.drmp3_L12_subband_alloc = type { i8, i8, i8 }
  LLVMType:%struct.__loadu_ps = type { <4 x float> }
  LLVMType:%union.anon.61 = type { i64 }
  LLVMType:%union.anon.62 = type { i32 }
  LLVMType:%struct._opaque_pthread_mutexattr_t = type { i64, [8 x i8] }
  LLVMType:%struct._opaque_pthread_condattr_t = type { i64, [8 x i8] }
  LLVMType:%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }
  LLVMType:%struct.sched_param = type { i32, [4 x i8] }
  LLVMType:%struct.AudioComponentDescription = type { i32, i32, i32, i32, i32 }
  LLVMType:%struct.AudioObjectPropertyAddress = type { i32, i32, i32 }
  LLVMType:%struct.AudioBuffer = type { i32, i32, i8* }
  LLVMType:%struct.AudioBufferList = type { i32, [1 x %struct.AudioBuffer] }
  LLVMType:%struct.AudioStreamBasicDescription = type { double, i32, i32, i32, i32, i32, i32, i32, i32 }
  LLVMType:%struct.AudioValueRange = type { double, double }
  LLVMType:%struct.AudioStreamRangedDescription = type { %struct.AudioStreamBasicDescription, %struct.AudioValueRange }""";

void main() {

  test("verify patterns match", () {
    final first = IRgenRecordLayoutPatterns.first;
    final second = IRgenRecordLayoutPatterns.second;
    final fieldPattern = IRgenRecordLayoutPatterns.fieldPattern;
    final last = CGRecordLayoutPatterns.last;

    final recordType = CGRecordLayoutPatterns.recordType;
    final LLVMTypePattern = CGRecordLayoutPatterns.LLVMTypePattern;
    final LLVMTypes0 = LLVMTypes.split('\n');
    for (int i=0; i<LLVMTypes0.length; i++) {
      if (!LLVMTypePattern.accept(LLVMTypes0[i])) {
        fail("Failed on line $i: ${LLVMTypes0[i]}");
      }
    }

    expect(fieldPattern.accept("|-FieldDecl 0x7fb20b0d0ba8 <col:5, col:55> col:44 referenced id 'int'"), true);
    expect(fieldPattern.accept("|-FieldDecl 0x7fb20b0d0ba8 <col:5, col:55> col:44 varName 'uint64':'unsigned int'"), true);
    expect(fieldPattern.accept("`-FieldDecl 0x7fb20b0d0ba8 <col:5, col:55> col:44 referenced id 'volatile char'"), true);
    expect(fieldPattern.accept("`-FieldDecl 0x7fb20b0d0ba8 <col:5, col:55> col:44 referenced __varName__ 'volatile double'"), true);
    expect(fieldPattern.accept("`-FieldDecl 0x7fb20b0d0ba8 <col:5, col:55> col:44 referenced superVarName 'const double'"), true);

    final inputs2 = firstDegreeFields.split("\n");
    for (int i=0; i<inputs2.length; i++) {
      if (!fieldPattern.accept(inputs2[i])) {
        fail("Failed on line $i: ${inputs2[i]}");
      }
    }

    final trickyIrgenFields0 = trickyIrgenFields.split('\n');
    for (int i=0; i<trickyIrgenFields0.length; i++) {
      expect(fieldPattern.accept(trickyIrgenFields0[i]), false);
    }

    // first line
    expect(first.accept('*** Dumping IRgen Record Layout'), true);

    // last line
    expect(last.accept(']>'), true);

    // 2nd line
    final firstParts = [
      'Record: RecordDecl 0x7fb20b287118 </pyminiaudio/miniaudio/miniaudio.h:123:123, line:332:15> line:3601:335 struct definition',
      'Record: RecordDecl 0x7fb20b287118 </pyminiaudio/miniaudio/miniaudio.h:123:123, line:332:15> line:3601:335 union definition',
      'Record: RecordDecl 0x7fb20b287118 </pyminiaudio/miniaudio/miniaudio.h:123:123, line:332:15> line:3601:335 struct meh definition',
      'Record: RecordDecl 0x7fb20b287118 prev 0x7fb20b287 </pyminiaudio/miniaudio/miniaudio.h:1:1, line:332:15> line:3601:53 union definition',
      'Record: RecordDecl 0x7fb20b287118 prev 0x7fb20b287 </pyminiaudio/miniaudio/miniaudio.h:1:1, line:332:15> line:3601:53 union meh definition',
    ];

    for (int i=0; i<firstParts.length; i++) {
      if (!second.accept(firstParts[i])) {
        fail('Failed for ($i): "${firstParts[i]}"');
      }
    }

    for (int i=0; i<trickyRecordDecls.length-2; i++) {
      if (!second.accept(trickyRecordDecls[i])) {
        fail('Failed for ($i): "${trickyRecordDecls[i]}"');
      }
    }

    // invalid lines: which implies, we must always have the source at hand
    expect(second.accept(trickyRecordDecls[3]), false);

    // 'col:' instead of 'line:'
    expect(second.accept(trickyRecordDecls[4]), true);

    final inputs1 = recordDecls.split("\n");
    for (int i=0; i<inputs1.length; i++) {
      if (!second.accept(inputs1[i])) {
        fail("Failed on line $i: ${inputs1[i]}");
      }
    }
  });
}
