# dart_ast_json
dart build_runner ffi binding generator for any LLVM JSON ast-dump


Access nested enums and structs in a struct
===========================================

[See this work around](https://github.com/dart-lang/sdk/issues/37271#issuecomment-502946889)


Run program
===========
```bash
pub run build_runner build
```

Struct alignment & padding
=========
* [Aligment](https://github.com/dart-lang/sdk/blob/master/pkg/vm/lib/transformations/ffi.dart)
* [The lost art of Structure Packing](http://www.catb.org/esr/structure-packing/)
* [Padding in compilers](https://metricpanda.com/rival-fortress-update-35-avoiding-automatic-structure-padding-in-c/)
* [Padding in Dart (yuck)](https://github.com/timsneath/dart_console/blob/28f333aff8f508d10c0bf8431b54bbb813584cbd/lib/src/ffi/unix/termios.dart#L87-127)

Handy commands
==============

Sort out types in the AST JSON:
```bash
grep desugaredQualType web/miniaudio.json | grep -v __attr | sed -e 's/^[ \t]*//' | sort | uniq | less
```


