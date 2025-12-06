import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class CommonOutlinedButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? borderColor;
  final Color? textColor;
  final Color? backgroundColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double width;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final double iconSpacing; 

  const CommonOutlinedButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderColor,
    this.textColor,
    this.backgroundColor,
    this.prefixIcon,
    this.suffixIcon,
    this.width = 160,
    this.height = 42,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
    this.borderRadius = 100,
    this.iconSpacing = 8, 
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? context.themeDark,
            width: 2,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                SizedBox(width: iconSpacing), 
              ],
              CustomText(
                text: text,
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: textColor ?? context.themeDark,
              ),
              if (suffixIcon != null) ...[
                SizedBox(width: iconSpacing),
                suffixIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
