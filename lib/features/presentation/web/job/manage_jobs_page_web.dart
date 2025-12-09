import 'package:empire_job/features/application/job/controllers/job_provider.dart';
import 'package:empire_job/features/application/job/models/job_model.dart';
import 'package:empire_job/features/presentation/widgets/common_dialog_action_popup_widget.dart';
import 'package:empire_job/features/presentation/widgets/common_navbar.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/responsive_horizontal_scroll.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageJobsPageWeb extends ConsumerStatefulWidget {
  const ManageJobsPageWeb({super.key});

  @override
  ConsumerState<ManageJobsPageWeb> createState() => _ManageJobsPageWebState();
}

class _ManageJobsPageWebState extends ConsumerState<ManageJobsPageWeb> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobProvider.notifier).loadJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobState = ref.watch(jobProvider);

    return Scaffold(
      backgroundColor: context.themeScaffoldCourse,
      body: Column(
        children: [
          const CommonNavbar(),
          Expanded(
            child: ResponsiveHorizontalScroll(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 170,
                    vertical: 65,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Manage Your Posted Jobs with Ease',
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 20),
                          CustomText(
                            text:
                                'View and track all your active, closed, and draft job postings in one place. Monitor performance, check application counts, and make quick updates anytime.',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: context.themeIconGrey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      CustomText(
                        text: 'View Posted Jobs',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 10),
                      Divider(color: context.themeDivider),
                      const SizedBox(height: 10),
                      if (jobState.isLoadingJobs)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                
                      else if (jobState.jobs.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: CustomText(
                              text: 'No jobs posted yet. Create your first job!',
                              fontSize: 16,
                              color: context.themeIconGrey,
                            ),
                          ),
                        )
                      else
                        ..._buildJobListings(context, jobState.jobs),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildJobListings(
      BuildContext context, List<JobModel> jobs) {
    return jobs.map((job) => _buildJobCard(context, job)).toList();
  }

  Widget _buildJobCard(BuildContext context, JobModel job) {
    final isActive = job.status.toLowerCase() == 'active' ||
        job.status.toLowerCase() == 'pending';
    final statusColor = isActive
        ? const Color(0xFF4CAF50)
        : job.status.toLowerCase() == 'closed'
            ? const Color(0xFFE53935)
            : context.themeIconGrey;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.themeDark,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomText(
                  text: job.companyInitial,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: context.themeWhite,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: job.jobTitle ?? 'Untitled Job',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  if (job.location.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    CustomText(
                      text: job.location,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: context.themeIconGrey,
                    ),
                  ],
                  if (job.roleOverview != null && job.roleOverview!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    CustomText(
                      text: job.roleOverview!,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: context.themeIconGrey,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (job.id != null && job.status.toLowerCase() != 'closed') {
                      _showCloseJobDialog(context, ref, job);
                    }
                  },
                  child: CustomText(
                    text: job.status.toUpperCase(),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 20),
                CustomText(
                  text: 'Posted On : ${job.formattedDate}',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: context.themeIconGrey,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Divider(color: context.themeDivider),
        const SizedBox(height: 12),
      ],
    );
  }

  void _showCloseJobDialog(
    BuildContext context,
    WidgetRef ref,
    JobModel job,
  ) {
    CommonDialogWidget.show(
      context: context,
      title: 'Close Job',
      subtitle: 'Are you sure you want to close "${job.jobTitle ?? 'this job'}"?',
      actions: [
        DialogAction(
          text: 'Cancel',
          onPressed: () {
            Navigator.of(context).pop();
          },
          showBorder: true,
        ),
        DialogAction(
          text: 'Close Job',
          onPressed: () async {
            Navigator.of(context).pop();
            try {
              await ref.read(jobProvider.notifier).updateJobStatus(
                    jobId: job.id!,
                    status: 'closed',
                  );
              if (context.mounted) {
                context.showSuccessSnackbar('Job closed successfully');
              }
            } catch (e) {
              if (context.mounted) {
                context.showErrorSnackbar('Failed to close job: ${e.toString()}');
              }
            }
          },
          backgroundColor: context.themeDark,
          textColor: context.themeWhite,
        ),
      ],
    );
  }
}
