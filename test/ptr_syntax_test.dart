import 'package:test/test.dart';
import "package:ffi/ffi.dart" show allocate, free, Utf8;
import "dart:ffi";

class StructA extends Struct {
  Pointer<Uint64> ptrInt;
  @Uint64() int tInt;
}

class StructB extends Struct {
  Pointer<Uint8> __origin__;
}

extension StructTest on StructB {
  Pointer<Uint64> get ptrInt =>
      __origin__.elementAt(0).cast<Uint64>();
  void set ptrInt(int value) =>
      __origin__.elementAt(0).cast<Uint64>().value = value;

  // 8 byte == sizeof(Pointer on 64 bits machine)
  int get tInt =>
      __origin__.elementAt(8).cast<Uint64>().value;
  void set tInt (int value) =>
      __origin__.elementAt(8).cast<Uint64>().value = value;
}

void main() {
  test("Pass values between structs via extensions", () {
    Pointer<StructA> structA;
    try {
      structA = allocate<StructA>();
//      structA.ref.ptrInt.value = 1337; // wtf, hard crash!
      structA.ref.tInt = 1337;
      final structB = structA.cast<StructB>();

      expect(structB.ref.__origin__.address, structA.ref.ptrInt.address);
//      expect(structB.ref.tInt, structA.ref.tInt); // booom!
//      structB.ref.tInt = 1338; // boooom!

      // boooooom!
//      print (
//        '${structB.ref.ptrInt.value} '
//        '${structB.ref.tInt}');
    }finally {
      free(structA);
    }
  });
}