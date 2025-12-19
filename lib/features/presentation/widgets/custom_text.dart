import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration = TextDecoration.none,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor =
        color ??
        Theme.of(context).textTheme.bodyMedium?.color ??
        ColorConsts.black;

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      softWrap: maxLines != null ? true : null,
      style: GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: resolvedColor,
        decoration: decoration,
        decorationColor: decoration != TextDecoration.none
            ? resolvedColor
            : null,
      ),
    );
  }
}