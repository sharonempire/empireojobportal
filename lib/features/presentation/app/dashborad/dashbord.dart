import 'package:empire_job/features/application/applied_job/controllers/applied_job_provider.dart';
import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/features/application/job/controllers/job_provider.dart';
import 'package:empire_job/features/application/job/models/job_model.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/utils/bottonavigationbar.dart';
import 'package:empire_job/shared/utils/responsive.dart';
import 'package:empire_job/shared/widgets/common_app_bar.dart';
import 'package:empire_job/shared/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Dashbord extends ConsumerStatefulWidget {
  const Dashbord({super.key});

  @override
  ConsumerState<Dashbord> createState() => _DashbordState();
}

class _DashbordState extends ConsumerState<Dashbord> {
  @override
  void initState() {
    super.initState();
    // Load jobs and applied jobs when dashboard is opened
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(jobProvider.notifier).loadJobs();
      // Load applied jobs after jobs are loaded
      await ref
          .read(appliedJobProvider.notifier)
          .loadAppliedJobs(waitForJobs: true);
    });
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        context.goNamed('viewJob');
        break;
      case 2:
        context.goNamed('settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final jobState = ref.watch(jobProvider);
    final appliedJobState = ref.watch(appliedJobProvider);

    // Calculate stats from jobs
    final totalJobs = jobState.jobs.length;
    final activeJobs = jobState.jobs
        .where((job) => job.status == 'active')
        .length;
    final totalApplications = appliedJobState.appliedJobs.length;

    return Scaffold(
      backgroundColor: ColorConsts.lightGreyBackground,
      appBar: CommonAppBar(
        showProfile: true,
        profileName: authState.companyName ?? authState.email ?? 'User',
        profileImageUrl: null,
        showNotification: true,
        onNotificationPressed: () {
          context.pushNamed('notifications');
        },
      ),
      body: SafeArea(
        child: jobState.isLoadingJobs
            ? const DashboardShimmer()
            : RefreshIndicator(
                onRefresh: () async {
                  await ref.read(jobProvider.notifier).loadJobs();
                  await ref.read(appliedJobProvider.notifier).loadAppliedJobs();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(context.rSpacing(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Create Job Card
                      _buildCreateJobCard(),
                      SizedBox(height: context.rSpacing(24)),
                      // Stats Row
                      _buildStatsRow(totalJobs, activeJobs, totalApplications),
                      SizedBox(height: context.rSpacing(24)),
                      // Recent Applications
                      _buildRecentApplications(),
                      SizedBox(height: context.rSpacing(24)),
                      // Job Posting Status
                      _buildJobPostingStatus(jobState.jobs),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildCreateJobCard() {
    return Container(
      padding: EdgeInsets.all(context.rSpacing(16)),
      decoration: BoxDecoration(
        color: ColorConsts.white,
        borderRadius: BorderRadius.circular(context.rSpacing(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Create a Job That Attracts the Right Talent',
            fontSize: context.rFontSize(14),
            fontWeight: FontWeight.bold,
            color: ColorConsts.black,
          ),
          SizedBox(height: context.rSpacing(8)),
          CustomText(
            text:
                'Craft a clear and compelling job post to reach qualified candidates. Add details like role, skills, salary, and requirements, and publish it instantly across the portal.',
            fontSize: context.rFontSize(10),
            color: ColorConsts.textColor,
          ),
          SizedBox(height: context.rSpacing(12)),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => context.goNamed('addJob'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: context.rIconSize(12),
                    color: ColorConsts.primaryColor,
                  ),
                  SizedBox(width: context.rSpacing(4)),
                  CustomText(
                    text: 'Post a New Job',
                    fontSize: context.rFontSize(10),
                    fontWeight: FontWeight.w500,
                    color: ColorConsts.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int totalJobs, int activeJobs, int applications) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Jobs Posted',
            totalJobs.toString(),
            Icons.trending_up,
          ),
        ),
        SizedBox(width: context.rSpacing(12)),
        Expanded(
          child: _buildStatCard(
            'Active Jobs',
            activeJobs.toString(),
            Icons.trending_up,
          ),
        ),
        SizedBox(width: context.rSpacing(12)),
        Expanded(
          child: _buildStatCard(
            'Applications',
            applications.toString(),
            Icons.trending_up,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(context.rSpacing(12)),
      decoration: BoxDecoration(
        color: ColorConsts.white,
        borderRadius: BorderRadius.circular(context.rSpacing(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: context.rIconSize(18), color: ColorConsts.black),
          SizedBox(height: context.rSpacing(8)),
          CustomText(
            text: title,
            fontSize: context.rFontSize(10),
            maxLines: 1,
            color: ColorConsts.textColorBlack,
          ),
          SizedBox(height: context.rSpacing(4)),
          CustomText(
            text: value,
            fontSize: context.rFontSize(14),
            fontWeight: FontWeight.bold,
            color: ColorConsts.black,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentApplications() {
    final appliedJobState = ref.watch(appliedJobProvider);
    final applications = appliedJobState.appliedJobs;

    if (appliedJobState.isLoading) {
      return Container(
        padding: EdgeInsets.all(context.rSpacing(16)),
        decoration: BoxDecoration(
          color: ColorConsts.white,
          borderRadius: BorderRadius.circular(context.rSpacing(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(
              width: context.rSpacing(150),
              height: context.rSpacing(16),
              borderRadius: 4,
            ),
            SizedBox(height: context.rSpacing(16)),
            // Shimmer rows
            ...List.generate(5, (index) => Padding(
              padding: EdgeInsets.only(bottom: context.rSpacing(12)),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ShimmerBox(
                      width: double.infinity,
                      height: context.rSpacing(12),
                      borderRadius: 4,
                    ),
                  ),
                  SizedBox(width: context.rSpacing(8)),
                  Expanded(
                    flex: 3,
                    child: ShimmerBox(
                      width: double.infinity,
                      height: context.rSpacing(12),
                      borderRadius: 4,
                    ),
                  ),
                  SizedBox(width: context.rSpacing(8)),
                  Expanded(
                    flex: 2,
                    child: ShimmerBox(
                      width: double.infinity,
                      height: context.rSpacing(12),
                      borderRadius: 4,
                    ),
                  ),
                  SizedBox(width: context.rSpacing(8)),
                  Expanded(
                    flex: 2,
                    child: ShimmerBox(
                      width: double.infinity,
                      height: context.rSpacing(12),
                      borderRadius: 4,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: ColorConsts.white,
        borderRadius: BorderRadius.circular(context.rSpacing(8)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: context.rSpacing(20),
          left: context.rSpacing(15),
          right: context.rSpacing(15),
          bottom: context.rSpacing(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Recent Applications',
              fontSize: context.rFontSize(14),
              fontWeight: FontWeight.bold,
              color: ColorConsts.black,
            ),
            SizedBox(height: context.rSpacing(16)),
            // Table Header
            Container(
              padding: EdgeInsets.symmetric(vertical: context.rSpacing(8)),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: ColorConsts.lightGrey, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomText(
                      text: 'Candidate Name',
                      fontSize: context.rFontSize(10),
                      color: ColorConsts.textColor,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: CustomText(
                      text: 'Job Title',
                      fontSize: context.rFontSize(10),
                      color: ColorConsts.textColor,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomText(
                      text: 'Applied On',
                      fontSize: context.rFontSize(10),
                      color: ColorConsts.textColor,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomText(
                      text: 'Status',
                      fontSize: context.rFontSize(10),
                      color: ColorConsts.textColor,
                    ),
                  ),
                ],
              ),
            ),
            // Table Rows
            if (appliedJobState.isLoading)
              Padding(
                padding: EdgeInsets.all(context.rSpacing(20)),
                child: const Center(
                  child: CircularProgressIndicator(color: ColorConsts.black),
                ),
              )
            else if (applications.isEmpty)
              Padding(
                padding: EdgeInsets.all(context.rSpacing(20)),
                child: Center(
                  child: CustomText(
                    text: 'No applications yet',
                    fontSize: context.rFontSize(12),
                    color: ColorConsts.textColor,
                  ),
                ),
              )
            else
              ...applications.take(10).map((app) => _buildApplicationRow(app)),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationRow(dynamic app) {
    // Handle both Map and AppliedJobModel
    String candidateName;
    String jobTitle;
    String appliedDate;
    String status;

    if (app is Map<String, dynamic>) {
      candidateName = app['name']?.toString() ?? 'Unknown';
      jobTitle = app['job']?.toString() ?? 'Unknown Job';
      appliedDate = app['date']?.toString() ?? 'N/A';
      status = app['status']?.toString() ?? 'Applied';
    } else {
      // It's an AppliedJobModel
      candidateName = app.candidateName;
      jobTitle = app.jobTitle;
      appliedDate = app.formattedAppliedDate;
      status = app.displayStatus;
    }

    Color statusColor;
    switch (status.toLowerCase()) {
      case 'shortlisted':
        statusColor = ColorConsts.colorGreen;
        break;
      case 'applied':
        statusColor = ColorConsts.blue;
        break;
      case 'rejected':
        statusColor = ColorConsts.textColorRed;
        break;
      case 'verified':
        statusColor = ColorConsts.colorGreen;
        break;
      case 'pending':
        statusColor = ColorConsts.blue;
        break;
      default:
        statusColor = ColorConsts.textColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: context.rSpacing(12)),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorConsts.lightGrey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CustomText(
              text: candidateName,
              fontSize: context.rFontSize(8),
              color: ColorConsts.black,
            ),
          ),
          Expanded(
            flex: 3,
            child: CustomText(
              text: jobTitle,
              fontSize: context.rFontSize(8),
              color: ColorConsts.black,
            ),
          ),
          Expanded(
            flex: 2,
            child: CustomText(
              text: appliedDate,
              fontSize: context.rFontSize(8),
              color: ColorConsts.textColor,
            ),
          ),
          Expanded(
            flex: 2,
            child: CustomText(
              text: status,
              fontSize: context.rFontSize(8),
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobPostingStatus(List<JobModel> jobs) {
    // Use actual jobs if available, otherwise show placeholder
    final displayJobs = jobs.isNotEmpty ? jobs.take(3).toList() : <JobModel>[];

    final placeholderJobs = [
      {
        'title': 'Software Developer',
        'date': '12 Nov 2025',
        'status': 'Active',
        'color': ColorConsts.jobpostingColor1,
      },
      {
        'title': 'Frontend Engineer',
        'date': '12 Oct 2025',
        'status': 'Closed',
        'color': ColorConsts.jobpostingColor2,
      },
      {
        'title': 'HR Executive',
        'date': '1 Oct 2025',
        'status': 'Active',
        'color': ColorConsts.jobpostingColor3,
      },
    ];

    return Container(
      margin: EdgeInsets.only(bottom: context.rSpacing(12)),
      padding: EdgeInsets.all(context.rSpacing(12)),
      decoration: BoxDecoration(
        color: ColorConsts.white,
        borderRadius: BorderRadius.circular(context.rSpacing(8)),
        border: Border.all(color: ColorConsts.lightGrey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Job Posting Status',
            fontSize: context.rFontSize(14),
            fontWeight: FontWeight.bold,
            color: ColorConsts.black,
          ),
          SizedBox(height: context.rSpacing(16)),

          if (displayJobs.isEmpty)
            // Show placeholder when no jobs
            ...placeholderJobs.asMap().entries.map((entry) {
              int index = entry.key;
              var job = entry.value;
              return Column(
                children: [
                  _buildJobStatusCardPlaceholder(job),
                  if (index != placeholderJobs.length - 1) ...[
                    SizedBox(height: context.rSpacing(12)),
                    const Divider(color: ColorConsts.lightGrey, thickness: 1),
                    SizedBox(height: context.rSpacing(12)),
                  ],
                ],
              );
            })
          else
            // Show actual jobs
            ...displayJobs.asMap().entries.map((entry) {
              int index = entry.key;
              var job = entry.value;
              return Column(
                children: [
                  _buildJobStatusCardFromModel(job, index),
                  if (index != displayJobs.length - 1) ...[
                    SizedBox(height: context.rSpacing(12)),
                    const Divider(color: ColorConsts.lightGrey, thickness: 1),
                    SizedBox(height: context.rSpacing(12)),
                  ],
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _buildJobStatusCardFromModel(JobModel job, int index) {
    final colors = [
      ColorConsts.jobpostingColor1,
      ColorConsts.jobpostingColor2,
      ColorConsts.jobpostingColor3,
    ];
    final avatarColor = colors[index % colors.length];
    final bool isActive = job.status == 'active' || job.status == 'pending';

    return Row(
      children: [
        // Avatar
        Container(
          width: context.rSpacing(35),
          height: context.rSpacing(35),
          decoration: BoxDecoration(color: avatarColor, shape: BoxShape.circle),
          child: Center(
            child: CustomText(
              text: job.companyInitial,
              fontSize: context.rFontSize(16),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: context.rSpacing(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: job.jobTitle ?? 'Untitled Job',
                fontSize: context.rFontSize(11),
                fontWeight: FontWeight.w600,
                color: ColorConsts.black,
              ),
              SizedBox(height: context.rSpacing(2)),
              CustomText(
                text: job.formattedDate,
                fontSize: context.rFontSize(10),
                color: ColorConsts.textColor,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.rSpacing(12),
            vertical: context.rSpacing(6),
          ),
          decoration: BoxDecoration(
            color: isActive
                ? ColorConsts.colorGreen.withOpacity(0.15)
                : ColorConsts.textColorRed.withOpacity(0.15),
            borderRadius: BorderRadius.circular(context.rSpacing(16)),
          ),
          child: CustomText(
            text: isActive ? 'Active' : 'Closed',
            fontSize: context.rFontSize(10),
            fontWeight: FontWeight.w500,
            color: isActive ? ColorConsts.colorGreen : ColorConsts.textColorRed,
          ),
        ),
      ],
    );
  }

  Widget _buildJobStatusCardPlaceholder(Map<String, dynamic> job) {
    final Color avatarColor = job['color'] as Color;
    final bool isActive = job['status'] == 'Active';

    return Row(
      children: [
        // Avatar
        Container(
          width: context.rSpacing(35),
          height: context.rSpacing(35),
          decoration: BoxDecoration(color: avatarColor, shape: BoxShape.circle),
          child: Center(
            child: CustomText(
              text: job['title']!.toString().substring(0, 1),
              fontSize: context.rFontSize(16),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: context.rSpacing(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: job['title']!.toString(),
                fontSize: context.rFontSize(11),
                fontWeight: FontWeight.w600,
                color: ColorConsts.black,
              ),
              SizedBox(height: context.rSpacing(2)),
              CustomText(
                text: job['date']!.toString(),
                fontSize: context.rFontSize(10),
                color: ColorConsts.textColor,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.rSpacing(12),
            vertical: context.rSpacing(6),
          ),
          decoration: BoxDecoration(
            color: isActive
                ? ColorConsts.colorGreen.withOpacity(0.15)
                : ColorConsts.textColorRed.withOpacity(0.15),
            borderRadius: BorderRadius.circular(context.rSpacing(16)),
          ),
          child: CustomText(
            text: job['status']!.toString(),
            fontSize: context.rFontSize(10),
            fontWeight: FontWeight.w500,
            color: isActive ? ColorConsts.colorGreen : ColorConsts.textColorRed,
          ),
        ),
      ],
    );
  }
}
