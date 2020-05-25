library dart_ast_json;

import 'package:build/build.dart';
import 'package:dart_ast_json/src/builders.dart';

// resolver strips out the fat
Builder resolver(BuilderOptions options) => ASTResolver();

// the nice bits
Builder enumBuilder(BuilderOptions options)      => EnumBuilder();
Builder typedefBuilder(BuilderOptions options)   => TypedefBuilder();
Builder functionBuilder(BuilderOptions options)  => FunctionBuilder();
Builder structBuilder(BuilderOptions options)    => StructBuilder();
Builder extensionBuilder(BuilderOptions options) => ExtensionBuilder();