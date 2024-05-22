/** 
import 'package:flutter/material.dart';
import 'dart:ffi' as ffi;

final class AmsNetId extends ffi.Struct {
  @ffi.Array(6)
  external ffi.Uint8 b;

  AmsNetId(); // Constructor
}

final class AmsAddr extends ffi.Struct {
  external AmsNetId netId;
  @ffi.Uint16()
  external int port;

  AmsAddr(); // Constructor
}
*/