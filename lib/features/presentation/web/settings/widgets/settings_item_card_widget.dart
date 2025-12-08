import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class SettingsItemCardWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final String sectionHead;

  final List<SettingsField>? fields;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool isLoading;
  final Widget? rightSideWidget;
  const SettingsItemCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.sectionHead,
    required this.description,
    this.fields,
    this.buttonText,
    this.onButtonPressed,
    this.isLoading = false,
    this.rightSideWidget,
  });

  @override
  State<SettingsItemCardWidget> createState() => _SettingsItemCardWidgetState();
}

class _SettingsItemCardWidgetState extends State<SettingsItemCardWidget> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, bool> _obscureTextStates = {};

  @override
  void initState() {
    super.initState();
    // Initialize obscure text states for password fields
    if (widget.fields != null) {
      for (var field in widget.fields!) {
        if (field.obscureText) {
          _obscureTextStates[field.label] = true;
        }
      }
    }
  }

  void _toggleObscureText(String label) {
    setState(() {
      _obscureTextStates[label] = !(_obscureTextStates[label] ?? true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: widget.title,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 4),
                CustomText(
                  text: widget.subtitle,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: context.themeGrey600,
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 4,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.description,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.themeGrey600,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 44),
                  CustomText(
                    text: widget.sectionHead,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 8),

                  if (widget.fields != null && widget.fields!.isNotEmpty) ...[
                    ...widget.fields!.map(
                      (field) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: field.label,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: context.themeIconGrey,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(right: 300),
                            child: CommonTextfieldWidget(
                              fillColor: Colors.transparent,
                              controller: field.controller,
                              hintText: field.hintText,
                              useBorderOnly: true,
                              borderColor: context.themeDivider,
                              borderRadius: 100,
                              height: 40,
                              maxLines: field.maxLines,
                              requiredField: field.required,
                              keyboardType: field.keyboardType,
                              obscureText: field.obscureText 
                                  ? (_obscureTextStates[field.label] ?? true)
                                  : false,
                              suffixIcon: field.obscureText
                                  ? IconButton(
                                      icon: Icon(
                                        (_obscureTextStates[field.label] ?? true)
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: context.themeIconGrey,
                                        size: 14,
                                      ),
                                      onPressed: () => _toggleObscureText(field.label),
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 44),

                    if (widget.buttonText != null &&
                        widget.onButtonPressed != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 180,
                          child: PrimaryButtonWidget(
                            text: widget.isLoading
                                ? 'Saving...'
                                : widget.buttonText!,
                            onPressed: widget.isLoading
                                ? () {}
                                : widget.onButtonPressed!,
                            backgroundColor: context.themeDark,
                            textColor: context.themeWhite,
                            height: 40,
                            borderRadius: 100,
                            showShadow: false,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            showBorder: false,
                          ),
                        ),
                      ),
                  ] else if (widget.rightSideWidget != null)
                    widget.rightSideWidget!
                  else if (widget.buttonText != null &&
                      widget.onButtonPressed != null) ...[
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: widget.isLoading ? null : widget.onButtonPressed,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            text: widget.buttonText!,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: widget.isLoading
                                ? context.themeDivider
                                : context.themeDark,
                          ),
                          if (widget.isLoading) ...[
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: context.themeDark,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsField {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool required;
  final bool obscureText;
  final int maxLines;

  SettingsField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.required = true,
    this.maxLines = 1,
    this.obscureText = false,
  });
}