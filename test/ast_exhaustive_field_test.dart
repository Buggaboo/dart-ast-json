import 'package:test/test.dart';
import 'package:dart_ast_json/src/layout_parser.dart';
import 'package:petitparser/petitparser.dart' show Parser, AcceptParser;

final fields =
"""
         0 |   void (*)(int) __sa_handler
         0 |   void (*)(int, struct __siginfo *, void *) __sa_sigaction
         0 |   drflac_uint16 minBlockSizeInPCMFrames
         2 |   drflac_uint16 maxBlockSizeInPCMFrames
         4 |   drflac_uint32 minFrameSizeInPCMFrames
         8 |   drflac_uint32 maxFrameSizeInPCMFrames
        12 |   drflac_uint32 sampleRate
        16 |   drflac_uint8 channels
        17 |   drflac_uint8 bitsPerSample
        24 |   drflac_uint64 totalPCMFrameCount
        32 |   drflac_uint8 [16] md5
         0 |   drflac_uint8 subframeType
         1 |   drflac_uint8 wastedBitsPerSample
         2 |   drflac_uint8 lpcOrder
         8 |   drflac_int32 * pSamplesS32
         0 |   drflac_uint64 pcmFrameNumber
         8 |   drflac_uint32 flacFrameNumber
        12 |   drflac_uint32 sampleRate
        16 |   drflac_uint16 blockSizeInPCMFrames
        18 |   drflac_uint8 channelAssignment
        19 |   drflac_uint8 bitsPerSample
        20 |   drflac_uint8 crc8
         0 |   drflac_frame_header header
        24 |   drflac_uint32 pcmFramesRemaining
        32 |   drflac_subframe [8] subframes
         0 |   int unused
         0 |   drflac_uint32 id
         8 |   const void * pData
        16 |   drflac_uint32 dataSize
         0 |   drflac_uint32 seekpointCount
         8 |   const drflac_seekpoint * pSeekpoints
         0 |   drflac_uint32 vendorLength
         8 |   const char * vendor
        16 |   drflac_uint32 commentCount
        24 |   const void * pComments
         0 |   char [128] catalog
       128 |   drflac_uint64 leadInSampleCount
       136 |   drflac_bool32 isCD
       140 |   drflac_uint8 trackCount
       144 |   const void * pTrackData
         0 |   drflac_uint32 type
         4 |   drflac_uint32 mimeLength
         8 |   const char * mime
        16 |   drflac_uint32 descriptionLength
        24 |   const char * description
        32 |   drflac_uint32 width
        36 |   drflac_uint32 height
        40 |   drflac_uint32 colorDepth
        44 |   drflac_uint32 indexColorCount
        48 |   drflac_uint32 pictureDataSize
        56 |   const drflac_uint8 * pPictureData
         0 |   drflac_streaminfo streaminfo
         0 |   struct drflac_metadata::(anonymous at /pyminiaudio/miniaudio/dr_flac.h:418:9) padding
         0 |   struct drflac_metadata::(anonymous at /pyminiaudio/miniaudio/dr_flac.h:423:9) application
         0 |   struct drflac_metadata::(anonymous at /pyminiaudio/miniaudio/dr_flac.h:430:9) seektable
         0 |   struct drflac_metadata::(anonymous at /pyminiaudio/miniaudio/dr_flac.h:436:9) vorbis_comment
         0 |   struct drflac_metadata::(anonymous at /pyminiaudio/miniaudio/dr_flac.h:444:9) cuesheet
         0 |   struct drflac_metadata::(anonymous at /pyminiaudio/miniaudio/dr_flac.h:453:9) picture
         0 |   drflac_uint32 type
         8 |   const void * pRawData
        16 |   drflac_uint32 rawDataSize
        24 |   union drflac_metadata::(anonymous at /pyminiaudio/miniaudio/dr_flac.h:414:5) data
         0 |   drflac_uint64 firstPCMFrame
         8 |   drflac_uint64 flacFrameOffset
        16 |   drflac_uint16 pcmFrameCount
         0 |   drflac_uint64 offset
         8 |   drflac_uint8 index
         9 |   drflac_uint8 [3] reserved
         0 |   void * pUserData
         8 |   void *(*)(size_t, void *) onMalloc
        16 |   void *(*)(void *, size_t, void *) onRealloc
        24 |   void (*)(void *, void *) onFree
         0 |   const drflac_uint8 * data
         8 |   size_t dataSize
        16 |   size_t currentReadPos
         0 |   drflac_read_proc onRead
         8 |   drflac_seek_proc onSeek
        16 |   void * pUserData
        24 |   size_t unalignedByteCount
        32 |   drflac_cache_t unalignedCache
        40 |   drflac_uint32 nextL2Line
        44 |   drflac_uint32 consumedBits
        48 |   drflac_cache_t [512] cacheL2
      4144 |   drflac_cache_t cache
      4152 |   drflac_uint16 crc16
      4160 |   drflac_cache_t crc16Cache
      4168 |   drflac_uint32 crc16CacheIgnoredBytes
         0 |   drflac_meta_proc onMeta
         8 |   void * pUserDataMD
        16 |   drflac_allocation_callbacks allocationCallbacks
        48 |   drflac_uint32 sampleRate
        52 |   drflac_uint8 channels
        53 |   drflac_uint8 bitsPerSample
        54 |   drflac_uint16 maxBlockSizeInPCMFrames
        56 |   drflac_uint64 totalPCMFrameCount
        64 |   drflac_container container
        68 |   drflac_uint32 seekpointCount
        72 |   drflac_frame currentFLACFrame
       232 |   drflac_uint64 currentPCMFrame
       240 |   drflac_uint64 firstFLACFramePosInBytes
       248 |   drflac__memory_stream memoryStream
       272 |   drflac_int32 * pDecodedSamples
       280 |   drflac_seekpoint * pSeekpoints
       288 |   void * _oggbs
   296:0-0 |   drflac_bool32 _noSeekTableSeek
   296:1-1 |   drflac_bool32 _noBinarySearchSeek
   296:2-2 |   drflac_bool32 _noBruteForceSeek
       304 |   drflac_bs bs
      4480 |   drflac_uint8 [1] pExtraData
         0 |   drflac_read_proc onRead
         8 |   drflac_seek_proc onSeek
        16 |   drflac_meta_proc onMeta
        24 |   drflac_container container
        32 |   void * pUserData
        40 |   void * pUserDataMD
        48 |   drflac_uint32 sampleRate
        52 |   drflac_uint8 channels
        53 |   drflac_uint8 bitsPerSample
        56 |   drflac_uint64 totalPCMFrameCount
        64 |   drflac_uint16 maxBlockSizeInPCMFrames
        72 |   drflac_uint64 runningFilePos
        80 |   drflac_bool32 hasStreamInfoBlock
        84 |   drflac_bool32 hasMetadataBlocks
        88 |   drflac_bs bs
      4264 |   drflac_frame_header firstFrameHeader
         0 |   int __nranges
         0 |   char [8] __magic
         8 |   char [32] __encoding
        48 |   int (*)(__darwin_rune_t, char *, __darwin_size_t, char **) __sputrune
      3184 |   void * __variable
      3192 |   int __variable_len
      3196 |   int __ncharclasses
         0 |   char [128] __mbstate8
         0 |   long long _mbstateL
         0 |   unsigned char * _base
         8 |   int _size
         0 |   unsigned char * _p
         8 |   int _r
        12 |   int _w
        16 |   short _flags
        18 |   short _file
        24 |   struct __sbuf _bf
        40 |   int _lbfsize
        48 |   void * _cookie
        56 |   int (* _Nullable)(void *) _close
        64 |   int (* _Nullable)(void *, char *, int) _read
        72 |   fpos_t (* _Nullable)(void *, fpos_t, int) _seek
        80 |   int (* _Nullable)(void *, const char *, int) _write
        88 |   struct __sbuf _ub
       104 |   struct __sFILEX * _extra
       112 |   int _ur
       116 |   unsigned char [3] _ubuf
       119 |   unsigned char [1] _nbuf
       120 |   struct __sbuf _lb
       136 |   int _blksize
       144 |   fpos_t _offset
         0 |   drflac_uint32 countRemaining
         8 |   const char * pRunningData
         0 |   drflac_uint32 countRemaining
         8 |   const char * pRunningData
         0 |   drflac_uint64 offset
         8 |   drflac_uint8 trackNumber
         9 |   char [12] ISRC
        21 |   drflac_bool8 isAudio
        22 |   drflac_bool8 preEmphasis
        23 |   drflac_uint8 indexCount
        24 |   const drflac_cuesheet_track_index * pIndexPoints
         0 |   float [2][288] mdct_overlap
      2304 |   float [960] qmf_state
      6144 |   int reserv
      6148 |   int free_format_bytes
      6152 |   drmp3_uint8 [4] header
      6156 |   drmp3_uint8 [511] reserv_buf
         0 |   const drmp3_uint8 * sfbtab
         8 |   drmp3_uint16 part_23_length
        10 |   drmp3_uint16 big_values
        12 |   drmp3_uint16 scalefac_compress
        14 |   drmp3_uint8 global_gain
        15 |   drmp3_uint8 block_type
        16 |   drmp3_uint8 mixed_block_flag
        17 |   drmp3_uint8 n_long_sfb
        18 |   drmp3_uint8 n_short_sfb
        19 |   drmp3_uint8 [3] table_select
        22 |   drmp3_uint8 [3] region_count
        25 |   drmp3_uint8 [3] subblock_gain
        28 |   drmp3_uint8 preflag
        29 |   drmp3_uint8 scalefac_scale
        30 |   drmp3_uint8 count1_table
        31 |   drmp3_uint8 scfsi
         0 |   const drmp3_uint8 * buf
         8 |   int pos
        12 |   int limit
         0 |   drmp3_bs bs
        16 |   drmp3_uint8 [2815] maindata
      2832 |   drmp3_L3_gr_info [4] gr_info
      2960 |   float [2][576] grbuf
      7568 |   float [40] scf
      7728 |   float [33][64] syn
     16176 |   drmp3_uint8 [2][39] ist_pos
         0 |   float [192] scf
       768 |   drmp3_uint8 total_bands
       769 |   drmp3_uint8 stereo_bands
       770 |   drmp3_uint8 [64] bitalloc
       834 |   drmp3_uint8 [64] scfcod
         0 |   int frame_bytes
         4 |   int channels
         8 |   int hz
        12 |   int layer
        16 |   int bitrate_kbps
         0 |   void * pUserData
         8 |   void *(*)(size_t, void *) onMalloc
        16 |   void *(*)(void *, size_t, void *) onRealloc
        24 |   void (*)(void *, void *) onFree
         0 |   const drmp3_uint8 * pData
         8 |   size_t dataSize
        16 |   size_t currentReadPos
         0 |   drmp3dec decoder
      6668 |   drmp3dec_frame_info frameInfo
      6688 |   drmp3_uint32 channels
      6692 |   drmp3_uint32 sampleRate
      6696 |   drmp3_read_proc onRead
      6704 |   drmp3_seek_proc onSeek
      6712 |   void * pUserData
      6720 |   drmp3_allocation_callbacks allocationCallbacks
      6752 |   drmp3_uint32 mp3FrameChannels
      6756 |   drmp3_uint32 mp3FrameSampleRate
      6760 |   drmp3_uint32 pcmFramesConsumedInMP3Frame
      6764 |   drmp3_uint32 pcmFramesRemainingInMP3Frame
      6768 |   drmp3_uint8 [9216] pcmFrames
     15984 |   drmp3_uint64 currentPCMFrame
     15992 |   drmp3_uint64 streamCursor
     16000 |   drmp3_seek_point * pSeekPoints
     16008 |   drmp3_uint32 seekPointCount
     16016 |   size_t dataSize
     16024 |   size_t dataCapacity
     16032 |   size_t dataConsumed
     16040 |   drmp3_uint8 * pData
 16048:0-0 |   drmp3_bool32 atEnd
     16056 |   struct drmp3::(anonymous at /pyminiaudio/miniaudio/dr_mp3.h:358:5) memory
         0 |   drmp3_uint64 seekPosInBytes
         8 |   drmp3_uint64 pcmFrameIndex
        16 |   drmp3_uint16 mp3FramesToDiscard
        18 |   drmp3_uint16 pcmFramesToDiscard
         0 |   drmp3_uint64 bytePos
         8 |   drmp3_uint64 pcmFrameIndex
         0 |   drmp3_uint32 channels
         4 |   drmp3_uint32 sampleRate
         0 |   drwav_uint8 [4] fourcc
         0 |   drwav_uint8 [16] guid
         0 |   drwav_uint32 cuePointId
         4 |   drwav_uint32 type
         8 |   drwav_uint32 start
        12 |   drwav_uint32 end
        16 |   drwav_uint32 fraction
        20 |   drwav_uint32 playCount
         0 |   drwav_uint32 i
         0 |   float f
         0 |   drwav_uint64 i
         0 |   double f
         0 |   union drwav_chunk_header::(anonymous at /pyminiaudio/miniaudio/dr_wav.h:296:5) id
        16 |   drwav_uint64 sizeInBytes
        24 |   unsigned int paddingSize
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
         0 |   void * pUserData
         8 |   void *(*)(size_t, void *) onMalloc
        16 |   void *(*)(void *, size_t, void *) onRealloc
        24 |   void (*)(void *, void *) onFree
         0 |   drwav_uint32 manufacturer
         4 |   drwav_uint32 product
         8 |   drwav_uint32 samplePeriod
        12 |   drwav_uint32 midiUnityNotes
        16 |   drwav_uint32 midiPitchFraction
        20 |   drwav_uint32 smpteFormat
        24 |   drwav_uint32 smpteOffset
        28 |   drwav_uint32 numSampleLoops
        32 |   drwav_uint32 samplerData
        36 |   drwav_smpl_loop [1] loops
         0 |   const drwav_uint8 * data
         8 |   size_t dataSize
        16 |   size_t currentReadPos
         0 |   void ** ppData
         8 |   size_t * pDataSize
        16 |   size_t dataSize
        24 |   size_t dataCapacity
        32 |   size_t currentWritePos
         0 |   drwav_uint64 iCurrentPCMFrame
         0 |   drwav_uint32 bytesRemainingInBlock
         4 |   drwav_uint16 [2] predictor
         8 |   drwav_int32 [2] delta
        16 |   drwav_int32 [4] cachedFrames
        32 |   drwav_uint32 cachedFrameCount
        36 |   drwav_int32 [2][2] prevFrames
         0 |   drwav_uint32 bytesRemainingInBlock
         4 |   drwav_int32 [2] predictor
        12 |   drwav_int32 [2] stepIndex
        20 |   drwav_int32 [16] cachedFrames
        84 |   drwav_uint32 cachedFrameCount
         0 |   drwav_read_proc onRead
         8 |   drwav_write_proc onWrite
        16 |   drwav_seek_proc onSeek
        24 |   void * pUserData
        32 |   drwav_allocation_callbacks allocationCallbacks
        64 |   drwav_container container
        68 |   drwav_fmt fmt
       108 |   drwav_uint32 sampleRate
       112 |   drwav_uint16 channels
       114 |   drwav_uint16 bitsPerSample
       116 |   drwav_uint16 translatedFormatTag
       120 |   drwav_uint64 totalPCMFrameCount
       128 |   drwav_uint64 dataChunkDataSize
       136 |   drwav_uint64 dataChunkDataPos
       144 |   drwav_uint64 bytesRemaining
       152 |   drwav_uint64 dataChunkDataSizeTargetWrite
       160 |   drwav_bool32 isSequentialWrite
       164 |   drwav_smpl smpl
       224 |   drwav__memory_stream memoryStream
       248 |   drwav__memory_stream_write memoryStreamWrite
       288 |   struct drwav::(anonymous at /pyminiaudio/miniaudio/dr_wav.h:553:5) compressed
       296 |   struct drwav::(anonymous at /pyminiaudio/miniaudio/dr_wav.h:559:5) msadpcm
       348 |   struct drwav::(anonymous at /pyminiaudio/miniaudio/dr_wav.h:570:5) ima
         0 |   drwav_container container
         4 |   drwav_uint32 format
         8 |   drwav_uint32 channels
        12 |   drwav_uint32 sampleRate
        16 |   drwav_uint32 bitsPerSample
         0 |   off_t l_start
         8 |   off_t l_len
        16 |   pid_t l_pid
        20 |   short l_type
        22 |   short l_whence
         0 |   float f32
         0 |   ma_int32 s32
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_biquad_coefficient b0
        12 |   ma_biquad_coefficient b1
        16 |   ma_biquad_coefficient b2
        20 |   ma_biquad_coefficient a1
        24 |   ma_biquad_coefficient a2
        28 |   ma_biquad_coefficient [32] r1
       156 |   ma_biquad_coefficient [32] r2
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_biquad_coefficient a
        12 |   ma_biquad_coefficient [32] r1
         0 |   ma_biquad bq
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_biquad_coefficient a
        12 |   ma_biquad_coefficient [32] r1
         0 |   ma_biquad bq
         0 |   ma_biquad bq
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 sampleRateIn
        12 |   ma_uint32 sampleRateOut
        16 |   ma_uint32 lpfOrder
        24 |   double lpfNyquistFactor
         0 |   float [32] f32
         0 |   ma_int16 [32] s16
         0 |   float [32] f32
         0 |   ma_int16 [32] s16
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 lpf1Count
        12 |   ma_uint32 lpf2Count
        16 |   ma_lpf1 [1] lpf1
       156 |   ma_lpf2 [4] lpf2
         0 |   ma_linear_resampler_config config
        32 |   ma_uint32 inAdvanceInt
        36 |   ma_uint32 inAdvanceFrac
        40 |   ma_uint32 inTimeInt
        44 |   ma_uint32 inTimeFrac
        48 |   union ma_linear_resampler::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2273:5) x0
       176 |   union ma_linear_resampler::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2278:5) x1
       304 |   ma_lpf lpf
         0 |   ma_uint32 lpfOrder
         8 |   double lpfNyquistFactor
         0 |   int quality
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 sampleRateIn
        12 |   ma_uint32 sampleRateOut
        16 |   ma_resample_algorithm algorithm
        24 |   struct ma_resampler_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2309:5) linear
        40 |   struct ma_resampler_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2314:5) speex
         0 |   ma_uint32 lpfOrder
         8 |   double lpfNyquistFactor
         0 |   int quality
         0 |   ma_resample_algorithm algorithm
         4 |   ma_bool32 allowDynamicSampleRate
         8 |   struct ma_data_converter_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2476:9) linear
        24 |   struct ma_data_converter_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2481:9) speex
         0 |   ma_format formatIn
         4 |   ma_format formatOut
         8 |   ma_uint32 channelsIn
        12 |   ma_uint32 channelsOut
        16 |   ma_uint32 sampleRateIn
        20 |   ma_uint32 sampleRateOut
        24 |   ma_channel [32] channelMapIn
        56 |   ma_channel [32] channelMapOut
        88 |   ma_dither_mode ditherMode
        92 |   ma_channel_mix_mode channelMixMode
        96 |   float [32][32] channelWeights
      4192 |   struct ma_data_converter_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2472:5) resampling
         0 |   void * pUserData
         8 |   void *(*)(size_t, void *) onMalloc
        16 |   void *(*)(void *, size_t, void *) onRealloc
        24 |   void (*)(void *, void *) onFree
         0 |   void * pBuffer
         8 |   ma_uint32 subbufferSizeInBytes
        12 |   ma_uint32 subbufferCount
        16 |   ma_uint32 subbufferStrideInBytes
        20 |   volatile ma_uint32 encodedReadOffset
        24 |   volatile ma_uint32 encodedWriteOffset
    28:0-0 |   ma_bool32 ownsBuffer
    28:1-1 |   ma_bool32 clearOnWriteAcquire
        32 |   ma_allocation_callbacks allocationCallbacks
         0 |   pthread_t thread
         0 |   long __sig
         8 |   char [56] __opaque
         0 |   struct _opaque_pthread_mutex_t mutex
         0 |   long __sig
         8 |   char [40] __opaque
         0 |   struct _opaque_pthread_mutex_t mutex
        64 |   struct _opaque_pthread_cond_t condition
       112 |   ma_uint32 value
         0 |   sem_t semaphore
         0 |   wchar_t [64] wasapi
         0 |   ma_uint8 [16] dsound
         0 |   ma_uint32 winmm
         0 |   char [256] alsa
         0 |   char [256] pulse
         0 |   int jack
         0 |   char [256] coreaudio
         0 |   char [256] sndio
         0 |   char [256] audio4
         0 |   char [64] oss
         0 |   ma_int32 aaudio
         0 |   ma_uint32 opensl
         0 |   char [32] webaudio
         0 |   int nullbackend
         0 |   ma_handle hCoreFoundation
         8 |   ma_proc CFStringGetCString
        16 |   ma_proc CFRelease
        24 |   ma_handle hCoreAudio
        32 |   ma_proc AudioObjectGetPropertyData
        40 |   ma_proc AudioObjectGetPropertyDataSize
        48 |   ma_proc AudioObjectSetPropertyData
        56 |   ma_proc AudioObjectAddPropertyListener
        64 |   ma_proc AudioObjectRemovePropertyListener
        72 |   ma_handle hAudioUnit
        80 |   ma_proc AudioComponentFindNext
        88 |   ma_proc AudioComponentInstanceDispose
        96 |   ma_proc AudioComponentInstanceNew
       104 |   ma_proc AudioOutputUnitStart
       112 |   ma_proc AudioOutputUnitStop
       120 |   ma_proc AudioUnitAddPropertyListener
       128 |   ma_proc AudioUnitGetPropertyInfo
       136 |   ma_proc AudioUnitGetProperty
       144 |   ma_proc AudioUnitSetProperty
       152 |   ma_proc AudioUnitInitialize
       160 |   ma_proc AudioUnitRender
       168 |   ma_ptr component
         0 |   ma_handle pthreadSO
         8 |   ma_proc pthread_create
        16 |   ma_proc pthread_join
        24 |   ma_proc pthread_mutex_init
        32 |   ma_proc pthread_mutex_destroy
        40 |   ma_proc pthread_mutex_lock
        48 |   ma_proc pthread_mutex_unlock
        56 |   ma_proc pthread_cond_init
        64 |   ma_proc pthread_cond_destroy
        72 |   ma_proc pthread_cond_wait
        80 |   ma_proc pthread_cond_signal
        88 |   ma_proc pthread_attr_init
        96 |   ma_proc pthread_attr_destroy
       104 |   ma_proc pthread_attr_setschedpolicy
       112 |   ma_proc pthread_attr_getschedparam
       120 |   ma_proc pthread_attr_setschedparam
         0 |   struct ma_thread::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2899:9) posix
         0 |   int _unused
         0 |   ma_context * pContext
         8 |   union ma_thread::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2890:5) 
         0 |   struct ma_event::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2943:9) posix
         0 |   int _unused
         0 |   ma_context * pContext
         8 |   union ma_event::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2934:5) 
         0 |   ma_rb rb
        64 |   ma_format format
        68 |   ma_uint32 channels
         0 |   ma_uint32 deviceObjectIDPlayback
         4 |   ma_uint32 deviceObjectIDCapture
         8 |   ma_ptr audioUnitPlayback
        16 |   ma_ptr audioUnitCapture
        24 |   ma_ptr pAudioBufferList
        32 |   ma_event stopEvent
       160 |   ma_uint32 originalPeriodSizeInFrames
       164 |   ma_uint32 originalPeriodSizeInMilliseconds
       168 |   ma_uint32 originalPeriods
       172 |   ma_bool32 isDefaultPlaybackDevice
       176 |   ma_bool32 isDefaultCaptureDevice
       180 |   ma_bool32 isSwitchingPlaybackDevice
       184 |   ma_bool32 isSwitchingCaptureDevice
       192 |   ma_pcm_rb duplexRB
       264 |   void * pRouteChangeHandler
         0 |   ma_resource_format resourceFormat
         4 |   ma_format format
         8 |   ma_uint32 channels
        12 |   ma_uint32 sampleRate
        16 |   ma_allocation_callbacks allocationCallbacks
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 sampleRate
        12 |   ma_waveform_type type
        16 |   double amplitude
        24 |   double frequency
         0 |   double [32][16] bin
      4096 |   double [32] accumulation
      4352 |   ma_uint32 [32] counter
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_noise_type type
        12 |   ma_int32 seed
        16 |   double amplitude
        24 |   ma_bool32 duplicateChannels
         0 |   void * pSpeexResamplerState
         0 |   ma_linear_resampler linear
         0 |   struct ma_resampler::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2328:9) speex
         0 |   ma_resampler_config config
        48 |   union ma_resampler::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2325:5) state
         0 |   struct ma_mutex::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2921:9) posix
         0 |   int _unused
         0 |   ma_context * pContext
         8 |   union ma_mutex::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2912:5) 
         0 |   int _unused
         0 |   struct ma_context::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3485:9) coreaudio
         0 |   struct ma_context::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3594:9) null_backend
         0 |   struct ma_context::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3625:9) posix
         0 |   int _unused
         0 |   ma_backend backend
         8 |   ma_log_proc logCallback
        16 |   ma_thread_priority threadPriority
        24 |   void * pUserData
        32 |   ma_allocation_callbacks allocationCallbacks
        64 |   ma_mutex deviceEnumLock
       136 |   ma_mutex deviceInfoLock
       208 |   ma_uint32 deviceInfoCapacity
       212 |   ma_uint32 playbackDeviceInfoCount
       216 |   ma_uint32 captureDeviceInfoCount
       224 |   ma_device_info * pDeviceInfos
   232:0-0 |   ma_bool32 isBackendAsynchronous
       240 |   ma_result (*)(ma_context *) onUninit
       248 |   ma_bool32 (*)(ma_context *, const ma_device_id *, const ma_device_id *) onDeviceIDEqual
       256 |   ma_result (*)(ma_context *, ma_enum_devices_callback_proc, void *) onEnumDevices
       264 |   ma_result (*)(ma_context *, ma_device_type, const ma_device_id *, ma_share_mode, ma_device_info *) onGetDeviceInfo
       272 |   ma_result (*)(ma_context *, const ma_device_config *, ma_device *) onDeviceInit
       280 |   void (*)(ma_device *) onDeviceUninit
       288 |   ma_result (*)(ma_device *) onDeviceStart
       296 |   ma_result (*)(ma_device *) onDeviceStop
       304 |   ma_result (*)(ma_device *) onDeviceMainLoop
       312 |   union ma_context::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3300:5) 
       488 |   union ma_context::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3601:5) 
         0 |   ma_uint32 lpfOrder
         0 |   int quality
         0 |   ma_resample_algorithm algorithm
         4 |   struct ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3674:9) linear
         8 |   struct ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3678:9) speex
         0 |   float [32][32] f32
         0 |   ma_int32 [32][32] s16
         0 |   ma_format format
         4 |   ma_uint32 channelsIn
         8 |   ma_uint32 channelsOut
        12 |   ma_channel [32] channelMapIn
        44 |   ma_channel [32] channelMapOut
        76 |   ma_channel_mix_mode mixingMode
        80 |   union ma_channel_converter::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2437:5) weights
  4176:0-0 |   ma_bool32 isPassthrough
  4176:1-1 |   ma_bool32 isSimpleShuffle
  4176:2-2 |   ma_bool32 isSimpleMonoExpansion
  4176:3-3 |   ma_bool32 isStereoToMono
      4177 |   ma_uint8 [32] shuffleTable
         0 |   ma_data_converter_config config
      4224 |   ma_channel_converter channelConverter
      8440 |   ma_resampler resampler
 10088:0-0 |   ma_bool32 hasPreFormatConversion
 10088:1-1 |   ma_bool32 hasPostFormatConversion
 10088:2-2 |   ma_bool32 hasChannelConverter
 10088:3-3 |   ma_bool32 hasResampler
 10088:4-4 |   ma_bool32 isPassthrough
         0 |   char [256] name
       256 |   ma_share_mode shareMode
   260:0-0 |   ma_bool32 usingDefaultFormat
   260:1-1 |   ma_bool32 usingDefaultChannels
   260:2-2 |   ma_bool32 usingDefaultChannelMap
       264 |   ma_format format
       268 |   ma_uint32 channels
       272 |   ma_channel [32] channelMap
       304 |   ma_format internalFormat
       308 |   ma_uint32 internalChannels
       312 |   ma_uint32 internalSampleRate
       316 |   ma_channel [32] internalChannelMap
       348 |   ma_uint32 internalPeriodSizeInFrames
       352 |   ma_uint32 internalPeriods
       360 |   ma_data_converter converter
         0 |   char [256] name
       256 |   ma_share_mode shareMode
   260:0-0 |   ma_bool32 usingDefaultFormat
   260:1-1 |   ma_bool32 usingDefaultChannels
   260:2-2 |   ma_bool32 usingDefaultChannelMap
       264 |   ma_format format
       268 |   ma_uint32 channels
       272 |   ma_channel [32] channelMap
       304 |   ma_format internalFormat
       308 |   ma_uint32 internalChannels
       312 |   ma_uint32 internalSampleRate
       316 |   ma_channel [32] internalChannelMap
       348 |   ma_uint32 internalPeriodSizeInFrames
       352 |   ma_uint32 internalPeriods
       360 |   ma_data_converter converter
         0 |   ma_int64 counter
         0 |   double counterD
         0 |   ma_thread deviceThread
        16 |   ma_event operationEvent
       144 |   ma_event operationCompletionEvent
       272 |   ma_uint32 operation
       276 |   ma_result operationResult
       280 |   ma_timer timer
       288 |   double priorRunTime
       296 |   ma_uint32 currentPeriodFramesRemainingPlayback
       300 |   ma_uint32 currentPeriodFramesRemainingCapture
       304 |   ma_uint64 lastProcessedFramePlayback
       312 |   ma_uint32 lastProcessedFrameCapture
       316 |   ma_bool32 isStarted
         0 |   struct ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3819:9) coreaudio
         0 |   struct ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3898:9) null_device
         0 |   ma_context * pContext
         8 |   ma_device_type type
        12 |   ma_uint32 sampleRate
        16 |   volatile ma_uint32 state
        24 |   ma_device_callback_proc onData
        32 |   ma_stop_proc onStop
        40 |   void * pUserData
        48 |   ma_mutex lock
       120 |   ma_event wakeupEvent
       248 |   ma_event startEvent
       376 |   ma_event stopEvent
       504 |   ma_thread thread
       520 |   ma_result workResult
   524:0-0 |   ma_bool32 usingDefaultSampleRate
   524:1-1 |   ma_bool32 usingDefaultBufferSize
   524:2-2 |   ma_bool32 usingDefaultPeriods
   524:3-3 |   ma_bool32 isOwnerOfContext
   524:4-4 |   ma_bool32 noPreZeroedOutputBuffer
   524:5-5 |   ma_bool32 noClip
       528 |   volatile float masterVolumeFactor
       532 |   struct ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3671:5) resampling
       544 |   struct ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3683:5) playback
     11000 |   struct ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3701:5) capture
     21456 |   union ma_device::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3720:5) 
         0 |   long __sig
         8 |   struct __darwin_pthread_handler_rec * __cleanup_stack
        16 |   char [8176] __opaque
         0 |   void (*)(void *) __routine
         8 |   void * __arg
        16 |   struct __darwin_pthread_handler_rec * __next
         0 |   ma_bool32 isDefault
         0 |   ma_device_id id
       256 |   char [256] name
       512 |   ma_uint32 formatCount
       516 |   ma_format [6] formats
       540 |   ma_uint32 minChannels
       544 |   ma_uint32 maxChannels
       548 |   ma_uint32 minSampleRate
       552 |   ma_uint32 maxSampleRate
       556 |   struct ma_device_info::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3156:5) _private
         0 |   ma_uint32 lpfOrder
         0 |   int quality
         0 |   ma_resample_algorithm algorithm
         4 |   struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3178:9) linear
         8 |   struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3182:9) speex
         0 |   ma_device_id * pDeviceID
         8 |   ma_format format
        12 |   ma_uint32 channels
        16 |   ma_channel [32] channelMap
        48 |   ma_share_mode shareMode
         0 |   ma_device_id * pDeviceID
         8 |   ma_format format
        12 |   ma_uint32 channels
        16 |   ma_channel [32] channelMap
        48 |   ma_share_mode shareMode
         0 |   ma_bool32 noAutoConvertSRC
         4 |   ma_bool32 noDefaultQualitySRC
         8 |   ma_bool32 noAutoStreamRouting
        12 |   ma_bool32 noHardwareOffloading
         0 |   ma_bool32 noMMap
         4 |   ma_bool32 noAutoFormat
         8 |   ma_bool32 noAutoChannels
        12 |   ma_bool32 noAutoResample
         0 |   const char * pStreamNamePlayback
         8 |   const char * pStreamNameCapture
         0 |   ma_device_type deviceType
         4 |   ma_uint32 sampleRate
         8 |   ma_uint32 periodSizeInFrames
        12 |   ma_uint32 periodSizeInMilliseconds
        16 |   ma_uint32 periods
        20 |   ma_performance_profile performanceProfile
        24 |   ma_bool32 noPreZeroedOutputBuffer
        28 |   ma_bool32 noClip
        32 |   ma_device_callback_proc dataCallback
        40 |   ma_stop_proc stopCallback
        48 |   void * pUserData
        56 |   struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3175:5) resampling
        72 |   struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3187:5) playback
       128 |   struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3195:5) capture
       184 |   struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3204:5) wasapi
       200 |   struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3211:5) alsa
       216 |   struct ma_device_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3218:5) pulse
         0 |   unsigned int gp_offset
         4 |   unsigned int fp_offset
         8 |   void * overflow_arg_area
        16 |   void * reg_save_area
         0 |   int sched_priority
         4 |   char [4] __opaque
         0 |   struct ma_semaphore::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2967:9) posix
         0 |   int _unused
         0 |   ma_context * pContext
         8 |   union ma_semaphore::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:2958:5) 
         0 |   ma_device_type deviceType
         8 |   const ma_device_id * pDeviceID
        16 |   char * pName
        24 |   size_t nameBufferSize
        32 |   ma_bool32 foundDevice
         0 |   UInt32 lo
         4 |   SInt32 hi
         0 |   UInt8 nonRelRev
         1 |   UInt8 stage
         2 |   UInt8 minorAndBugRev
         3 |   UInt8 majorRev
         0 |   CFIndex location
         8 |   CFIndex length
         0 |   UInt32 mNumberChannels
         4 |   UInt32 mDataByteSize
         8 |   void * _Nullable mData
         0 |   AudioChannelLabel mChannelLabel
         4 |   AudioChannelFlags mChannelFlags
         8 |   Float32 [3] mCoordinates
         0 |   Float64 mSampleRate
         8 |   AudioFormatID mFormatID
        12 |   AudioFormatFlags mFormatFlags
        16 |   UInt32 mBytesPerPacket
        20 |   UInt32 mFramesPerPacket
        24 |   UInt32 mBytesPerFrame
        28 |   UInt32 mChannelsPerFrame
        32 |   UInt32 mBitsPerChannel
        36 |   UInt32 mReserved
         0 |   uint32_t v
         0 |   Float32 v
         0 |   CFSwappedFloat32 sv
         0 |   Float32 v
         0 |   CFSwappedFloat32 sv
         0 |   uint64_t v
         0 |   Float64 v
         0 |   CFSwappedFloat64 sv
         0 |   Float64 v
         0 |   CFSwappedFloat64 sv
         0 |   float v
         0 |   CFSwappedFloat32 sv
         0 |   float v
         0 |   CFSwappedFloat32 sv
         0 |   double v
         0 |   CFSwappedFloat64 sv
         0 |   double v
         0 |   CFSwappedFloat64 sv
         0 |   mach_port_rights_t mps_pset
         4 |   mach_port_seqno_t mps_seqno
         8 |   mach_port_mscount_t mps_mscount
        12 |   mach_port_msgcount_t mps_qlimit
        16 |   mach_port_msgcount_t mps_msgcount
        20 |   mach_port_rights_t mps_sorights
        24 |   boolean_t mps_srights
        28 |   boolean_t mps_pdrequest
        32 |   boolean_t mps_nsrequest
        36 |   natural_t mps_flags
         0 |   mach_port_t name
         4 |   mach_msg_size_t pad1
    8:0-15 |   unsigned int pad2
    10:0-7 |   mach_msg_type_name_t disposition
    11:0-7 |   mach_msg_descriptor_type_t type
         0 |   mach_msg_bits_t msgh_bits
         4 |   mach_msg_size_t msgh_size
         8 |   mach_port_t msgh_remote_port
        12 |   mach_port_t msgh_local_port
        16 |   mach_port_name_t msgh_voucher_port
        20 |   mach_msg_id_t msgh_id
         0 |   mach_msg_header_t header
         0 |   unsigned char [16] g_guid
         0 |   guid_t ace_applicable
        16 |   u_int32_t ace_flags
        20 |   kauth_ace_rights_t ace_rights
         0 |   CFURLRef systemID
         8 |   CFStringRef publicID
         0 |   SInt32 startBufferOffset
         4 |   UInt32 durationInFrames
         8 |   AudioUnitParameterValue startValue
        12 |   AudioUnitParameterValue endValue
         0 |   Float32 inDistance
         4 |   Float32 outGain
         0 |   OSType mType
         4 |   OSType mSubType
         8 |   OSType mManufacturer
         0 |   UInt32 format
         4 |   struct AudioClassDescription plugin
         0 |   UInt32 isStockSetting
         4 |   UInt32 settingID
         8 |   UInt32 dataLen
        12 |   UInt8 [1] data
         0 |   SInt16 mSubframes
         2 |   SInt16 mSubframeDivisor
         4 |   UInt32 mCounter
         8 |   SMPTETimeType mType
        12 |   SMPTETimeFlags mFlags
        16 |   SInt16 mHours
        18 |   SInt16 mMinutes
        20 |   SInt16 mSeconds
        22 |   SInt16 mFrames
         0 |   Float64 mSampleTime
         8 |   UInt64 mHostTime
        16 |   Float64 mRateScalar
        24 |   UInt64 mWordClockTime
        32 |   struct SMPTETime mSMPTETime
        56 |   AudioTimeStampFlags mFlags
        60 |   UInt32 mReserved
         0 |   AudioUnitParameterID mID
         4 |   AudioUnitParameterValue mValue
         0 |   AUNode sourceNode
         4 |   UInt32 sourceOutputNumber
         8 |   AUNode destNode
        12 |   UInt32 destInputNumber
         0 |   SInt8 mHours
         1 |   UInt8 mMinutes
         2 |   UInt8 mSeconds
         3 |   UInt8 mFrames
         4 |   UInt32 mSubFrameSampleOffset
         0 |   Float64 mFramePosition
         8 |   CFStringRef _Nullable mName
        16 |   SInt32 mMarkerID
        20 |   struct AudioFile_SMPTE_Time mSMPTETime
        28 |   UInt32 mType
        32 |   UInt16 mReserved
        34 |   UInt16 mChannel
         0 |   UInt32 mSMPTE_TimeType
         4 |   UInt32 mNumberMarkers
         8 |   AudioFileMarker [1] mMarkers
         0 |   UInt32 mRegionID
         8 |   CFStringRef _Nonnull mName
        16 |   AudioFileRegionFlags mFlags
        20 |   UInt32 mNumberMarkers
        24 |   AudioFileMarker [1] mMarkers
         0 |   UInt32 mChunkType
         4 |   SInt64 mChunkSize
         0 |   Float64 mSampleRate
         8 |   UInt32 mFormatID
        12 |   CAFFormatFlags mFormatFlags
        16 |   UInt32 mBytesPerPacket
        20 |   UInt32 mFramesPerPacket
        24 |   UInt32 mChannelsPerFrame
        28 |   UInt32 mBitsPerChannel
         0 |   SInt8 mHours
         1 |   SInt8 mMinutes
         2 |   SInt8 mSeconds
         3 |   SInt8 mFrames
         4 |   UInt32 mSubFrameSampleOffset
         0 |   UInt32 mType
         4 |   Float64 mFramePosition
        12 |   UInt32 mMarkerID
        16 |   struct CAF_SMPTE_Time mSMPTETime
        24 |   UInt32 mChannel
         0 |   UInt32 mRegionID
         4 |   CAFRegionFlags mFlags
         8 |   UInt32 mNumberMarkers
        12 |   CAFMarker [1] mMarkers
         0 |   UInt32 mStringID
         4 |   SInt64 mStringStartByteOffset
         0 |   Float32 mValue
         4 |   UInt64 mFrameNumber
         0 |   SInt16 mMinValue
         2 |   SInt16 mMaxValue
         0 |   MIDITimeStamp timeStamp
         8 |   UInt16 length
        10 |   Byte [256] data
         0 |   AudioUnit _Nonnull mAudioUnit
         8 |   AudioUnitParameterID mParameterID
        12 |   AudioUnitScope mScope
        16 |   AudioUnitElement mElement
         0 |   AudioObjectPropertySelector mSelector
         4 |   AudioObjectPropertyScope mScope
         8 |   AudioObjectPropertyElement mElement
         0 |   Float64 mMinimum
         8 |   Float64 mMaximum
         0 |   struct AudioStreamBasicDescription mFormat
        40 |   struct AudioValueRange mSampleRateRange
         0 |   UInt32 mNumberBuffers
         8 |   AudioBuffer [1] mBuffers
         0 |   AURenderCallback _Nullable inputProc
         8 |   void * _Nullable inputProcRefCon
         0 |   ma_format formatIn
         4 |   ma_uint32 channelsIn
         8 |   ma_uint32 sampleRateIn
        12 |   ma_channel [32] channelMapIn
        44 |   ma_uint32 periodSizeInFramesIn
        48 |   ma_uint32 periodSizeInMillisecondsIn
        52 |   ma_uint32 periodsIn
        56 |   ma_bool32 usingDefaultFormat
        60 |   ma_bool32 usingDefaultChannels
        64 |   ma_bool32 usingDefaultSampleRate
        68 |   ma_bool32 usingDefaultChannelMap
        72 |   ma_share_mode shareMode
        76 |   ma_bool32 registerStopEvent
        80 |   AudioObjectID deviceObjectID
        88 |   AudioComponent component
        96 |   AudioUnit audioUnit
       104 |   AudioBufferList * pAudioBufferList
       112 |   ma_format formatOut
       116 |   ma_uint32 channelsOut
       120 |   ma_uint32 sampleRateOut
       124 |   ma_channel [32] channelMapOut
       156 |   ma_uint32 periodSizeInFramesOut
       160 |   ma_uint32 periodsOut
       164 |   char [256] deviceName
         0 |   OSType componentType
         4 |   OSType componentSubType
         8 |   OSType componentManufacturer
        12 |   UInt32 componentFlags
        16 |   UInt32 componentFlagsMask
         0 |   ma_bool32 useVerboseDeviceEnumeration
         0 |   const char * pApplicationName
         8 |   const char * pServerName
        16 |   ma_bool32 tryAutoSpawn
         0 |   ma_ios_session_category sessionCategory
         4 |   ma_uint32 sessionCategoryOptions
         0 |   const char * pClientName
         8 |   ma_bool32 tryStartServer
         0 |   ma_log_proc logCallback
         8 |   ma_thread_priority threadPriority
        16 |   void * pUserData
        24 |   ma_allocation_callbacks allocationCallbacks
        56 |   struct ma_context_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3231:5) alsa
        64 |   struct ma_context_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3235:5) pulse
        88 |   struct ma_context_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3241:5) coreaudio
        96 |   struct ma_context_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:3246:5) jack
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   double b0
        16 |   double b1
        24 |   double b2
        32 |   double a0
        40 |   double a1
        48 |   double a2
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 sampleRate
        16 |   double cutoffFrequency
        24 |   double q
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 sampleRate
        16 |   double cutoffFrequency
        24 |   ma_uint32 order
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 sampleRate
        16 |   double cutoffFrequency
        24 |   double q
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 sampleRate
        16 |   double cutoffFrequency
        24 |   ma_uint32 order
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 hpf1Count
        12 |   ma_uint32 hpf2Count
        16 |   ma_hpf1 [1] hpf1
       156 |   ma_hpf2 [4] hpf2
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 sampleRate
        16 |   double cutoffFrequency
        24 |   double q
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 sampleRate
        16 |   double cutoffFrequency
        24 |   ma_uint32 order
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 bpf2Count
        12 |   ma_bpf2 [4] bpf2
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 sampleRate
        16 |   double q
        24 |   double frequency
         0 |   ma_biquad bq
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 sampleRate
        16 |   double gainDB
        24 |   double q
        32 |   double frequency
         0 |   ma_biquad bq
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 sampleRate
        16 |   double gainDB
        24 |   double shelfSlope
        32 |   double frequency
         0 |   ma_biquad bq
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 sampleRate
        16 |   double gainDB
        24 |   double shelfSlope
        32 |   double frequency
         0 |   ma_biquad bq
         0 |   ma_format format
         4 |   ma_uint32 channelsIn
         8 |   ma_uint32 channelsOut
        12 |   ma_channel [32] channelMapIn
        44 |   ma_channel [32] channelMapOut
        76 |   ma_channel_mix_mode mixingMode
        80 |   float [32][32] weights
         0 |   ma_uint32 lpfOrder
         0 |   int quality
         0 |   ma_resample_algorithm algorithm
         4 |   struct ma_decoder_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:5267:9) linear
         8 |   struct ma_decoder_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:5271:9) speex
         0 |   ma_format format
         4 |   ma_uint32 channels
         8 |   ma_uint32 sampleRate
        12 |   ma_channel [32] channelMap
        44 |   ma_channel_mix_mode channelMixMode
        48 |   ma_dither_mode ditherMode
        52 |   struct ma_decoder_config::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:5264:5) resampling
        64 |   ma_allocation_callbacks allocationCallbacks
         0 |   unsigned int sample_rate
         4 |   int channels
         8 |   unsigned int setup_memory_required
        12 |   unsigned int setup_temp_memory_required
        16 |   unsigned int temp_memory_required
        20 |   int max_frame_size
         0 |   stb_vorbis * pInternalVorbis
         8 |   ma_uint8 * pData
        16 |   size_t dataSize
        24 |   size_t dataCapacity
        32 |   ma_uint32 framesConsumed
        36 |   ma_uint32 framesRemaining
        40 |   float ** ppPacketData
         0 |   const ma_uint8 * pData
         8 |   size_t dataSize
        16 |   size_t currentReadPos
         0 |   ma_decoder_read_proc onRead
         8 |   ma_decoder_seek_proc onSeek
        16 |   void * pUserData
        24 |   ma_uint64 readPointer
        32 |   ma_format internalFormat
        36 |   ma_uint32 internalChannels
        40 |   ma_uint32 internalSampleRate
        44 |   ma_channel [32] internalChannelMap
        76 |   ma_format outputFormat
        80 |   ma_uint32 outputChannels
        84 |   ma_uint32 outputSampleRate
        88 |   ma_channel [32] outputChannelMap
       120 |   ma_data_converter converter
     10216 |   ma_allocation_callbacks allocationCallbacks
     10248 |   ma_decoder_read_pcm_frames_proc onReadPCMFrames
     10256 |   ma_decoder_seek_to_pcm_frame_proc onSeekToPCMFrame
     10264 |   ma_decoder_uninit_proc onUninit
     10272 |   ma_decoder_get_length_in_pcm_frames_proc onGetLengthInPCMFrames
     10280 |   void * pInternalDecoder
     10288 |   struct ma_decoder::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:5300:5) memory
         0 |   ma_encoder_config config
        48 |   ma_encoder_write_proc onWrite
        56 |   ma_encoder_seek_proc onSeek
        64 |   ma_encoder_init_proc onInit
        72 |   ma_encoder_uninit_proc onUninit
        80 |   ma_encoder_write_pcm_frames_proc onWritePCMFrames
        88 |   void * pUserData
        96 |   void * pInternalEncoder
       104 |   void * pFile
         0 |   ma_waveform_config config
        32 |   double advance
        40 |   double time
         0 |   ma_int32 state
         0 |   double [32] accumulation
         0 |   struct ma_noise::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:5494:9) pink
         0 |   struct ma_noise::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:5500:9) brownian
         0 |   ma_noise_config config
        32 |   ma_lcg lcg
        40 |   union ma_noise::(anonymous at /pyminiaudio/miniaudio/miniaudio.h:5492:5) state
         0 |   uint8 order
         2 |   uint16 rate
         4 |   uint16 bark_map_size
         6 |   uint8 amplitude_bits
         7 |   uint8 amplitude_offset
         8 |   uint8 number_of_books
         9 |   uint8 [16] book_list
         0 |   uint8 blockflag
         1 |   uint8 mapping
         2 |   uint16 windowtype
         4 |   uint16 transformtype
         0 |   uint32 goal_crc
         4 |   int bytes_left
         8 |   uint32 crc_so_far
        12 |   int bytes_done
        16 |   uint32 sample_loc
         0 |   int dimensions
         4 |   int entries
         8 |   uint8 * codeword_lengths
        16 |   float minimum_value
        20 |   float delta_value
        24 |   uint8 value_bits
        25 |   uint8 lookup_type
        26 |   uint8 sequence_p
        27 |   uint8 sparse
        28 |   uint32 lookup_values
        32 |   codetype * multiplicands
        40 |   uint32 * codewords
        48 |   int16 [1024] fast_huffman
      2096 |   uint32 * sorted_codewords
      2104 |   int * sorted_values
      2112 |   int sorted_entries
         0 |   uint8 partitions
         1 |   uint8 [32] partition_class_list
        33 |   uint8 [16] class_dimensions
        49 |   uint8 [16] class_subclasses
        65 |   uint8 [16] class_masterbooks
        82 |   int16 [16][8] subclass_books
       338 |   uint16 [250] Xlist
       838 |   uint8 [250] sorted_order
      1088 |   uint8 [250][2] neighbors
      1588 |   uint8 floor1_multiplier
      1589 |   uint8 rangebits
      1592 |   int values
         0 |   Floor0 floor0
         0 |   Floor1 floor1
         0 |   uint16 x
         2 |   uint16 id
         0 |   uint32 begin
         4 |   uint32 end
         8 |   uint32 part_size
        12 |   uint8 classifications
        13 |   uint8 classbook
        16 |   uint8 ** classdata
        24 |   int16 (*)[8] residue_books
         0 |   uint16 coupling_steps
         8 |   MappingChannel * chan
        16 |   uint8 submaps
        17 |   uint8 [15] submap_floor
        32 |   uint8 [15] submap_residue
         0 |   uint8 magnitude
         1 |   uint8 angle
         2 |   uint8 mux
         0 |   uint32 page_start
         4 |   uint32 page_end
         8 |   uint32 last_decoded_sample
         0 |   char * alloc_buffer
         8 |   int alloc_buffer_length_in_bytes
         0 |   unsigned int sample_rate
         4 |   int channels
         8 |   unsigned int setup_memory_required
        12 |   unsigned int temp_memory_required
        16 |   unsigned int setup_temp_memory_required
        24 |   char * vendor
        32 |   int comment_list_length
        40 |   char ** comment_list
        48 |   FILE * f
        56 |   uint32 f_start
        60 |   int close_on_free
        64 |   uint8 * stream
        72 |   uint8 * stream_start
        80 |   uint8 * stream_end
        88 |   uint32 stream_len
        92 |   uint8 push_mode
        96 |   uint32 first_audio_page_offset
       100 |   ProbedPage p_first
       112 |   ProbedPage p_last
       128 |   stb_vorbis_alloc alloc
       144 |   int setup_offset
       148 |   int temp_offset
       152 |   int eof
       156 |   enum STBVorbisError error
       160 |   int [2] blocksize
       168 |   int blocksize_0
       172 |   int blocksize_1
       176 |   int codebook_count
       184 |   Codebook * codebooks
       192 |   int floor_count
       196 |   uint16 [64] floor_types
       328 |   Floor * floor_config
       336 |   int residue_count
       340 |   uint16 [64] residue_types
       472 |   Residue * residue_config
       480 |   int mapping_count
       488 |   Mapping * mapping
       496 |   int mode_count
       500 |   Mode [64] mode_config
       884 |   uint32 total_samples
       888 |   float *[16] channel_buffers
      1016 |   float *[16] outputs
      1144 |   float *[16] previous_window
      1272 |   int previous_length
      1280 |   int16 *[16] finalY
      1408 |   uint32 current_loc
      1412 |   int current_loc_valid
      1416 |   float *[2] A
      1432 |   float *[2] B
      1448 |   float *[2] C
      1464 |   float *[2] window
      1480 |   uint16 *[2] bit_reverse
      1496 |   uint32 serial
      1500 |   int last_page
      1504 |   int segment_count
      1508 |   uint8 [255] segments
      1763 |   uint8 page_flag
      1764 |   uint8 bytes_in_seg
      1765 |   uint8 first_decode
      1768 |   int next_seg
      1772 |   int last_seg
      1776 |   int last_seg_which
      1780 |   uint32 acc
      1784 |   int valid_bits
      1788 |   int packet_bytes
      1792 |   int end_seg_with_known_loc
      1796 |   uint32 known_loc_for_packet
      1800 |   int discard_samples_deferred
      1804 |   uint32 samples_output
      1808 |   int page_crc_tests
      1812 |   CRCscan [4] scan
      1892 |   int channel_buffer_start
      1896 |   int channel_buffer_end
         0 |   char * vendor
         8 |   int comment_list_length
        16 |   char ** comment_list
         0 |   float f
         0 |   int i
         0 |   drmp3_uint8 tab_offset
         1 |   drmp3_uint8 code_tab_width
         2 |   drmp3_uint8 band_count
         0 |   long __sig
         8 |   char [8] __opaque
         0 |   long __sig
         8 |   char [8] __opaque
         0 |   long __sig
         8 |   char [56] __opaque
         0 |   AudioChannelLayoutTag mChannelLayoutTag
         4 |   AudioChannelBitmap mChannelBitmap
         8 |   UInt32 mNumberChannelDescriptions
        12 |   AudioChannelDescription [1] mChannelDescriptions""";

void main() {
  test("first degree field", () {
    final fieldPattern = AstRecordLayoutPatterns.fieldPattern;

    final f = fields.split('\n');
    for (int i=0; i<f.length; i++) {
      var trim = f[i].trim();

      if (!fieldPattern.accept(trim)) {
        fail('Failed at line $i, with:\n"${f[i]}"');
      }
    }
  });
}