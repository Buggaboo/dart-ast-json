# dart_ast_json
dart build_runner ffi binding generator for any LLVM JSON ast-dump


Access nested enums and structs in a struct
===========================================

[See this work around](https://github.com/dart-lang/sdk/issues/37271#issuecomment-502946889)


Handy commands
==============

Sort out types in the AST JSON:
```bash
grep desugaredQualType web/miniaudio.json | grep -v __attr | sed -e 's/^[ \t]*//' | sort | uniq | less
```