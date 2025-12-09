import 'package:empire_job/features/application/job/models/job_model.dart';
import 'package:empire_job/features/presentation/web/dashboard/widgets/job_status_card_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class JobPostingStatus extends StatelessWidget {
  final List<JobModel> jobs;

  const JobPostingStatus({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(35),
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
          const SizedBox(height: 28),
          if (jobs.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomText(
                text: 'No jobs posted yet',
                fontSize: 14,
                color: context.themeIconGrey,
                textAlign: TextAlign.center,
              ),
            )
          else
            ...jobs.map((job) => JobStatusCard(
                  title: job.jobTitle ?? 'Untitled Job',
                  date: job.formattedDate,
                  status: job.status,
                )),
        ],
      ),
    );
  }
}