import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class TableCellWidget extends StatelessWidget {
  final String text;

  const TableCellWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: CustomText(
        text: text,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}