import 'dart:ffi';

/// File where new structs and types are defineds


final class AmsNetId extends Struct {
  @Array(6)
  external Array<Uint8> b;
}

final class AmsAddr extends Struct {
  external AmsNetId netId;
  
  @Uint16()
  external int port;
}

// Define the Dart representation of the CNC_OBJECT struct
final class CNCObject extends Struct {
  @Uint32()
  external int group;

  @Uint32()
  external int offset;

  @Array<Uint8>(256)
  external Array<Uint8> name;

  // TODO: Extract data type? 
  @Uint32()
  external int dataType;

  @Uint32()
  external int length;
  
  @Array<Uint8>(256)
  external Array<Uint8> unit;

  @Uint32()
  external int cValue;

  external Pointer value; // Assuming CNC_OBJECT_VALUE is a void pointer
  
}

 
// Define enum for CNC_OBJECT_TYPE
enum CNCObjectType {
  NN,
  _BOOL,
  SGN08,
  UNS08,
  SGN16,
  UNS16,
  SGN32,
  UNS32,
  REAL64,
  STRING,
  SGN32_SGN32,
  UNS64,
  SGN64,
  REAL32,
  ArrayUNS16,
  ArraySGN32,
  ArrayUNS32,
  ArraySTRING,
  ArrayBOOL,
  ArrayREAL64,
  ArrayUNS08,
  ArraySGN08,
  ArraySGN16,
  ArrayUNS64,
  ArraySGN64,
  ArrayREAL32
}

// Define struct for CNC_OBJECT_VALUE
class CNCObjectValue {
  bool? boolValue;
  int? sgn08Value;
  int? uns08Value;
  int? sgn16Value;
  int? uns16Value;
  int? sgn32Value;
  int? uns32Value;
  int? sgn64Value;
  int? uns64Value;
  double? real32Value;
  double? real64Value;
  String? stringValue;
}



// Define mapping from CNCObjectType to String
const Map<CNCObjectType, String> cncObjectTypeToString = {
  CNCObjectType.NN: "NN",
  CNCObjectType._BOOL: "_BOOL",
  CNCObjectType.SGN08: "SGN08",
  CNCObjectType.UNS08: "UNS08",
  CNCObjectType.SGN16: "SGN16",
  CNCObjectType.UNS16: "UNS16",
  CNCObjectType.SGN32: "SGN32",
  CNCObjectType.UNS32: "UNS32",
  CNCObjectType.REAL64: "REAL64",
  CNCObjectType.STRING: "STRING",
  CNCObjectType.SGN32_SGN32: "SGN32_SGN32",
  CNCObjectType.UNS64: "UNS64",
  CNCObjectType.SGN64: "SGN64",
  CNCObjectType.REAL32: "REAL32",
  CNCObjectType.ArrayUNS16: "ArrayUNS16",
  CNCObjectType.ArraySGN32: "ArraySGN32",
  CNCObjectType.ArrayUNS32: "ArrayUNS32",
  CNCObjectType.ArraySTRING: "ArraySTRING",
  CNCObjectType.ArrayBOOL: "ArrayBOOL",
  CNCObjectType.ArrayREAL64: "ArrayREAL64",
  CNCObjectType.ArrayUNS08: "ArrayUNS08",
  CNCObjectType.ArraySGN08: "ArraySGN08",
  CNCObjectType.ArraySGN16: "ArraySGN16",
  CNCObjectType.ArrayUNS64: "ArrayUNS64",
  CNCObjectType.ArraySGN64: "ArraySGN64",
  CNCObjectType.ArrayREAL32: "ArrayREAL32",
};

