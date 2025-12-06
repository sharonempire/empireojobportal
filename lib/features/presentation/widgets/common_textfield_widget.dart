import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonTextfieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double? height;
  final bool requiredField;
  final bool useBorderOnly;
  final Color? borderColor;
  final double? borderRadius;
  final Color? fillColor;
  final Color? hintColor;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool useFloatingLabel;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;

  const CommonTextfieldWidget({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.height = 50,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.requiredField = false,
    this.useBorderOnly = false,
    this.borderColor,
    this.borderRadius,
    this.fillColor,
    this.hintColor,
    this.onChanged,
    this.onFieldSubmitted,
    this.useFloatingLabel = false,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofocus = false,
    this.textInputAction,
    this.focusNode,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? 20);
    final borderClr = borderColor ?? context.themeDivider;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final shouldShowBorder = useFloatingLabel ? false : useBorderOnly;

    FormFieldValidator<String>? buildValidator() {
      if (validator != null) {
        return validator;
      } else if (requiredField) {
        return (value) => (value == null || value.trim().isEmpty) ? 'Required' : null;
      }
      return null;
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: shouldShowBorder || useFloatingLabel
            ? Colors.transparent
            : (fillColor ?? context.themeWhite),
        borderRadius: radius,
        boxShadow: shouldShowBorder || useFloatingLabel || isDark
            ? []
            : [
                BoxShadow(
                  color: context.themeGrey600.withOpacity(.4),
                  blurRadius: 1,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(fontSize: 12, color: context.themeDark),
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        onTap: onTap,
        readOnly: readOnly,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        autofocus: autofocus,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onSaved: onSaved,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          labelStyle: useFloatingLabel
              ? GoogleFonts.inter(
                  color: hintColor ?? context.themeIconGrey,
                  fontSize: 16,
                )
              : GoogleFonts.inter(
                  color: hintColor ?? context.themeIconGrey,
                  fontSize: 16,
                ),
          floatingLabelStyle: useFloatingLabel
              ? GoogleFonts.inter(
                  color: hintColor ?? context.themeIconGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )
              : null,
          hintStyle: GoogleFonts.inter(
            color: hintColor ?? context.themeIconGrey,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          floatingLabelBehavior: useFloatingLabel
              ? FloatingLabelBehavior.auto
              : FloatingLabelBehavior.never,
          floatingLabelAlignment: useFloatingLabel
              ? FloatingLabelAlignment.start
              : FloatingLabelAlignment.start,
          border: useFloatingLabel
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: borderClr, width: 1),
                )
              : OutlineInputBorder(
                  borderRadius: radius,
                  borderSide: useBorderOnly
                      ? BorderSide(color: borderClr)
                      : BorderSide.none,
                ),
          enabledBorder: useFloatingLabel
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: borderClr.withOpacity(0.5),
                    width: 1,
                  ),
                )
              : (useBorderOnly
                    ? OutlineInputBorder(
                        borderRadius: radius,
                        borderSide: BorderSide(color: borderClr),
                      )
                    : OutlineInputBorder(
                        borderRadius: radius,
                        borderSide: BorderSide.none,
                      )),
          focusedBorder: useFloatingLabel
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: borderClr, width: 2),
                )
              : OutlineInputBorder(
                  borderRadius: radius,
                  borderSide: BorderSide(
                    color: borderClr,
                    width: useBorderOnly ? 1.5 : 0,
                  ),
                ),
          filled: true,
          fillColor: fillColor ?? context.themeWhite,
          contentPadding: useFloatingLabel
              ? const EdgeInsets.symmetric(horizontal: 0, vertical: 8)
              : const EdgeInsets.symmetric(horizontal: 8),
        ),
        validator: buildValidator(),
      ),
    );
  }
}