import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/utils/responsive.dart';
import 'package:flutter/material.dart';

class DescriptionTextfieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool isRequired;
  final double? height;
  final int? maxLines;
  final int? minLines;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final Color? borderColor;
  final double? borderRadius;
  final bool readOnly;
  final int? maxLength;

  const DescriptionTextfieldWidget({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.isRequired = false,
    this.height,
    this.maxLines = 4,
    this.minLines,
    this.validator,
    this.onChanged,
    this.borderColor,
    this.borderRadius,
    this.readOnly = false,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          _buildLabel(context, labelText!, isRequired),
          SizedBox(height: context.rSpacing(8)),
        ],
        CommonTextfieldWidget(
          controller: controller,
          hintText: hintText ?? 'Enter description...',
          useBorderOnly: true,
          borderColor: borderColor ?? ColorConsts.lightGrey,
          hintFontSize: context.rFontSize(10),
          fontSize: context.rFontSize(12),
          textColor: ColorConsts.black,
          fillColor: ColorConsts.white,
          height: height ?? context.rHeight(120),
          borderRadius: borderRadius ?? 8,
          maxLines: maxLines,
          minLines: minLines ?? 4,
          readOnly: readOnly,
          maxLength: maxLength,
          validator: validator,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildLabel(BuildContext context, String label, bool isRequired) {
    return Row(
      children: [
        CustomText(
          text: label,
          fontSize: context.rFontSize(12),
          fontWeight: FontWeight.w500,
          color: ColorConsts.black,
        ),
        if (isRequired) ...[
          SizedBox(width: context.rSpacing(4)),
          CustomText(
            text: '*',
            fontSize: context.rFontSize(12),
            fontWeight: FontWeight.w500,
            color: ColorConsts.textColorRed,
          ),
        ],
      ],
    );
  }
}
