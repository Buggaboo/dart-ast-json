import 'package:test/test.dart';
import 'package:dart_ast_json/src/serializers.dart';
import 'package:dart_ast_json/src/fn_ptr_extractor.dart';

// TODO do this in a proper grammer with

final testNestedFunPtrs = {
  'fpa' : "int (*)(int *, int *, void *(*)(void *), void *)",
  'fpb' : "int (*)(int *, int *, void *(*)(void *, void *), void *)",
  'fpc' : "int (*)(int *, int *, void *(*)(void *, void *), void *, void *(*)(void *, void *))",
  'fpd' : "int (*)(int *, int *, void *(*)(void *, void *, void *(*)(void *, void *), void *), void *, void *(*)(void *, void *))",
  'fpe' : "int (*)(int *, int *, void *(*)(void *, void *, void *(*)(void *, void *(*)(void *), void *), void *), void *, void *(*)(void *, void *))"
};

final notNested = {
  "aaa" : "int (*)(int *, int *)",
  "bbb" : "int (*)(int *, int *, void *)"
};

const expected =
'''
null TypedefDecl gqb, type: void *(*)(void *) ;
null TypedefDecl fpa, type: int (*)(int *, int *, gqb, void *) ;
null TypedefDecl gqc, type: void *(*)(void *, void *) ;
null TypedefDecl fpb, type: int (*)(int *, int *, gqc, void *) ;
null TypedefDecl gqd, type: void *(*)(void *, void *) ;
null TypedefDecl fpc, type: int (*)(int *, int *, gqd, void *, gqd) ;
null TypedefDecl gqe, type: void *(*)(void *, void *) ;
null TypedefDecl gqegqe, type: void *(*)(void *, void *, gqe, void *) ;
null TypedefDecl fpd, type: int (*)(int *, int *, gqegqe, void *, gqe) ;
null TypedefDecl gqfgqf, type: void *(*)(void *, hrghrg, void *) ;
null TypedefDecl gqfgqfgqfgqf, type: void *(*)(void *, void *) ;
null TypedefDecl hrghrg, type: void *(*)(void *) ;
null TypedefDecl fpe, type: int (*)(int *, int *, gqfgqf, void *, gqfgqfgqfgqf) ;''';

void main() {
  test("compare output of extracted function pointers", () {
    final output = <Decl>[];
    List<Decl> input = testNestedFunPtrs.entries
        .map((e) => Decl(name: e.key, type:Type(qualType: e.value))).toList();
    extractNestedFunPtrs(input, output);

    expect(output.join('\n'), expected);
  });

  test("test unnested", () {
    final output = <Decl>[];
    List<Decl> input = notNested.entries
        .map((e) => Decl(name: e.key, type:Type(qualType: e.value))).toList();
    extractNestedFunPtrs(input, output);

    expect(output, []);
  });
}