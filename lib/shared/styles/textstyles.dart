import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

TextStyle myTextstyle({
  double? fontSize = 16,
  FontWeight? fontWeight = FontWeight.normal,
  Color color = ColorConsts.textColor,
}) {
  return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
}
