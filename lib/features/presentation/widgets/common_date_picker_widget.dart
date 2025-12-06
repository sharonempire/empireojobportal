
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class CommonDatePickerWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool showCalendarIcon;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime)? onDateSelected;

  const CommonDatePickerWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.showCalendarIcon = true,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDatePicker(context),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.themeDivider,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: controller.text.isEmpty ? hintText : controller.text,
              fontSize: 12,
              color: controller.text.isEmpty
                  ?context.themeIconGrey
                  : context.themeDark,
            ),
            if (showCalendarIcon)
              Icon(
                Icons.calendar_today,
                size: 14,
                color:context.themeGrey600,
              ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1980),
      lastDate: lastDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.themeDark,
              onPrimary: context.themeWhite,
              onSurface: context.themeDark,
            ),
          ),
          child: child!,
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
        controller.text =
            '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
        if (onDateSelected != null) {
          onDateSelected!(selectedDate);
        }
      }
    });
  }
}
