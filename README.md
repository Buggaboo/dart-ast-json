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

Handy commands
==============

Sort out types in the AST JSON:
```bash
grep desugaredQualType web/miniaudio.json | grep -v __attr | sed -e 's/^[ \t]*//' | sort | uniq | less
```

Alignment
=========
[Aligment](https://github.com/dart-lang/sdk/blob/master/pkg/vm/lib/transformations/ffi.dart)


Type conversions
================
```dart
Double
Float
Int8
Int16
Int32
Int64
IntPtr
NativeApi
NativeFunction
NativeType
Pointer
Struct
Uint8
Uint16
Uint32
Uint64
Unsized
Void
```

EXTENSIONS

```dart
DoublePointer
DynamicLibraryExtension
FloatPointer
Int8Pointer
Int16Pointer
Int32Pointer
Int64Pointer
IntPtrPointer
NativeFunctionPointer
NativePort
PointerPointer
StructAddressOf
StructPointer
Uint8Pointer
Uint16Pointer
Uint32Pointer
Uint64Pointer
```