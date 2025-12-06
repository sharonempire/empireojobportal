
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class CommonYearPickerWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime)? onYearSelected;

  const CommonYearPickerWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onYearSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showYearPicker(context),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.themeDivider,
          ),
          borderRadius: BorderRadius.circular(1100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: controller.text.isEmpty ? hintText : controller.text,
              fontSize: 12,
              color: controller.text.isEmpty
                  ? 
                  context.themeIconGrey
                  :context.themeDark,
            ),
          ],
        ),
      ),
    );
  }

  void _showYearPicker(BuildContext context) {
    final currentYear = DateTime.now().year;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: firstDate ?? DateTime(currentYear - 50),
              lastDate: lastDate ?? DateTime(currentYear + 10),
              selectedDate: controller.text.isEmpty
                  ? (initialDate ?? DateTime.now())
                  : DateTime(int.parse(controller.text)),
              onChanged: (DateTime dateTime) {
                controller.text = dateTime.year.toString();
                if (onYearSelected != null) {
                  onYearSelected!(dateTime);
                }
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }
}