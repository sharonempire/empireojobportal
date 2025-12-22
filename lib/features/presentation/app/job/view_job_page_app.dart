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

class ViewJobPageApp extends ConsumerStatefulWidget {
  const ViewJobPageApp({super.key});

  @override
  ConsumerState<ViewJobPageApp> createState() => _ViewJobPageAppState();
}

class _ViewJobPageAppState extends ConsumerState<ViewJobPageApp> {
  @override
  void initState() {
    super.initState();
    // Load jobs when page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobProvider.notifier).loadJobs();
    });
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.goNamed('dashboard');
        break;
      case 1:
        // Already on jobs
        break;
      case 2:
        context.goNamed('settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobState = ref.watch(jobProvider);

    return Scaffold(
      backgroundColor: ColorConsts.lightGreyBackground,
      appBar: CommonAppBar(
        showProfile: true,
        profileName: 'Michael Roberts',
        profileImageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
        showNotification: true,
        onNotificationPressed: () {
          context.pushNamed('notifications');
        },
      ),
      body: SafeArea(
        child: jobState.isLoadingJobs
            ? const ViewJobPageShimmer()
            : RefreshIndicator(
                onRefresh: () async {
                  await ref.read(jobProvider.notifier).loadJobs();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(context.rSpacing(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      _buildHeaderSection(),
                      SizedBox(height: context.rSpacing(24)),
                      // View Posted Jobs Section
                      _buildPostedJobsSection(jobState.jobs),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 1,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildHeaderSection() {
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
            text: 'Manage Your Posted Jobs with Ease',
            fontSize: context.rFontSize(14),
            fontWeight: FontWeight.bold,
            color: ColorConsts.black,
          ),
          SizedBox(height: context.rSpacing(8)),
          CustomText(
            text:
                'View and track all your active, closed, and draft job postings in one place. Monitor performance, check application counts, and make quick updates anytime.',
            fontSize: context.rFontSize(12),
            color: ColorConsts.textColor,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildPostedJobsSection(List<JobModel> jobs) {
    return Container(
      padding: EdgeInsets.all(context.rSpacing(16)),
      decoration: BoxDecoration(
        color: ColorConsts.white,
        borderRadius: BorderRadius.circular(context.rSpacing(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'View Posted Jobs',
                fontSize: context.rFontSize(12),
                fontWeight: FontWeight.bold,
                color: ColorConsts.black,
              ),
              GestureDetector(
                onTap: () => context.goNamed('addJob'),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: context.rIconSize(12),
                      color: ColorConsts.primaryColor,
                    ),
                    SizedBox(width: context.rSpacing(4)),
                    CustomText(
                      text: 'Add New',
                      fontSize: context.rFontSize(10),
                      fontWeight: FontWeight.w500,
                      color: ColorConsts.primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: ColorConsts.lightGrey,
            thickness: 1,
            height: context.rSpacing(24),
          ),
          SizedBox(height: context.rSpacing(16)),
          // Job List
          if (jobs.isEmpty)
            ..._getPlaceholderJobs().asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> job = entry.value;
              return Column(
                children: [
                  _buildJobCardPlaceholder(job),
                  if (index != _getPlaceholderJobs().length - 1)
                    Divider(
                      color: ColorConsts.lightGrey,
                      thickness: 1,
                      height: context.rSpacing(24),
                    ),
                ],
              );
            })
          else
            ...jobs.asMap().entries.map((entry) {
              int index = entry.key;
              var job = entry.value;
              return Column(
                children: [
                  _buildJobCard(job),
                  if (index != jobs.length - 1)
                    Divider(
                      color: ColorConsts.lightGrey,
                      thickness: 1,
                      height: context.rSpacing(24),
                    ),
                ],
              );
            }),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getPlaceholderJobs() {
    return [
      {
        'title': 'Data Analyst',
        'company': 'accenture',
        'location': 'Canada',
        'description': 'Amazon is seeking a Cloud Support Ass...',
        'postedDate': '12 Dec 2025',
        'status': 'Active',
      },
      {
        'title': 'Data Analyst',
        'company': 'accenture',
        'location': 'Canada',
        'description': 'Amazon is seeking a Cloud Support Ass...',
        'postedDate': '12 Dec 2025',
        'status': 'Closed',
      },
      {
        'title': 'Data Analyst',
        'company': 'accenture',
        'location': 'Canada',
        'description': 'Amazon is seeking a Cloud Support Ass...',
        'postedDate': '12 Dec 2025',
        'status': 'Active',
      },
    ];
  }

  Widget _buildJobCard(JobModel job) {
    final bool isActive = job.status == 'active' || job.status == 'pending';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Logo
        Container(
          width: context.rSpacing(40),
          height: context.rSpacing(40),
          decoration: const BoxDecoration(
            color: ColorConsts.black,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomText(
              text: job.companyInitial,
              fontSize: context.rFontSize(12),
              fontWeight: FontWeight.bold,
              color: ColorConsts.white,
            ),
          ),
        ),
        SizedBox(width: context.rSpacing(12)),
        // Job Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: job.jobTitle ?? 'Untitled Job',
                fontSize: context.rFontSize(12),
                fontWeight: FontWeight.w600,
                color: ColorConsts.black,
              ),
              SizedBox(height: context.rSpacing(2)),
              CustomText(
                text: job.location.isNotEmpty
                    ? job.location
                    : 'Location not set',
                fontSize: context.rFontSize(10),
                color: ColorConsts.textColor,
              ),
              SizedBox(height: context.rSpacing(4)),
              CustomText(
                text: job.roleOverview ?? 'No description provided',
                fontSize: context.rFontSize(8),
                color: ColorConsts.textColor,
                maxLines: 1,
              ),
            ],
          ),
        ),
        // Status and Date
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              text: isActive ? 'Active' : 'Closed',
              fontSize: context.rFontSize(10),
              fontWeight: FontWeight.w500,
              color: isActive
                  ? ColorConsts.colorGreen
                  : ColorConsts.textColorRed,
            ),
            SizedBox(height: context.rSpacing(4)),
            CustomText(
              text: 'Posted On : ${job.formattedDate}',
              fontSize: context.rFontSize(9),
              color: ColorConsts.textColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildJobCardPlaceholder(Map<String, dynamic> job) {
    final bool isActive = job['status'] == 'Active';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Logo
        Container(
          width: context.rSpacing(40),
          height: context.rSpacing(40),
          decoration: const BoxDecoration(
            color: ColorConsts.black,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomText(
              text: job['company'],
              fontSize: context.rFontSize(6),
              fontWeight: FontWeight.bold,
              color: ColorConsts.white,
            ),
          ),
        ),
        SizedBox(width: context.rSpacing(12)),
        // Job Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: job['title'],
                fontSize: context.rFontSize(14),
                fontWeight: FontWeight.w600,
                color: ColorConsts.black,
              ),
              SizedBox(height: context.rSpacing(2)),
              CustomText(
                text: job['location'],
                fontSize: context.rFontSize(11),
                color: ColorConsts.textColor,
              ),
              SizedBox(height: context.rSpacing(4)),
              CustomText(
                text: job['description'],
                fontSize: context.rFontSize(10),
                color: ColorConsts.textColor,
                maxLines: 1,
              ),
            ],
          ),
        ),
        // Status and Date
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              text: job['status'],
              fontSize: context.rFontSize(12),
              fontWeight: FontWeight.w500,
              color: isActive
                  ? ColorConsts.colorGreen
                  : ColorConsts.textColorRed,
            ),
            SizedBox(height: context.rSpacing(4)),
            CustomText(
              text: 'Posted On : ${job['postedDate']}',
              fontSize: context.rFontSize(9),
              color: ColorConsts.textColor,
            ),
          ],
        ),
      ],
    );
  }
}
