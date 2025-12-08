import 'package:empire_job/features/presentation/web/dashboard/widgets/job_status_card_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class JobPostingStatus extends StatelessWidget {
  final List<Map<String, dynamic>> jobs = [
    {'title': 'Software Developer', 'date': '3 days ago', 'status': 'Active'},
    {'title': 'Frontend Engineer', 'date': '3 days ago', 'status': 'Draft'},
    {'title': 'HR Executive', 'date': '3 days ago', 'status': 'Active'},
    {'title': 'Software Developer', 'date': '3 days ago', 'status': 'Active'},
    {'title': 'Data Analyst', 'date': '3 days ago', 'status': 'Draft'},
    {'title': 'Software Developer', 'date': '3 days ago', 'status': 'Draft'},
  ];

   JobPostingStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:context.themeWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:context.themeIconGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Job Posting Status',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 24),
          ...jobs.map((job) => JobStatusCard(
            title: job['title'],
            date: job['date'],
            status: job['status'],
          )),
        ],
      ),
    );
  }
}