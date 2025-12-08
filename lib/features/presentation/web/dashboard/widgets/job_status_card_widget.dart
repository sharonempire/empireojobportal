import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class JobStatusCard extends StatelessWidget {
  final String title;
  final String date;
  final String status;

  const JobStatusCard({
    super.key,
    required this.title,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: context.themeLightGrey3,
                child: Icon(
                  Icons.work_outline,
                  size: 20,
                  color: context.themeGrey600,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text: date,
                      fontSize: 9,
                      color: context.themeGrey600,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                height: 24,
                width: 65,
                decoration: BoxDecoration(
                  color: status == 'Active'
                      ? context.themeBlueButton
                      : Colors.red[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: CustomText(
                    text: status,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: status == 'Active'
                        ? context.themeBlueText
                        : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(color: context.themeDivider.withOpacity(.5)),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
