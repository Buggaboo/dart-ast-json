import 'test_helpers.dart' show StringHelper;

final anonTypes = {
"/pyminiaudio/miniaudio/dr_flac.h:386:9" : "drflac_streaminfo"
"/pyminiaudio/miniaudio/dr_flac.h:418:9" : "struct_anon"
"/pyminiaudio/miniaudio/dr_flac.h:423:9" : "struct_anon_0"
"/pyminiaudio/miniaudio/dr_flac.h:378:9" : "drflac_seekpoint"
"/pyminiaudio/miniaudio/dr_flac.h:430:9" : "struct_anon_1"
"/pyminiaudio/miniaudio/dr_flac.h:436:9" : "struct_anon_2"
"/pyminiaudio/miniaudio/dr_flac.h:444:9" : "struct_anon_3"
"/pyminiaudio/miniaudio/dr_flac.h:453:9" : "struct_anon_4"
"/pyminiaudio/miniaudio/dr_flac.h:414:5" : "union_anon"
"/pyminiaudio/miniaudio/dr_flac.h:399:9" : "drflac_metadata"
"/pyminiaudio/miniaudio/dr_flac.h:550:9" : "drflac_allocation_callbacks"
"/pyminiaudio/miniaudio/dr_flac.h:626:9" : "drflac_frame_header"
"/pyminiaudio/miniaudio/dr_flac.h:611:9" : "drflac_subframe"
"/pyminiaudio/miniaudio/dr_flac.h:659:9" : "drflac_frame"
"/pyminiaudio/miniaudio/dr_flac.h:559:9" : "drflac__memory_stream"
"/pyminiaudio/miniaudio/dr_flac.h:567:9" : "drflac_bs"
"/pyminiaudio/miniaudio/dr_flac.h:674:9" : "drflac"
"/pyminiaudio/miniaudio/dr_flac.h:1237:9" : "drflac_vorbis_comment_iterator"
"/pyminiaudio/miniaudio/dr_flac.h:1257:9" : "drflac_cuesheet_track_iterator"
"/pyminiaudio/miniaudio/dr_flac.h:1265:9" : "drflac_cuesheet_track_index"
"/pyminiaudio/miniaudio/dr_flac.h:1273:9" : "drflac_cuesheet_track"
"/pyminiaudio/miniaudio/dr_mp3.h:248:9" : "drmp3dec"
"/pyminiaudio/miniaudio/dr_mp3.h:243:9" : "drmp3dec_frame_info"
"/pyminiaudio/miniaudio/dr_mp3.h:684:9" : "drmp3_bs"
"/pyminiaudio/miniaudio/dr_mp3.h:701:9" : "drmp3_L3_gr_info"
"/pyminiaudio/miniaudio/dr_mp3.h:710:9" : "drmp3dec_scratch"
"/pyminiaudio/miniaudio/dr_mp3.h:690:9" : "drmp3_L12_scale_info"
"/pyminiaudio/miniaudio/dr_mp3.h:320:9" : "drmp3_allocation_callbacks"
"/pyminiaudio/miniaudio/dr_mp3.h:284:9" : "drmp3_seek_point"
"/pyminiaudio/miniaudio/dr_mp3.h:358:5" : "struct_anon_5"
"/pyminiaudio/miniaudio/dr_mp3.h:334:9" : "drmp3"
"/pyminiaudio/miniaudio/dr_mp3.h:3925:9" : "drmp3__seeking_mp3_frame_info"
"/pyminiaudio/miniaudio/dr_mp3.h:328:9" : "drmp3_config"
"/pyminiaudio/miniaudio/dr_wav.h:312:9" : "drwav_fmt"
"/pyminiaudio/miniaudio/dr_wav.h:422:9" : "drwav_allocation_callbacks"
"/pyminiaudio/miniaudio/dr_wav.h:459:9" : "drwav_smpl_loop"
"/pyminiaudio/miniaudio/dr_wav.h:469:10" : "drwav_smpl"
"/pyminiaudio/miniaudio/dr_wav.h:431:9" : "drwav__memory_stream"
"/pyminiaudio/miniaudio/dr_wav.h:439:9" : "drwav__memory_stream_write"
"/pyminiaudio/miniaudio/dr_wav.h:553:5" : "struct_anon_6"
"/pyminiaudio/miniaudio/dr_wav.h:559:5" : "struct_anon_7"
"/pyminiaudio/miniaudio/dr_wav.h:570:5" : "struct_anon_8"
"/pyminiaudio/miniaudio/dr_wav.h:483:9" : "drwav"
"/pyminiaudio/miniaudio/dr_wav.h:296:5" : "union_anon_9"
"/pyminiaudio/miniaudio/dr_wav.h:294:9" : "drwav_chunk_header"
"/pyminiaudio/miniaudio/dr_wav.h:448:9" : "drwav_data_format"
"/pyminiaudio/miniaudio/miniaudio.h:1880:9" : "ma_allocation_callbacks"
"/Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/i386/_types.h:76:9" : "__mbstate_t"
"/pyminiaudio/miniaudio/miniaudio.h:2309:5" : "struct_anon_10"
"/pyminiaudio/miniaudio/miniaudio.h:2314:5" : "struct_anon_11"
"/pyminiaudio/miniaudio/miniaudio.h:2302:9" : "ma_resampler_config"
"/pyminiaudio/miniaudio/miniaudio.h:2254:9" : "ma_linear_resampler_config"
"/pyminiaudio/miniaudio/miniaudio.h:2273:5" : "union_anon_13"
"/pyminiaudio/miniaudio/miniaudio.h:2278:5" : "union_anon_14"
"/pyminiaudio/miniaudio/miniaudio.h:1899:9" : "ma_biquad_coefficient"
"/pyminiaudio/miniaudio/miniaudio.h:1955:9" : "ma_lpf1"
"/pyminiaudio/miniaudio/miniaudio.h:1919:9" : "ma_biquad"
"/pyminiaudio/miniaudio/miniaudio.h:1968:9" : "ma_lpf2"
"/pyminiaudio/miniaudio/miniaudio.h:1990:9" : "ma_lpf"
"/pyminiaudio/miniaudio/miniaudio.h:2266:9" : "ma_linear_resampler"
"/pyminiaudio/miniaudio/miniaudio.h:2328:9" : "struct_anon_15"
"/pyminiaudio/miniaudio/miniaudio.h:2325:5" : "union_anon_12"
"/pyminiaudio/miniaudio/miniaudio.h:2322:9" : "ma_resampler"
"/pyminiaudio/miniaudio/miniaudio.h:2921:9" : "struct_anon_17"
"/pyminiaudio/miniaudio/miniaudio.h:2912:5" : "union_anon_16"
"/pyminiaudio/miniaudio/miniaudio.h:2908:9" : "ma_mutex"
"/pyminiaudio/miniaudio/miniaudio.h:2943:9" : "struct_anon_19"
"/pyminiaudio/miniaudio/miniaudio.h:2934:5" : "union_anon_18"
"/pyminiaudio/miniaudio/miniaudio.h:2930:9" : "ma_event"
"/pyminiaudio/miniaudio/miniaudio.h:2899:9" : "struct_anon_21"
"/pyminiaudio/miniaudio/miniaudio.h:2890:5" : "union_anon_20"
"/pyminiaudio/miniaudio/miniaudio.h:2886:9" : "ma_thread"
"/pyminiaudio/miniaudio/miniaudio.h:3674:9" : "struct_anon_23"
"/pyminiaudio/miniaudio/miniaudio.h:3678:9" : "struct_anon_24"
"/pyminiaudio/miniaudio/miniaudio.h:3671:5" : "struct_anon_22"
"/pyminiaudio/miniaudio/miniaudio.h:2476:9" : "struct_anon_27"
"/pyminiaudio/miniaudio/miniaudio.h:2481:9" : "struct_anon_28"
"/pyminiaudio/miniaudio/miniaudio.h:2472:5" : "struct_anon_26"
"/pyminiaudio/miniaudio/miniaudio.h:2459:9" : "ma_data_converter_config"
"/pyminiaudio/miniaudio/miniaudio.h:2437:5" : "union_anon_29"
"/pyminiaudio/miniaudio/miniaudio.h:2429:9" : "ma_channel_converter"
"/pyminiaudio/miniaudio/miniaudio.h:2491:9" : "ma_data_converter"
"/pyminiaudio/miniaudio/miniaudio.h:3683:5" : "struct_anon_25"
"/pyminiaudio/miniaudio/miniaudio.h:3701:5" : "struct_anon_30"
"/pyminiaudio/miniaudio/miniaudio.h:2623:9" : "ma_rb"
"/pyminiaudio/miniaudio/miniaudio.h:2655:9" : "ma_pcm_rb"
"/pyminiaudio/miniaudio/miniaudio.h:3819:9" : "struct_anon_32"
"/pyminiaudio/miniaudio/miniaudio.h:3111:9" : "ma_timer"
"/pyminiaudio/miniaudio/miniaudio.h:3898:9" : "struct_anon_33"
"/pyminiaudio/miniaudio/miniaudio.h:3720:5" : "union_anon_31"
"/pyminiaudio/miniaudio/miniaudio.h:3117:9" : "ma_device_id"
"/pyminiaudio/miniaudio/miniaudio.h:3156:5" : "struct_anon_34"
"/pyminiaudio/miniaudio/miniaudio.h:3135:9" : "ma_device_info"
"/pyminiaudio/miniaudio/miniaudio.h:3178:9" : "struct_anon_36"
"/pyminiaudio/miniaudio/miniaudio.h:3182:9" : "struct_anon_37"
"/pyminiaudio/miniaudio/miniaudio.h:3175:5" : "struct_anon_35"
"/pyminiaudio/miniaudio/miniaudio.h:3187:5" : "struct_anon_38"
"/pyminiaudio/miniaudio/miniaudio.h:3195:5" : "struct_anon_39"
"/pyminiaudio/miniaudio/miniaudio.h:3204:5" : "struct_anon_40"
"/pyminiaudio/miniaudio/miniaudio.h:3211:5" : "struct_anon_41"
"/pyminiaudio/miniaudio/miniaudio.h:3218:5" : "struct_anon_42"
"/pyminiaudio/miniaudio/miniaudio.h:3162:9" : "ma_device_config"
"/pyminiaudio/miniaudio/miniaudio.h:3485:9" : "struct_anon_44"
"/pyminiaudio/miniaudio/miniaudio.h:3594:9" : "struct_anon_45"
"/pyminiaudio/miniaudio/miniaudio.h:3300:5" : "union_anon_43"
"/pyminiaudio/miniaudio/miniaudio.h:3625:9" : "struct_anon_47"
"/pyminiaudio/miniaudio/miniaudio.h:3601:5" : "union_anon_46"
"/pyminiaudio/miniaudio/miniaudio.h:2967:9" : "struct_anon_49"
"/pyminiaudio/miniaudio/miniaudio.h:2958:5" : "union_anon_48"
"/pyminiaudio/miniaudio/miniaudio.h:2954:9" : "ma_semaphore"
"/pyminiaudio/miniaudio/miniaudio.h:3231:5" : "struct_anon_50"
"/pyminiaudio/miniaudio/miniaudio.h:3235:5" : "struct_anon_51"
"/pyminiaudio/miniaudio/miniaudio.h:3241:5" : "struct_anon_52"
"/pyminiaudio/miniaudio/miniaudio.h:3246:5" : "struct_anon_53"
"/pyminiaudio/miniaudio/miniaudio.h:3225:9" : "ma_context_config"
"/pyminiaudio/miniaudio/miniaudio.h:1905:9" : "ma_biquad_config"
"/pyminiaudio/miniaudio/miniaudio.h:1943:9" : "ma_lpf1_config"
"/pyminiaudio/miniaudio/miniaudio.h:1979:9" : "ma_lpf_config"
"/pyminiaudio/miniaudio/miniaudio.h:2011:9" : "ma_hpf1_config"
"/pyminiaudio/miniaudio/miniaudio.h:2023:9" : "ma_hpf1"
"/pyminiaudio/miniaudio/miniaudio.h:2036:9" : "ma_hpf2"
"/pyminiaudio/miniaudio/miniaudio.h:2047:9" : "ma_hpf_config"
"/pyminiaudio/miniaudio/miniaudio.h:2058:9" : "ma_hpf"
"/pyminiaudio/miniaudio/miniaudio.h:2079:9" : "ma_bpf2_config"
"/pyminiaudio/miniaudio/miniaudio.h:2090:9" : "ma_bpf2"
"/pyminiaudio/miniaudio/miniaudio.h:2101:9" : "ma_bpf_config"
"/pyminiaudio/miniaudio/miniaudio.h:2112:9" : "ma_bpf"
"/pyminiaudio/miniaudio/miniaudio.h:2131:9" : "ma_notch2_config"
"/pyminiaudio/miniaudio/miniaudio.h:2142:9" : "ma_notch2"
"/pyminiaudio/miniaudio/miniaudio.h:2158:9" : "ma_peak2_config"
"/pyminiaudio/miniaudio/miniaudio.h:2170:9" : "ma_peak2"
"/pyminiaudio/miniaudio/miniaudio.h:2186:9" : "ma_loshelf2_config"
"/pyminiaudio/miniaudio/miniaudio.h:2198:9" : "ma_loshelf2"
"/pyminiaudio/miniaudio/miniaudio.h:2214:9" : "ma_hishelf2_config"
"/pyminiaudio/miniaudio/miniaudio.h:2226:9" : "ma_hishelf2"
"/pyminiaudio/miniaudio/miniaudio.h:2416:9" : "ma_channel_converter_config"
"/pyminiaudio/miniaudio/miniaudio.h:5267:9" : "struct_anon_55"
"/pyminiaudio/miniaudio/miniaudio.h:5271:9" : "struct_anon_56"
"/pyminiaudio/miniaudio/miniaudio.h:5264:5" : "struct_anon_54"
"/pyminiaudio/miniaudio/miniaudio.h:5256:9" : "ma_decoder_config"
"/pyminiaudio/miniaudio/miniaudio.h:5300:5" : "struct_anon_57"
"/pyminiaudio/miniaudio/miniaudio.h:5395:9" : "ma_encoder_config"
"/pyminiaudio/miniaudio/miniaudio.h:5442:9" : "ma_waveform_config"
"/pyminiaudio/miniaudio/miniaudio.h:5454:9" : "ma_waveform"
"/pyminiaudio/miniaudio/miniaudio.h:5476:9" : "ma_noise_config"
"/pyminiaudio/miniaudio/miniaudio.h:1888:9" : "ma_lcg"
"/pyminiaudio/miniaudio/miniaudio.h:5494:9" : "struct_anon_59"
"/pyminiaudio/miniaudio/miniaudio.h:5500:9" : "struct_anon_60"
"/pyminiaudio/miniaudio/miniaudio.h:5492:5" : "union_anon_58"
"/pyminiaudio/miniaudio/miniaudio.h:5488:9" : "ma_noise"
"/pyminiaudio/miniaudio/stb_vorbis.c:762:9" : "ProbedPage"
"/pyminiaudio/miniaudio/stb_vorbis.c:113:9" : "stb_vorbis_alloc"
"/pyminiaudio/miniaudio/stb_vorbis.c:663:9" : "Codebook"
"/pyminiaudio/miniaudio/stb_vorbis.c:686:9" : "Floor0"
"/pyminiaudio/miniaudio/stb_vorbis.c:697:9" : "Floor1"
"/pyminiaudio/miniaudio/stb_vorbis.c:713:9" : "Floor"
"/pyminiaudio/miniaudio/stb_vorbis.c:719:9" : "Residue"
"/pyminiaudio/miniaudio/stb_vorbis.c:729:9" : "MappingChannel"
"/pyminiaudio/miniaudio/stb_vorbis.c:736:9" : "Mapping"
"/pyminiaudio/miniaudio/stb_vorbis.c:745:9" : "Mode"
"/pyminiaudio/miniaudio/stb_vorbis.c:753:9" : "CRCscan"
"/pyminiaudio/miniaudio/stb_vorbis.c:124:9" : "stb_vorbis_info"
"/pyminiaudio/miniaudio/stb_vorbis.c:136:9" : "stb_vorbis_comment"
"/pyminiaudio/miniaudio/dr_flac.h:6058:9" : "drflac_init_info"
"/pyminiaudio/miniaudio/dr_mp3.h:696:9" : "drmp3_L12_subband_alloc"
"/pyminiaudio/miniaudio/dr_wav.h:1277:5" : "union_anon_61"
"/pyminiaudio/miniaudio/dr_wav.h:1256:5" : "union_anon_62"
"/pyminiaudio/miniaudio/miniaudio.h:23529:9" : "ma_device_init_internal_data__coreaudio"
"/pyminiaudio/miniaudio/miniaudio.h:9375:9" : "ma_context__try_get_device_name_by_id__enum_callback_data"
"/pyminiaudio/miniaudio/miniaudio.h:39799:9" : "ma_vorbis_decoder"
"/pyminiaudio/miniaudio/stb_vorbis.c:1298:9" : "stbv__floor_ordering"
"/pyminiaudio/miniaudio/stb_vorbis.c:5119:12" : "float_conv"
};

final desugaredTypes =
'''
AudioBuffer [1]
AudioBufferList *
AudioChannelDescription [1]
CRCscan [4]
Codebook *
FILE *
Float32 [3]
Floor *
Floor0
Floor1
Mapping *
MappingChannel *
Mode [64]
OSStatus (*)(void * _Nonnull, AudioUnitRenderActionFlags * _Nonnull, const AudioTimeStamp * _Nonnull, UInt32, UInt32, AudioBufferList * _Nullable)
ProbedPage
Residue *
__attribute__((__vector_size__(2 * sizeof(float)))) float
__attribute__((__vector_size__(2 * sizeof(long long)))) long long
__attribute__((__vector_size__(4 * sizeof(float)))) float
__int32_t [32]
char *
char **
char [128]
char [12]
char [256]
char [32]
char [40]
char [4]
char [56]
char [64]
char [8176]
char [8]
codetype *
const char *
const drflac_cuesheet_track_index *
const drflac_seekpoint *
const drflac_uint8 *
const drmp3_uint8 *
const drwav_uint8 *
const ma_device_id *
const ma_uint8 *
const void *
double
double [32]
double [32][16]
drflac__memory_stream
drflac_allocation_callbacks
drflac_bool32 (*)(void *, int, drflac_seek_origin)
drflac_bs
drflac_cache_t [512]
drflac_container
drflac_frame
drflac_frame_header
drflac_int32 *
drflac_seekpoint *
drflac_streaminfo
drflac_subframe [8]
drflac_uint8 [16]
drflac_uint8 [1]
drflac_uint8 [3]
drmp3_L3_gr_info [4]
drmp3_allocation_callbacks
drmp3_bool32 (*)(void *, int, drmp3_seek_origin)
drmp3_bs
drmp3_seek_point *
drmp3_uint8 *
drmp3_uint8 [2815]
drmp3_uint8 [2][39]
drmp3_uint8 [3]
drmp3_uint8 [4]
drmp3_uint8 [511]
drmp3_uint8 [64]
drmp3_uint8 [9216]
drmp3dec
drmp3dec_frame_info
drwav__memory_stream
drwav__memory_stream_write
drwav_allocation_callbacks
drwav_bool32 (*)(void *, int, drwav_seek_origin)
drwav_container
drwav_fmt
drwav_int32 [16]
drwav_int32 [2]
drwav_int32 [2][2]
drwav_int32 [4]
drwav_smpl
drwav_smpl_loop [1]
drwav_uint16 [2]
drwav_uint8 [16]
drwav_uint8 [4]
enum STBVorbisError
float
float **
float *[16]
float *[2]
float [192]
float [2][288]
float [2][576]
float [32]
float [32][32]
float [33][64]
float [40]
float [960]
fpos_t (*)(void *, fpos_t, int)
int
int (*)(void *)
int (*)(void *, char *, int)
int (*)(void *, const char *, int)
int *
int [2]
int16 (*)[8]
int16 *[16]
int16 [1024]
int16 [16][8]
long
long long
ma_allocation_callbacks
ma_backend
ma_biquad
ma_biquad_coefficient
ma_biquad_coefficient [32]
ma_bool32 (*)(ma_context *, const ma_device_id *, const ma_device_id *)
ma_bool32 (*)(ma_decoder *, int, ma_seek_origin)
ma_bool32 (*)(ma_encoder *, int, ma_seek_origin)
ma_bpf2 [4]
ma_channel [32]
ma_channel_converter
ma_channel_mix_mode
ma_context *
ma_data_converter
ma_data_converter_config
ma_device_id
ma_device_id *
ma_device_info *
ma_device_type
ma_dither_mode
ma_encoder_config
ma_event
ma_format
ma_format [6]
ma_hpf1 [1]
ma_hpf2 [4]
ma_int16 [32]
ma_int32 [32][32]
ma_ios_session_category
ma_lcg
ma_linear_resampler
ma_linear_resampler_config
ma_lpf
ma_lpf1 [1]
ma_lpf2 [4]
ma_mutex
ma_noise_config
ma_noise_type
ma_pcm_rb
ma_performance_profile
ma_rb
ma_resample_algorithm
ma_resampler
ma_resampler_config
ma_resource_format
ma_result (*)(ma_context *)
ma_result (*)(ma_context *, const ma_device_config *, ma_device *)
ma_result (*)(ma_context *, ma_device_type, const ma_device_id *, ma_share_mode, ma_device_info *)
ma_result (*)(ma_context *, ma_enum_devices_callback_proc, void *)
ma_result (*)(ma_decoder *)
ma_result (*)(ma_decoder *, ma_uint64)
ma_result (*)(ma_device *)
ma_result (*)(ma_encoder *)
ma_share_mode
ma_thread
ma_thread_priority
ma_timer
ma_uint32 [32]
ma_uint64 (*)(ma_decoder *)
ma_uint64 (*)(ma_decoder *, void *, ma_uint64)
ma_uint64 (*)(ma_encoder *, const void *, ma_uint64)
ma_uint8 *
ma_uint8 [16]
ma_uint8 [32]
ma_waveform_config
ma_waveform_type
short
size_t (*)(ma_decoder *, void *, size_t)
size_t (*)(ma_encoder *, const void *, size_t)
size_t (*)(void *, const void *, size_t)
size_t (*)(void *, void *, size_t)
size_t *
stb_vorbis *
stb_vorbis_alloc
struct AudioStreamBasicDescription
struct AudioValueRange
struct ComponentInstanceRecord *
struct OpaqueAudioComponent *
struct SMPTETime
struct __darwin_pthread_handler_rec *
struct __sFILEX *
struct __sbuf
struct _opaque_pthread_cond_t
struct _opaque_pthread_mutex_t
struct _opaque_pthread_t *
struct drflac_metadata::(anonymous at /pyminiaudio/miniaudio/dr_flac.h:418:9)
struct drflac_metadata::(anonymous at /pyminiaudio/miniaudio/dr_flac.h:423:9)
struct drflac_metadata::(anonymous at /pyminiaudio/miniaudio/dr_flac.h:430:9)
struct drflac_metadata::(anonymous at /pyminiaudio/miniaudio/dr_flac.h:436:9)
struct drflac_metadata::(anonymous at /pyminiaudio/miniaudio/dr_flac.h:444:9)
struct drflac_metadata::(anonymous at /pyminiaudio/miniaudio/dr_flac.h:453:9)
struct drmp3::(anonymous at /pyminiaudio/miniaudio/dr_mp3.h:358:5)
struct drwav::(anonymous at /pyminiaudio/miniaudio/dr_wav.h:553:5)
struct drwav::(anonymous at /pyminiaudio/miniaudio/dr_wav.h:559:5)
struct drwav::(anonymous at /pyminiaudio/miniaudio/dr_wav.h:570:5)
struct ma_context::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3485:9)
struct ma_context::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3594:9)
struct ma_context::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3625:9)
struct ma_context_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3231:5)
struct ma_context_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3235:5)
struct ma_context_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3241:5)
struct ma_context_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3246:5)
struct ma_data_converter_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2472:5)
struct ma_data_converter_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2476:9)
struct ma_data_converter_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2481:9)
struct ma_decoder::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:5300:5)
struct ma_decoder_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:5264:5)
struct ma_decoder_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:5267:9)
struct ma_decoder_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:5271:9)
struct ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3671:5)
struct ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3674:9)
struct ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3678:9)
struct ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3683:5)
struct ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3701:5)
struct ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3819:9)
struct ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3898:9)
struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3175:5)
struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3178:9)
struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3182:9)
struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3187:5)
struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3195:5)
struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3204:5)
struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3211:5)
struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3218:5)
struct ma_device_info::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3156:5)
struct ma_event::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2943:9)
struct ma_mutex::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2921:9)
struct ma_noise::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:5494:9)
struct ma_noise::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:5500:9)
struct ma_resampler::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2328:9)
struct ma_resampler_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2309:5)
struct ma_resampler_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2314:5)
struct ma_semaphore::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2967:9)
struct ma_thread::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2899:9)
uint16 *[2]
uint16 [250]
uint16 [64]
uint32 *
uint8 *
uint8 **
uint8 [15]
uint8 [16]
uint8 [250]
uint8 [250][2]
uint8 [255]
uint8 [32]
union drflac_metadata::(anonymous at /pyminiaudio/miniaudio/dr_flac.h:414:5)
union drwav_chunk_header::(anonymous at /pyminiaudio/miniaudio/dr_wav.h:296:5)
union ma_channel_converter::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2437:5)
union ma_linear_resampler::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2273:5)
union ma_linear_resampler::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2278:5)
union ma_noise::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:5492:5)
union ma_resampler::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2325:5)
unsigned char
unsigned char *
unsigned char [1]
unsigned char [3]
unsigned int
unsigned long
unsigned long long
unsigned short
void (*)(ma_context *, ma_device *, ma_uint32, const char *)
void (*)(ma_device *)
void (*)(ma_device *, void *, const void *, ma_uint32)
void (*)(ma_encoder *)
void (*)(void *)
void (*)(void *, drflac_metadata *)
void (*)(void *, void *)
void (*)(void)
void *
void *(*)(size_t, void *)
void *(*)(void *, size_t, void *)
void **
volatile float
volatile unsigned int
wchar_t [64]
'''.splitMapTrim();

final structs =
'''
AURenderCallbackStruct
AudioBuffer
AudioBufferList
AudioChannelDescription
AudioChannelLayout
AudioComponentDescription
AudioObjectPropertyAddress
AudioStreamBasicDescription
AudioStreamRangedDescription
AudioTimeStamp
AudioValueRange
CRCscan
Codebook
Floor0
Floor1
Mapping
MappingChannel
Mode
ProbedPage
Residue
SMPTETime
__darwin_pthread_handler_rec
__loadu_ps
__loadu_si128
__mm_storeh_pi_struct
__sFILE
__sbuf
__storeu_ps
__storeu_si128
_opaque_pthread_attr_t
_opaque_pthread_cond_t
_opaque_pthread_condattr_t
_opaque_pthread_mutex_t
_opaque_pthread_mutexattr_t
_opaque_pthread_t
drflac
drflac__memory_stream
drflac_allocation_callbacks
drflac_bs
drflac_cuesheet_track
drflac_cuesheet_track_index
drflac_cuesheet_track_iterator
drflac_frame
drflac_frame_header
drflac_init_info
drflac_metadata
drflac_seekpoint
drflac_streaminfo
drflac_subframe
drflac_vorbis_comment_iterator
drmp3
drmp3_L12_scale_info
drmp3_L12_subband_alloc
drmp3_L3_gr_info
drmp3__seeking_mp3_frame_info
drmp3_allocation_callbacks
drmp3_bs
drmp3_config
drmp3_seek_point
drmp3dec
drmp3dec_frame_info
drmp3dec_scratch
drwav
drwav__memory_stream
drwav__memory_stream_write
drwav_allocation_callbacks
drwav_chunk_header
drwav_data_format
drwav_fmt
drwav_smpl
drwav_smpl_loop
fd_set
ma_allocation_callbacks
ma_biquad
ma_biquad_config
ma_bpf
ma_bpf2
ma_bpf2_config
ma_bpf_config
ma_channel_converter
ma_channel_converter_config
ma_context
ma_context__try_get_device_name_by_id__enum_callback_data
ma_context_config
ma_data_converter
ma_data_converter_config
ma_decoder
ma_decoder_config
ma_device
ma_device_config
ma_device_info
ma_device_init_internal_data__coreaudio
ma_encoder
ma_encoder_config
ma_event
ma_hishelf2
ma_hishelf2_config
ma_hpf
ma_hpf1
ma_hpf1_config
ma_hpf2
ma_hpf_config
ma_lcg
ma_linear_resampler
ma_linear_resampler_config
ma_loshelf2
ma_loshelf2_config
ma_lpf
ma_lpf1
ma_lpf1_config
ma_lpf2
ma_lpf_config
ma_mutex
ma_noise
ma_noise_config
ma_notch2
ma_notch2_config
ma_pcm_rb
ma_peak2
ma_peak2_config
ma_rb
ma_resampler
ma_resampler_config
ma_semaphore
ma_thread
ma_vorbis_decoder
ma_waveform
ma_waveform_config
sched_param
stb_vorbis
stb_vorbis_alloc
stb_vorbis_comment
stb_vorbis_info
stbv__floor_ordering
struct_anon
struct_anon_0
struct_anon_1
struct_anon_10
struct_anon_11
struct_anon_15
struct_anon_17
struct_anon_19
struct_anon_2
struct_anon_21
struct_anon_22
struct_anon_23
struct_anon_24
struct_anon_25
struct_anon_26
struct_anon_27
struct_anon_28
struct_anon_3
struct_anon_30
struct_anon_32
struct_anon_33
struct_anon_34
struct_anon_35
struct_anon_36
struct_anon_37
struct_anon_38
struct_anon_39
struct_anon_4
struct_anon_40
struct_anon_41
struct_anon_42
struct_anon_44
struct_anon_45
struct_anon_47
struct_anon_49
struct_anon_5
struct_anon_50
struct_anon_51
struct_anon_52
struct_anon_53
struct_anon_54
struct_anon_55
struct_anon_56
struct_anon_57
struct_anon_59
struct_anon_6
struct_anon_60
struct_anon_7
struct_anon_8
timeval
'''.splitMapTrim();

final unions =
'''
Floor
__mbstate_t
float_conv
ma_biquad_coefficient
ma_device_id
ma_timer
union_anon
union_anon_12
union_anon_13
union_anon_14
union_anon_16
union_anon_18
union_anon_20
union_anon_29
union_anon_31
union_anon_43
union_anon_46
union_anon_48
union_anon_58
union_anon_61
union_anon_62
union_anon_9
'''.splitMapTrim();


final scalar2ffi = {
  'long': 'nt64'
  , 'int' : 'nt32'
  , 'short' : 'nt16'
  , 'char' : 'nt8'
  , 'double' : 'Double'
  , 'float' : 'Float'
  , 'void' : 'Void'
};

final sign2ffi = (String s) => s.contains('unsigned') ? 'Ui' : 'I';

final stripSymbols = [ 'volatile', 'const', ];

void main() {

}