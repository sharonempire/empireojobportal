
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class SettingsTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SettingsTabButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? context.themeSettingsMenu : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: CustomText(
          text: label,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: isSelected ?  context.themeBothWhite :context.themeDark,
        ),
      ),
    );
  }
}