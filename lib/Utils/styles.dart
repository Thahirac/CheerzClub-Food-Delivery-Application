import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class VFuelStyles {
  final String? color;
  final double? Size;

  VFuelStyles(this.color, this.Size);

  TextStyle formTextStyle() {
    return TextStyle(
        color: HexColor(color!),
        fontFamily: "Poppins Regular",
        fontSize: Size!);
  }
}
