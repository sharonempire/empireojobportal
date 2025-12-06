import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final IconData? trailingIcon;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? width;
  final double? height;
  final double? iconSize;
  final double? elevation;
  final double offset;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool showBorder;
  final bool showShadow;
  final Color? borderColor;

  const PrimaryButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = ColorConsts.white,
    this.textColor = ColorConsts.black,
    this.icon,
    this.trailingIcon,
    this.fontSize = 18,
    this.borderRadius = 24,
    this.elevation = 4,
    this.iconSize = 20,
    this.fontWeight = FontWeight.w600,
    this.width,
    this.height = 50,
    this.offset = 6,
    this.padding,
    this.showBorder = true,
    this.showShadow = true,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? context.themeDivider;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder ? Border.all(color: border) : null,
        boxShadow: showShadow && !isDark
            ? [
                BoxShadow(
                  color: context.themeGrey600.withOpacity(.4),
                  blurRadius: 1,
                  offset: Offset(0, offset),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: iconSize),
              const SizedBox(width: 7),
            ],
            CustomText(
              text: text,
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor,
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              Icon(trailingIcon, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}