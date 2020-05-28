import 'package:test/test.dart';
import 'package:dart_ast_json/src/layout_parser.dart';
import 'package:petitparser/petitparser.dart';

final recordDecls =
"""
Record: RecordDecl 0x7fb2090ce2e8 </pyminiaudio/miniaudio/dr_flac.h:386:9, line:397:1> line:386:9 struct definition
Record: RecordDecl 0x7fb2090d5b40 </pyminiaudio/miniaudio/dr_flac.h:418:9, line:421:9> line:418:9 struct definition
Record: RecordDecl 0x7fb2090d5cf8 </pyminiaudio/miniaudio/dr_flac.h:423:9, line:428:9> line:423:9 struct definition
Record: RecordDecl 0x7fb2090cdfd8 </pyminiaudio/miniaudio/dr_flac.h:378:9, line:383:1> line:378:9 struct definition
Record: RecordDecl 0x7fb2090d5f78 </pyminiaudio/miniaudio/dr_flac.h:430:9, line:434:9> line:430:9 struct definition
Record: RecordDecl 0x7fb2090d6208 </pyminiaudio/miniaudio/dr_flac.h:436:9, line:442:9> line:436:9 struct definition
Record: RecordDecl 0x7fb2090d64f8 </pyminiaudio/miniaudio/dr_flac.h:444:9, line:451:9> line:444:9 struct definition
Record: RecordDecl 0x7fb2090d68a8 </pyminiaudio/miniaudio/dr_flac.h:453:9, line:466:9> line:453:9 struct definition
Record: RecordDecl 0x7fb2090d5a18 </pyminiaudio/miniaudio/dr_flac.h:414:5, line:467:5> line:414:5 union definition
Record: RecordDecl 0x7fb2090d5848 </pyminiaudio/miniaudio/dr_flac.h:399:9, line:468:1> line:399:9 struct definition
Record: RecordDecl 0x7fb2090d7a50 </pyminiaudio/miniaudio/dr_flac.h:550:9, line:556:1> line:550:9 struct definition
Record: RecordDecl 0x7fb2090da1c8 </pyminiaudio/miniaudio/dr_flac.h:626:9, line:657:1> line:626:9 struct definition
Record: RecordDecl 0x7fb2090d9e88 </pyminiaudio/miniaudio/dr_flac.h:611:9, line:624:1> line:611:9 struct definition
Record: RecordDecl 0x7fb2090da5d8 </pyminiaudio/miniaudio/dr_flac.h:659:9, line:672:1> line:659:9 struct definition
Record: RecordDecl 0x7fb2090d9470 </pyminiaudio/miniaudio/dr_flac.h:559:9, line:564:1> line:559:9 struct definition
Record: RecordDecl 0x7fb2090d96f8 </pyminiaudio/miniaudio/dr_flac.h:567:9, line:609:1> line:567:9 struct definition
Record: RecordDecl 0x7fb2090daa58 </pyminiaudio/miniaudio/dr_flac.h:674:9, line:749:1> line:674:9 struct definition
Record: RecordDecl 0x7fb207817ea8 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/_stdio.h:92:1, line:95:1> line:92:8 struct __sbuf definition
Record: RecordDecl 0x7fb2078180c0 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/_stdio.h:126:9, line:157:1> line:126:16 struct __sFILE definition
Record: RecordDecl 0x7fb2090e31c8 </pyminiaudio/miniaudio/dr_flac.h:1237:9, line:1241:1> line:1237:9 struct definition
Record: RecordDecl 0x7fb2090e39f0 </pyminiaudio/miniaudio/dr_flac.h:1257:9, line:1261:1> line:1257:9 struct definition
Record: RecordDecl 0x7fb2090e3c48 </pyminiaudio/miniaudio/dr_flac.h:1265:9, line:1270:1> line:1265:9 struct definition
Record: RecordDecl 0x7fb2090e4000 </pyminiaudio/miniaudio/dr_flac.h:1273:9, line:1282:1> line:1273:9 struct definition
Record: RecordDecl 0x7fb20b09ebe8 </pyminiaudio/miniaudio/dr_mp3.h:248:9, line:253:1> line:248:9 struct definition
Record: RecordDecl 0x7fb20b09e868 </pyminiaudio/miniaudio/dr_mp3.h:243:9, line:246:1> line:243:9 struct definition
Record: RecordDecl 0x7fb20b0d0598 </pyminiaudio/miniaudio/dr_mp3.h:684:9, line:688:1> line:684:9 struct definition
Record: RecordDecl 0x7fb20b0d0ff8 </pyminiaudio/miniaudio/dr_mp3.h:701:9, line:708:1> line:701:9 struct definition
Record: RecordDecl 0x7fb20b0d1888 </pyminiaudio/miniaudio/dr_mp3.h:710:9, line:717:1> line:710:9 struct definition
Record: RecordDecl 0x7fb20b0d0838 </pyminiaudio/miniaudio/dr_mp3.h:690:9, line:694:1> line:690:9 struct definition
Record: RecordDecl 0x7fb20b0c8898 </pyminiaudio/miniaudio/dr_mp3.h:320:9, line:326:1> line:320:9 struct definition
Record: RecordDecl 0x7fb20b09ffa8 </pyminiaudio/miniaudio/dr_mp3.h:284:9, line:290:1> line:284:9 struct definition
Record: RecordDecl 0x7fb20b0c9db0 </pyminiaudio/miniaudio/dr_mp3.h:358:5, line:363:5> line:358:5 struct definition
Record: RecordDecl 0x7fb20b0c91d8 </pyminiaudio/miniaudio/dr_mp3.h:334:9, line:364:1> line:334:9 struct definition
Record: RecordDecl 0x7fb209a54830 </pyminiaudio/miniaudio/dr_mp3.h:3925:9, line:3929:1> line:3925:9 struct definition
Record: RecordDecl 0x7fb20b0c8fa8 </pyminiaudio/miniaudio/dr_mp3.h:328:9, line:332:1> line:328:9 struct definition
Record: RecordDecl 0x7fb209a66fb8 </pyminiaudio/miniaudio/dr_wav.h:312:9, line:350:1> line:312:9 struct definition
Record: RecordDecl 0x7fb209a68678 </pyminiaudio/miniaudio/dr_wav.h:422:9, line:428:1> line:422:9 struct definition
Record: RecordDecl 0x7fb209a696f8 </pyminiaudio/miniaudio/dr_wav.h:459:9, line:467:1> line:459:9 struct definition
Record: RecordDecl 0x7fb209a69aa8 </pyminiaudio/miniaudio/dr_wav.h:469:10, line:481:1> line:469:10 struct definition
Record: RecordDecl 0x7fb209a68d88 </pyminiaudio/miniaudio/dr_wav.h:431:9, line:436:1> line:431:9 struct definition
Record: RecordDecl 0x7fb209a69048 </pyminiaudio/miniaudio/dr_wav.h:439:9, line:446:1> line:439:9 struct definition
Record: RecordDecl 0x7fb209a6aa10 </pyminiaudio/miniaudio/dr_wav.h:553:5, line:556:5> line:553:5 struct definition
Record: RecordDecl 0x7fb209a6abb8 </pyminiaudio/miniaudio/dr_wav.h:559:5, line:567:5> line:559:5 struct definition
Record: RecordDecl 0x7fb209a6b228 </pyminiaudio/miniaudio/dr_wav.h:570:5, line:577:5> line:570:5 struct definition
Record: RecordDecl 0x7fb209a6a138 </pyminiaudio/miniaudio/dr_wav.h:483:9, line:578:1> line:483:9 struct definition
Record: RecordDecl 0x7fb209a66a90 </pyminiaudio/miniaudio/dr_wav.h:296:5, line:300:5> line:296:5 union definition
Record: RecordDecl 0x7fb209a669e8 </pyminiaudio/miniaudio/dr_wav.h:294:9, line:310:1> line:294:9 struct definition
Record: RecordDecl 0x7fb209a693a8 </pyminiaudio/miniaudio/dr_wav.h:448:9, line:455:1> line:448:9 struct definition
Record: RecordDecl 0x7fb20b2311e8 </pyminiaudio/miniaudio/miniaudio.h:1880:9, line:1886:1> line:1880:9 struct definition
Record: RecordDecl 0x7fb20780f6d0 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/i386/_types.h:76:9, line:79:1> line:76:9 union definition
Record: RecordDecl 0x7fb20b25de00 </pyminiaudio/miniaudio/miniaudio.h:2309:5, line:2313:5> line:2309:5 struct definition
Record: RecordDecl 0x7fb20b25e018 </pyminiaudio/miniaudio/miniaudio.h:2314:5, line:2317:5> line:2314:5 struct definition
Record: RecordDecl 0x7fb20b25db58 </pyminiaudio/miniaudio/miniaudio.h:2302:9, line:2318:1> line:2302:9 struct definition
Record: RecordDecl 0x7fb20b25b208 </pyminiaudio/miniaudio/miniaudio.h:2254:9, line:2262:1> line:2254:9 struct definition
Record: RecordDecl 0x7fb20b25bbf0 </pyminiaudio/miniaudio/miniaudio.h:2273:5, line:2277:5> line:2273:5 union definition
Record: RecordDecl 0x7fb20b25bf38 </pyminiaudio/miniaudio/miniaudio.h:2278:5, line:2282:5> line:2278:5 union definition
Record: RecordDecl 0x7fb20b231b10 </pyminiaudio/miniaudio/miniaudio.h:1899:9, line:1903:1> line:1899:9 union definition
Record: RecordDecl 0x7fb20b2344f0 </pyminiaudio/miniaudio/miniaudio.h:1955:9, line:1961:1> line:1955:9 struct definition
Record: RecordDecl 0x7fb20b232838 </pyminiaudio/miniaudio/miniaudio.h:1919:9, line:1930:1> line:1919:9 struct definition
Record: RecordDecl 0x7fb20b235250 </pyminiaudio/miniaudio/miniaudio.h:1968:9, line:1971:1> line:1968:9 struct definition
Record: RecordDecl 0x7fb20b248830 </pyminiaudio/miniaudio/miniaudio.h:1990:9, line:1998:1> line:1990:9 struct definition
Record: RecordDecl 0x7fb20b25b968 </pyminiaudio/miniaudio/miniaudio.h:2266:9, line:2284:1> line:2266:9 struct definition
Record: RecordDecl 0x7fb20b260910 </pyminiaudio/miniaudio/miniaudio.h:2328:9, line:2331:9> line:2328:9 struct definition
Record: RecordDecl 0x7fb20b260810 </pyminiaudio/miniaudio/miniaudio.h:2325:5, line:2332:5> line:2325:5 union definition
Record: RecordDecl 0x7fb20b260710 </pyminiaudio/miniaudio/miniaudio.h:2322:9, line:2333:1> line:2322:9 struct definition
Record: RecordDecl 0x7fb207814738 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/sys/_pthread/_pthread_types.h:78:1, line:81:1> line:78:8 struct _opaque_pthread_mutex_t definition
Record: RecordDecl 0x7fb20b27cbe0 </pyminiaudio/miniaudio/miniaudio.h:2921:9, line:2924:9> line:2921:9 struct definition
Record: RecordDecl 0x7fb20b27cb40 </pyminiaudio/miniaudio/miniaudio.h:2912:5, line:2927:5> line:2912:5 union definition
Record: RecordDecl 0x7fb20b27ca38 </pyminiaudio/miniaudio/miniaudio.h:2908:9, line:2928:1> line:2908:9 struct definition
Record: RecordDecl 0x7fb207812328 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/sys/_pthread/_pthread_types.h:68:1, line:71:1> line:68:8 struct _opaque_pthread_cond_t definition
Record: RecordDecl 0x7fb20b27d270 </pyminiaudio/miniaudio/miniaudio.h:2943:9, line:2948:9> line:2943:9 struct definition
Record: RecordDecl 0x7fb20b27d1d0 </pyminiaudio/miniaudio/miniaudio.h:2934:5, line:2951:5> line:2934:5 union definition
Record: RecordDecl 0x7fb20b27d0c8 </pyminiaudio/miniaudio/miniaudio.h:2930:9, line:2952:1> line:2930:9 struct definition
Record: RecordDecl 0x7fb207811d70 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/sys/_pthread/_pthread_types.h:57:1, line:61:1> line:57:8 struct __darwin_pthread_handler_rec definition
Record: RecordDecl 0x7fb207815028 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/sys/_pthread/_pthread_types.h:103:1, line:107:1> line:103:8 struct _opaque_pthread_t definition
Record: RecordDecl 0x7fb20b27c5b0 </pyminiaudio/miniaudio/miniaudio.h:2899:9, line:2902:9> line:2899:9 struct definition
Record: RecordDecl 0x7fb20b27c508 </pyminiaudio/miniaudio/miniaudio.h:2890:5, line:2905:5> line:2890:5 union definition
Record: RecordDecl 0x7fb20b27c388 </pyminiaudio/miniaudio/miniaudio.h:2886:9, line:2906:1> line:2886:9 struct definition
Record: RecordDecl 0x7fb20b288670 </pyminiaudio/miniaudio/miniaudio.h:3674:9, line:3677:9> line:3674:9 struct definition
Record: RecordDecl 0x7fb20b288818 </pyminiaudio/miniaudio/miniaudio.h:3678:9, line:3681:9> line:3678:9 struct definition
Record: RecordDecl 0x7fb20b288568 </pyminiaudio/miniaudio/miniaudio.h:3671:5, line:3682:5> line:3671:5 struct definition
Record: RecordDecl 0x7fb20b264c10 </pyminiaudio/miniaudio/miniaudio.h:2476:9, line:2480:9> line:2476:9 struct definition
Record: RecordDecl 0x7fb20b264e28 </pyminiaudio/miniaudio/miniaudio.h:2481:9, line:2484:9> line:2481:9 struct definition
Record: RecordDecl 0x7fb20b264aa8 </pyminiaudio/miniaudio/miniaudio.h:2472:5, line:2485:5> line:2472:5 struct definition
Record: RecordDecl 0x7fb20b264498 </pyminiaudio/miniaudio/miniaudio.h:2459:9, line:2486:1> line:2459:9 struct definition
Record: RecordDecl 0x7fb20b2633f0 </pyminiaudio/miniaudio/miniaudio.h:2437:5, line:2441:5> line:2437:5 union definition
Record: RecordDecl 0x7fb20b263078 </pyminiaudio/miniaudio/miniaudio.h:2429:9, line:2447:1> line:2429:9 struct definition
Record: RecordDecl 0x7fb20b2657d8 </pyminiaudio/miniaudio/miniaudio.h:2491:9, line:2501:1> line:2491:9 struct definition
Record: RecordDecl 0x7fb20b288a88 </pyminiaudio/miniaudio/miniaudio.h:3683:5, line:3700:5> line:3683:5 struct definition
Record: RecordDecl 0x7fb20b2892f8 </pyminiaudio/miniaudio/miniaudio.h:3701:5, line:3718:5> line:3701:5 struct definition
Record: RecordDecl 0x7fb20b2721f8 </pyminiaudio/miniaudio/miniaudio.h:2623:9, line:2634:1> line:2623:9 struct definition
Record: RecordDecl 0x7fb20b276ed8 </pyminiaudio/miniaudio/miniaudio.h:2655:9, line:2660:1> line:2655:9 struct definition
Record: RecordDecl 0x7fb20b289c10 </pyminiaudio/miniaudio/miniaudio.h:3819:9, line:3836:9> line:3819:9 struct definition
Record: RecordDecl 0x7fb20b280848 </pyminiaudio/miniaudio/miniaudio.h:3111:9, line:3115:1> line:3111:9 union definition
Record: RecordDecl 0x7fb20b28a308 </pyminiaudio/miniaudio/miniaudio.h:3898:9, line:3912:9> line:3898:9 struct definition
Record: RecordDecl 0x7fb20b289b68 </pyminiaudio/miniaudio/miniaudio.h:3720:5, line:3914:5> line:3720:5 union definition
Record: RecordDecl 0x7fb20b287bc8 prev 0x7fb20b22f838 </pyminiaudio/miniaudio/miniaudio.h:3649:1, line:3915:1> line:3649:8 struct ma_device definition
Record: RecordDecl 0x7fb20b280aa8 </pyminiaudio/miniaudio/miniaudio.h:3117:9, line:3133:1> line:3117:9 union definition
Record: RecordDecl 0x7fb20b2819b8 </pyminiaudio/miniaudio/miniaudio.h:3156:5, line:3159:5> line:3156:5 struct definition
Record: RecordDecl 0x7fb20b2814e8 </pyminiaudio/miniaudio/miniaudio.h:3135:9, line:3160:1> line:3135:9 struct definition
Record: RecordDecl 0x7fb20b282340 </pyminiaudio/miniaudio/miniaudio.h:3178:9, line:3181:9> line:3178:9 struct definition
Record: RecordDecl 0x7fb20b2824e8 </pyminiaudio/miniaudio/miniaudio.h:3182:9, line:3185:9> line:3182:9 struct definition
Record: RecordDecl 0x7fb20b282238 </pyminiaudio/miniaudio/miniaudio.h:3175:5, line:3186:5> line:3175:5 struct definition
Record: RecordDecl 0x7fb20b282758 </pyminiaudio/miniaudio/miniaudio.h:3187:5, line:3194:5> line:3187:5 struct definition
Record: RecordDecl 0x7fb20b282b48 </pyminiaudio/miniaudio/miniaudio.h:3195:5, line:3202:5> line:3195:5 struct definition
Record: RecordDecl 0x7fb20b282ec8 </pyminiaudio/miniaudio/miniaudio.h:3204:5, line:3210:5> line:3204:5 struct definition
Record: RecordDecl 0x7fb20b283198 </pyminiaudio/miniaudio/miniaudio.h:3211:5, line:3217:5> line:3211:5 struct definition
Record: RecordDecl 0x7fb20b283468 </pyminiaudio/miniaudio/miniaudio.h:3218:5, line:3222:5> line:3218:5 struct definition
Record: RecordDecl 0x7fb20b281ce8 </pyminiaudio/miniaudio/miniaudio.h:3162:9, line:3223:1> line:3162:9 struct definition
Record: RecordDecl 0x7fb20b286320 </pyminiaudio/miniaudio/miniaudio.h:3485:9, line:3512:9> line:3485:9 struct definition
Record: RecordDecl 0x7fb20b286d08 </pyminiaudio/miniaudio/miniaudio.h:3594:9, line:3597:9> line:3594:9 struct definition
Record: RecordDecl 0x7fb20b286280 </pyminiaudio/miniaudio/miniaudio.h:3300:5, line:3599:5> line:3300:5 union definition
Record: RecordDecl 0x7fb20b2871c0 </pyminiaudio/miniaudio/miniaudio.h:3625:9, line:3643:9> line:3625:9 struct definition
Record: RecordDecl 0x7fb20b287118 </pyminiaudio/miniaudio/miniaudio.h:3601:5, line:3646:5> line:3601:5 union definition
Record: RecordDecl 0x7fb20b284750 prev 0x7fb20b22f6c8 </pyminiaudio/miniaudio/miniaudio.h:3275:1, line:3647:1> line:3275:8 struct ma_context definition
Record: RecordDecl 0x7fb20780db08 <<invalid sloc>> <invalid sloc> implicit struct __va_list_tag definition
Record: RecordDecl 0x7fb20b27d9d0 </pyminiaudio/miniaudio/miniaudio.h:2967:9, line:2970:9> line:2967:9 struct definition
Record: RecordDecl 0x7fb20b27d930 </pyminiaudio/miniaudio/miniaudio.h:2958:5, line:2973:5> line:2958:5 union definition
Record: RecordDecl 0x7fb20b27d828 </pyminiaudio/miniaudio/miniaudio.h:2954:9, line:2974:1> line:2954:9 struct definition
Record: RecordDecl 0x7fb20b2839c8 </pyminiaudio/miniaudio/miniaudio.h:3231:5, line:3234:5> line:3231:5 struct definition
Record: RecordDecl 0x7fb20b283b78 </pyminiaudio/miniaudio/miniaudio.h:3235:5, line:3240:5> line:3235:5 struct definition
Record: RecordDecl 0x7fb20b283df8 </pyminiaudio/miniaudio/miniaudio.h:3241:5, line:3245:5> line:3241:5 struct definition
Record: RecordDecl 0x7fb20b284028 </pyminiaudio/miniaudio/miniaudio.h:3246:5, line:3250:5> line:3246:5 struct definition
Record: RecordDecl 0x7fb20b283758 </pyminiaudio/miniaudio/miniaudio.h:3225:9, line:3251:1> line:3225:9 struct definition
Record: RecordDecl 0x7fb20b231d48 </pyminiaudio/miniaudio/miniaudio.h:1905:9, line:1915:1> line:1905:9 struct definition
Record: RecordDecl 0x7fb20b233918 </pyminiaudio/miniaudio/miniaudio.h:1943:9, line:1950:1> line:1943:9 struct definition
Record: RecordDecl 0x7fb20b235ea0 </pyminiaudio/miniaudio/miniaudio.h:1979:9, line:1986:1> line:1979:9 struct definition
Record: RecordDecl 0x7fb20b2498a8 </pyminiaudio/miniaudio/miniaudio.h:2011:9, line:2018:1> line:2011:9 struct definition
Record: RecordDecl 0x7fb20b24a480 </pyminiaudio/miniaudio/miniaudio.h:2023:9, line:2029:1> line:2023:9 struct definition
Record: RecordDecl 0x7fb20b24b1e0 </pyminiaudio/miniaudio/miniaudio.h:2036:9, line:2039:1> line:2036:9 struct definition
Record: RecordDecl 0x7fb20b24bda0 </pyminiaudio/miniaudio/miniaudio.h:2047:9, line:2054:1> line:2047:9 struct definition
Record: RecordDecl 0x7fb20b24c530 </pyminiaudio/miniaudio/miniaudio.h:2058:9, line:2066:1> line:2058:9 struct definition
Record: RecordDecl 0x7fb20b24d5a8 </pyminiaudio/miniaudio/miniaudio.h:2079:9, line:2086:1> line:2079:9 struct definition
Record: RecordDecl 0x7fb20b24dd50 </pyminiaudio/miniaudio/miniaudio.h:2090:9, line:2093:1> line:2090:9 struct definition
Record: RecordDecl 0x7fb20b24e940 </pyminiaudio/miniaudio/miniaudio.h:2101:9, line:2108:1> line:2101:9 struct definition
Record: RecordDecl 0x7fb20b24f0d0 </pyminiaudio/miniaudio/miniaudio.h:2112:9, line:2118:1> line:2112:9 struct definition
Record: RecordDecl 0x7fb20b24ff68 </pyminiaudio/miniaudio/miniaudio.h:2131:9, line:2138:1> line:2131:9 struct definition
Record: RecordDecl 0x7fb20b256720 </pyminiaudio/miniaudio/miniaudio.h:2142:9, line:2145:1> line:2142:9 struct definition
Record: RecordDecl 0x7fb20b257338 </pyminiaudio/miniaudio/miniaudio.h:2158:9, line:2166:1> line:2158:9 struct definition
Record: RecordDecl 0x7fb20b257bf8 </pyminiaudio/miniaudio/miniaudio.h:2170:9, line:2173:1> line:2170:9 struct definition
Record: RecordDecl 0x7fb20b258818 </pyminiaudio/miniaudio/miniaudio.h:2186:9, line:2194:1> line:2186:9 struct definition
Record: RecordDecl 0x7fb20b2590d8 </pyminiaudio/miniaudio/miniaudio.h:2198:9, line:2201:1> line:2198:9 struct definition
Record: RecordDecl 0x7fb20b259cf8 </pyminiaudio/miniaudio/miniaudio.h:2214:9, line:2222:1> line:2214:9 struct definition
Record: RecordDecl 0x7fb20b25a5b8 </pyminiaudio/miniaudio/miniaudio.h:2226:9, line:2229:1> line:2226:9 struct definition
Record: RecordDecl 0x7fb20b262478 </pyminiaudio/miniaudio/miniaudio.h:2416:9, line:2425:1> line:2416:9 struct definition
Record: RecordDecl 0x7fb20b296ed0 </pyminiaudio/miniaudio/miniaudio.h:5267:9, line:5270:9> line:5267:9 struct definition
Record: RecordDecl 0x7fb20b297078 </pyminiaudio/miniaudio/miniaudio.h:5271:9, line:5274:9> line:5271:9 struct definition
Record: RecordDecl 0x7fb20b296dc8 </pyminiaudio/miniaudio/miniaudio.h:5264:5, line:5275:5> line:5264:5 struct definition
Record: RecordDecl 0x7fb20b296a98 </pyminiaudio/miniaudio/miniaudio.h:5256:9, line:5277:1> line:5256:9 struct definition
Record: RecordDecl 0x7fb20b297d28 </pyminiaudio/miniaudio/miniaudio.h:5300:5, line:5305:5> line:5300:5 struct definition
Record: RecordDecl 0x7fb20b297418 prev 0x7fb20b2958b0 </pyminiaudio/miniaudio/miniaudio.h:5279:1, line:5306:1> line:5279:8 struct ma_decoder definition
Record: RecordDecl 0x7fb20b2a03a8 </pyminiaudio/miniaudio/miniaudio.h:5395:9, line:5402:1> line:5395:9 struct definition
Record: RecordDecl 0x7fb20b2a0ab8 prev 0x7fb20b29f478 </pyminiaudio/miniaudio/miniaudio.h:5406:1, line:5417:1> line:5406:8 struct ma_encoder definition
Record: RecordDecl 0x7fb20b2a20c8 </pyminiaudio/miniaudio/miniaudio.h:5442:9, line:5450:1> line:5442:9 struct definition
Record: RecordDecl 0x7fb20b2a2988 </pyminiaudio/miniaudio/miniaudio.h:5454:9, line:5459:1> line:5454:9 struct definition
Record: RecordDecl 0x7fb20b2a3ba8 </pyminiaudio/miniaudio/miniaudio.h:5476:9, line:5484:1> line:5476:9 struct definition
Record: RecordDecl 0x7fb20b2318f8 </pyminiaudio/miniaudio/miniaudio.h:1888:9, line:1891:1> line:1888:9 struct definition
Record: RecordDecl 0x7fb20b2a45e0 </pyminiaudio/miniaudio/miniaudio.h:5494:9, line:5499:9> line:5494:9 struct definition
Record: RecordDecl 0x7fb20b2a4ab8 </pyminiaudio/miniaudio/miniaudio.h:5500:9, line:5503:9> line:5500:9 struct definition
Record: RecordDecl 0x7fb20b2a4540 </pyminiaudio/miniaudio/miniaudio.h:5492:5, line:5504:5> line:5492:5 union definition
Record: RecordDecl 0x7fb20b2a43c0 </pyminiaudio/miniaudio/miniaudio.h:5488:9, line:5505:1> line:5488:9 struct definition
Record: RecordDecl 0x116294bf8 </pyminiaudio/miniaudio/stb_vorbis.c:762:9, line:766:1> line:762:9 struct definition
Record: RecordDecl 0x7fb2090c1600 </pyminiaudio/miniaudio/stb_vorbis.c:113:9, line:117:1> line:113:9 struct definition
Record: RecordDecl 0x116291a88 </pyminiaudio/miniaudio/stb_vorbis.c:663:9, line:684:1> line:663:9 struct definition
Record: RecordDecl 0x116292488 </pyminiaudio/miniaudio/stb_vorbis.c:686:9, line:695:1> line:686:9 struct definition
Record: RecordDecl 0x116292948 </pyminiaudio/miniaudio/stb_vorbis.c:697:9, line:711:1> line:697:9 struct definition
Record: RecordDecl 0x116293668 </pyminiaudio/miniaudio/stb_vorbis.c:713:9, line:717:1> line:713:9 union definition
Record: RecordDecl 0x116293958 </pyminiaudio/miniaudio/stb_vorbis.c:719:9, line:727:1> line:719:9 struct definition
Record: RecordDecl 0x116293e88 </pyminiaudio/miniaudio/stb_vorbis.c:729:9, line:734:1> line:729:9 struct definition
Record: RecordDecl 0x116294118 </pyminiaudio/miniaudio/stb_vorbis.c:736:9, line:743:1> line:736:9 struct definition
Record: RecordDecl 0x1162945a8 </pyminiaudio/miniaudio/stb_vorbis.c:745:9, line:751:1> line:745:9 struct definition
Record: RecordDecl 0x116294898 </pyminiaudio/miniaudio/stb_vorbis.c:753:9, line:760:1> line:753:9 struct definition
Record: RecordDecl 0x116294e88 prev 0x7fb2090c1860 </pyminiaudio/miniaudio/stb_vorbis.c:768:1, line:884:1> line:768:8 struct stb_vorbis definition
Record: RecordDecl 0x7fb2090c19c8 </pyminiaudio/miniaudio/stb_vorbis.c:124:9, line:134:1> line:124:9 struct definition
Record: RecordDecl 0x7fb2090c1da8 </pyminiaudio/miniaudio/stb_vorbis.c:136:9, line:142:1> line:136:9 struct definition
Record: RecordDecl 0x7fb20788ceb8 </pyminiaudio/miniaudio/dr_flac.h:6058:9, line:6082:1> line:6058:9 struct definition
Record: RecordDecl 0x7fb209910290 </usr/local/Cellar/llvm/10.0.0_3/Toolchains/LLVM10.0.0.xctoolchain/usr/lib/clang/10.0.0/include/emmintrin.h:3550:3, line:3552:3> line:3550:10 struct __loadu_si128 definition
Record: RecordDecl 0x7fb20991a538 </usr/local/Cellar/llvm/10.0.0_3/Toolchains/LLVM10.0.0.xctoolchain/usr/lib/clang/10.0.0/include/emmintrin.h:4013:3, line:4015:3> line:4013:10 struct __storeu_si128 definition
Record: RecordDecl 0x7fb2091522c0 </usr/local/Cellar/llvm/10.0.0_3/Toolchains/LLVM10.0.0.xctoolchain/usr/lib/clang/10.0.0/include/xmmintrin.h:1985:3, line:1987:3> line:1985:10 struct __storeu_ps definition
Record: RecordDecl 0x7fb2091513e8 </usr/local/Cellar/llvm/10.0.0_3/Toolchains/LLVM10.0.0.xctoolchain/usr/lib/clang/10.0.0/include/xmmintrin.h:1944:3, line:1946:3> line:1944:10 struct __mm_storeh_pi_struct definition
Record: RecordDecl 0x7fb20b0d0d68 </pyminiaudio/miniaudio/dr_mp3.h:696:9, line:699:1> line:696:9 struct definition
Record: RecordDecl 0x7fb20914b890 </usr/local/Cellar/llvm/10.0.0_3/Toolchains/LLVM10.0.0.xctoolchain/usr/lib/clang/10.0.0/include/xmmintrin.h:1742:3, line:1744:3> line:1742:10 struct __loadu_ps definition
Record: RecordDecl 0x7fb207975550 </pyminiaudio/miniaudio/dr_wav.h:1277:5, line:1280:5> line:1277:5 union definition
Record: RecordDecl 0x7fb207974710 </pyminiaudio/miniaudio/dr_wav.h:1256:5, line:1259:5> line:1256:5 union definition
Record: RecordDecl 0x7fb2078148f0 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/sys/_pthread/_pthread_types.h:83:1, line:86:1> line:83:8 struct _opaque_pthread_mutexattr_t definition
Record: RecordDecl 0x7fb207812518 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/sys/_pthread/_pthread_types.h:73:1, line:76:1> line:73:8 struct _opaque_pthread_condattr_t definition
Record: RecordDecl 0x7fb207812140 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/sys/_pthread/_pthread_types.h:63:1, line:66:1> line:63:8 struct _opaque_pthread_attr_t definition
Record: RecordDecl 0x7fb20799fe60 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/sched.h:35:1, col:80> col:8 struct sched_param definition
Record: RecordDecl 0x7fb209d6a6c0 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/AudioToolbox.framework/Headers/AudioComponent.h:264:9, line:270:1> line:264:16 struct AudioComponentDescription definition
Record: RecordDecl 0x7fb209b76a00 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/CoreAudio.framework/Headers/AudioHardwareBase.h:102:1, line:107:1> line:102:9 struct AudioObjectPropertyAddress definition
Record: RecordDecl 0x7fb209b51018 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/CoreAudio.framework/Headers/CoreAudioTypes.h:159:1, line:164:1> line:159:8 struct AudioBuffer definition
Record: RecordDecl 0x7fb209b512c8 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/CoreAudio.framework/Headers/CoreAudioTypes.h:175:1, line:189:1> line:175:8 struct AudioBufferList definition
Record: RecordDecl 0x7fb209b519d8 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/CoreAudio.framework/Headers/CoreAudioTypes.h:267:1, line:278:1> line:267:8 struct AudioStreamBasicDescription definition
Record: RecordDecl 0x7fb209b50ab0 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/CoreAudio.framework/Headers/CoreAudioTypes.h:113:1, line:117:1> line:113:8 struct AudioValueRange definition
Record: RecordDecl 0x7fb209b7b4e0 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/CoreAudio.framework/Headers/AudioHardwareBase.h:972:1, line:976:1> line:972:9 struct AudioStreamRangedDescription definition
Record: RecordDecl 0x7fb209b73738 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/CoreAudio.framework/Headers/CoreAudioTypes.h:1321:1, line:1326:1> line:1321:8 struct AudioChannelDescription definition
Record: RecordDecl 0x7fb209b73a78 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/CoreAudio.framework/Headers/CoreAudioTypes.h:1343:1, line:1360:1> line:1343:8 struct AudioChannelLayout definition
Record: RecordDecl 0x116084760 </pyminiaudio/miniaudio/miniaudio.h:23529:9, line:23560:1> line:23529:9 struct definition
Record: RecordDecl 0x7fb209b557e8 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/CoreAudio.framework/Headers/CoreAudioTypes.h:756:1, line:767:1> line:756:8 struct SMPTETime definition
Record: RecordDecl 0x7fb209b56470 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/CoreAudio.framework/Headers/CoreAudioTypes.h:818:1, line:827:1> line:818:8 struct AudioTimeStamp definition
Record: RecordDecl 0x7fb20b37a608 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks/AudioToolbox.framework/Headers/AudioUnitProperties.h:896:9, line:899:1> line:896:16 struct AURenderCallbackStruct definition
Record: RecordDecl 0x7fb2090b2000 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/sys/_types/_timeval.h:29:33, line:38:1> line:29:40 struct timeval definition
Record: RecordDecl 0x7fb2079c9970 </Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include/sys/_types/_fd_def.h:49:9, line:51:1> line:49:16 struct fd_set definition
Record: RecordDecl 0x7fb209ad21a0 </pyminiaudio/miniaudio/miniaudio.h:9375:9, line:9382:1> line:9375:9 struct definition
Record: RecordDecl 0x11622b730 </pyminiaudio/miniaudio/miniaudio.h:39799:9, line:39808:1> line:39799:9 struct definition
Record: RecordDecl 0x1162ae0a8 </pyminiaudio/miniaudio/stb_vorbis.c:1298:9, line:1301:1> line:1298:9 struct definition
Record: RecordDecl 0x116372de0 </pyminiaudio/miniaudio/stb_vorbis.c:5119:12, line:5122:4> line:5119:12 union definition
""";

final trickRecordDecls = [
  'Record: RecordDecl 0x7fb20b287118 </pyminiaudio/miniaudio/miniaudio.h:3601:5, line:3646:5> line:3601:5 union definition',
  'Record: RecordDecl 0x7fb209b557e8 </CoreAudio.framework/Headers/CoreAudioTypes.h:756:1, line:767:1> line:756:8 struct SMPTETime definition',
  'Record: RecordDecl 0x7fb20b284750 prev 0x7fb20b22f6c8 </pyminiaudio/miniaudio/miniaudio.h:3275:1, line:3647:1> line:3275:8 struct ma_context definition',
  'Record: RecordDecl 0x7fb20780db08 <<invalid sloc>> <invalid sloc> implicit struct __va_list_tag definition' // policy: ignore the whole IRgen record
];

void main() {

  test("verify patterns match", () {
    final first = IRgenRecordLayoutPatterns.first;
    final second = IRgenRecordLayoutPatterns.second;
    final hexId = IRgenRecordLayoutPatterns.hexId;
    final lineNumber = IRgenRecordLayoutPatterns.lineNumber;

    // first line
    expect(first.accept('*** Dumping IRgen Record Layout'), true);

    // 2nd line
    final firstParts = [
      'Record: RecordDecl 0x7fb20b287118 </pyminiaudio/miniaudio/miniaudio.h:1:1,'
      'Record: RecordDecl 0x7fb20b287118 prev 0x7fb20b287 </pyminiaudio/miniaudio/miniaudio.h:1:1,'
    ];
    final firstPartsPattern = string('Record: RecordDecl ') &
      (hexId | (hexId & string(' prev ') & hexId)) &
      string(' <') & noneOf(',').plus().flatten() & char(',');
    for (int i=0; i<firstParts.length; i++) {
      if (!firstPartsPattern.accept(firstParts[i])) {
        fail('Failed for: "${firstParts[i]}"');
      }
    }

//    final inputs = recordDecls.split("\n");
//    for (int i=0; i<inputs.length; i++) {
//      if (!second.accept(inputs[i])) {
//        fail("Failed on line $i");
//      }
//    }
  });
}
