import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class TableHeaderWidget extends StatelessWidget {
  final String text;

  const TableHeaderWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 8),
      child: CustomText(
        text: text,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color:context.themeIconGrey,
      ),
    );
  }
}