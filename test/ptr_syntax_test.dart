import 'package:test/test.dart';
import "package:ffi/ffi.dart" show allocate, free, Utf8;
import "dart:ffi";

final offsetPtr = 0;
final offsetInt = 8;

// should have 0 padding, two word sizes (64-bit machine)
class StructA extends Struct {
  Pointer<Uint64> ptrInt;
  @Uint64() int tInt;
}

class StructB extends Struct {
  Pointer<Uint8> __origin__;
}

class StructC extends Struct {
  Pointer<Uint8> __addressOf__; // lazy init
}

/// Theory: test go boom (segfault), because memory (thread) protection?!
extension StructTest on StructB {
  Pointer<Uint64> get ptrInt =>
      __origin__.elementAt(offsetPtr).cast<Uint64>();
  void set ptrInt(int value) =>
      __origin__.elementAt(offsetPtr).cast<Uint64>().value = value;

  // 8 byte == sizeof(Pointer on 64 bits machine)
  int get tInt =>
      __origin__.elementAt(offsetInt).cast<Uint64>().value;
  void set tInt (int value) =>
      __origin__.elementAt(offsetInt).cast<Uint64>().value = value;
}

/// The cast is essential because the offsets
/// are in bytes from the ast layout dump
extension StructFromAddressOf on StructC {
  /// the struct itself shares the same address as the first field (offset: 0)
  Pointer<Uint8> get __addr__ => this.__addressOf__ ??= addressOf.cast<Uint8>();

  Pointer<Uint64> get ptrInt =>
      __addr__.elementAt(offsetPtr).cast<Uint64>();
  void set ptrInt(int value) =>
      __addr__.elementAt(offsetPtr).cast<Uint64>().value = value;

  int get tInt =>
      __addr__.elementAt(offsetInt).cast<Uint64>().value;
  void set tInt (int value) =>
      __addr__.elementAt(offsetInt).cast<Uint64>().value = value;
}

void main() {
  test("Pass values between structs via extensions", () {
    Pointer<StructA> structA;
    try {
      structA = allocate<StructA>();
//      structA.ref.ptrInt.value = 1337; // wtf, hard crash!
      structA.ref.tInt = 1337;

      // Wtf. If the int goes first, casting returns a totally different address?!
      final structB = structA.cast<StructB>();
      final structC = structA.cast<StructC>();
//      final structB = Pointer<StructB>.fromAddress(structA.address);
//      final structC = Pointer<StructC>.fromAddress(structA.address);

//      print (structB.ref.tInt); // boom!

      // commutative, transitive
      expect(structB.ref.ptrInt, structA.ref.ptrInt);
      expect(structB.ref.ptrInt, structC.ref.ptrInt);
      expect(structA.ref.ptrInt, structC.ref.ptrInt);
      expect(structB.ref.ptrInt.address, structA.ref.ptrInt.address);
      expect(structB.ref.ptrInt.address, structC.ref.ptrInt.address);
      expect(structC.ref.ptrInt.address, structA.ref.ptrInt.address);

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