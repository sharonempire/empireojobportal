import 'package:empire_job/features/application/applied_job/controllers/applied_job_provider.dart';
import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/features/application/job/controllers/job_provider.dart';
import 'package:empire_job/features/application/settings/controllers/settings_controller.dart';
import 'package:empire_job/features/presentation/web/dashboard/widgets/job_posting_status_widget.dart';
import 'package:empire_job/features/presentation/web/dashboard/widgets/recent_applications_tablw_widget.dart';
import 'package:empire_job/features/presentation/web/dashboard/widgets/stats_card_widget.dart';
import 'package:empire_job/features/presentation/widgets/common_navbar.dart';
import 'package:empire_job/features/presentation/widgets/responsive_horizontal_scroll.dart';
import 'package:empire_job/routes/router_consts.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/utils/snackbar_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardPageWeb extends ConsumerStatefulWidget {
  const DashboardPageWeb({super.key});

  @override
  ConsumerState<DashboardPageWeb> createState() => _DashboardPageWebState();
}

class _DashboardPageWebState extends ConsumerState<DashboardPageWeb> {
  bool _hasLoadedData = false;
  bool _isRefreshing = false;
  bool _hasRefreshedOnLoad = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('Dashboard initState: Starting verification refresh');
      await _refreshVerificationIfNeeded(force: true);
    });
  }

  Future<void> _refreshVerificationIfNeeded({bool force = false}) async {
    if (_isRefreshing) {
      debugPrint('_refreshVerificationIfNeeded: Already refreshing, skipping');
      return;
    }
    
    final authState = ref.read(authControllerProvider);
    debugPrint('_refreshVerificationIfNeeded: force=$force, isAuthenticated=${authState.isAuthenticated}, userId=${authState.userId}, currentIsVerified=${authState.isVerified}');
    
    if (authState.isAuthenticated && authState.userId != null) {
      if (force && !_hasRefreshedOnLoad) {
        _hasRefreshedOnLoad = true;
        debugPrint('_refreshVerificationIfNeeded: Force refresh on page load');
      } else if (!force && authState.isVerified) {
        debugPrint('_refreshVerificationIfNeeded: Skipping refresh - already verified');
        return;
      }
      
      _isRefreshing = true;
      debugPrint('_refreshVerificationIfNeeded: Starting refresh...');
      try {
        await ref.read(authControllerProvider.notifier).refreshVerificationStatus();
        debugPrint('_refreshVerificationIfNeeded: Refresh completed');
      } catch (e) {
        debugPrint('Error refreshing verification status: $e');
      } finally {
        if (mounted) {
          _isRefreshing = false;
        }
      }
    } else {
      debugPrint('_refreshVerificationIfNeeded: User not authenticated or userId is null');
    }
  }

  Future<void> _loadDataIfNeeded(WidgetRef ref) async {
    final authState = ref.read(authControllerProvider);
    if (!authState.isCheckingAuth &&
        authState.isAuthenticated &&
        authState.userId != null &&
        !_hasLoadedData) {
      _hasLoadedData = true;
      await ref.read(jobProvider.notifier).loadJobs();
      await ref.read(appliedJobProvider.notifier).loadAppliedJobs(
            waitForJobs: true,
          );
      ref.read(settingsProvider.notifier).loadCompanyData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadDataIfNeeded(ref);
      if (!_hasRefreshedOnLoad) {
        _refreshVerificationIfNeeded(force: true);
      }
    });
    
    debugPrint('Dashboard build: isVerified=${authState.isVerified}, status=${authState.status}, isAuthenticated=${authState.isAuthenticated}, userId=${authState.userId}');

    // if ( (jobState.isLoadingJobs && jobState.jobs.isEmpty)) {
    //   return Scaffold(
    //     backgroundColor: context.themeScaffoldCourse,
    //     body: Column(
    //       children: [
    //         const CommonNavbar(),
    //         Expanded(
    //           child: Center(
    //             child: CircularProgressIndicator(
    //               color: context.themeDark,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    if (!authState.isVerified && authState.isAuthenticated) {
      return Scaffold(
        backgroundColor: context.themeScaffoldCourse,
        body: Column(
          children: [
            const CommonNavbar(),
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  margin: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: context.themeWhite,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: context.themeDark.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 64,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 24),
                      CustomText(
                        text: 'Account Verification Required',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 16),
                      CustomText(
                        text:
                            'Your account is currently unverified. Please wait for admin verification to access the dashboard and create jobs.',
                        fontSize: 16,
                        textAlign: TextAlign.center,
                        color: context.themeIconGrey,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.go(RouterConsts.settingsPath);
                        },
                        child: const CustomText(
                          text: 'Go to Settings',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return _buildDashboard(context, ref);
  }

  Widget _buildDashboard(BuildContext context, WidgetRef ref) {
    final jobState = ref.watch(jobProvider);
    final appliedJobState = ref.watch(appliedJobProvider);

    final totalJobs = jobState.jobs.length;
    final activeJobs = jobState.jobs.where((job) {
      final status = job.status.toLowerCase();
      return status == 'active';
    }).length;
    final closedJobs = jobState.jobs.where((job) {
      return job.status.toLowerCase() == 'closed';
    }).length;
    final totalApplications = appliedJobState.appliedJobs.length;

    final latestJobs = jobState.jobs.take(10).toList();

    return Scaffold(
      backgroundColor: context.themeScaffoldCourse,
      body: Column(
        children: [
          CommonNavbar(),
          Expanded(
            child: ResponsiveHorizontalScroll(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 70,
                    vertical: 42,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        color: context.themeWhite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text:
                                  'Create a Job That Attracts the Right Talent',
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 8),
                            CustomText(
                              text:
                                  'Craft a clear and compelling job post to reach qualified candidates. Add details like role, skills, salary, and requirements, and publish it instantly across the portal.',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: context.themeIconGrey,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Consumer(
                                builder: (context, ref, _) {
                                  final authState = ref.watch(
                                    authControllerProvider,
                                  );
                                  return TextButton.icon(
                                    onPressed: authState.isVerified
                                        ? () {
                                            context.go(RouterConsts.addJobPath);
                                          }
                                        : () {
                                            context.showErrorSnackbar(
                                              'Please verify your account to create jobs',
                                            );
                                          },
                                    icon: Icon(
                                      Icons.add,
                                      size: 18,
                                      color: authState.isVerified
                                          ? context.themeBlueText
                                          : context.themeIconGrey,
                                    ),
                                    label: CustomText(
                                      text: 'Post a New Job',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: authState.isVerified
                                          ? context.themeBlueText
                                          : context.themeIconGrey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: StatsCard(
                              icon: Icons.trending_up,
                              title: 'Total Jobs Posted',
                              value: totalJobs.toString(),
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: StatsCard(
                              icon: Icons.trending_up,
                              title: 'Active Jobs',
                              value: activeJobs.toString(),
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: StatsCard(
                              icon: Icons.trending_up,
                              title: 'Application Received',
                              value: totalApplications.toString(),
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: StatsCard(
                              icon: Icons.trending_up,
                              title: 'Closed Jobs',
                              value: closedJobs.toString(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: RecentApplicationsTable()),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 2,
                            child: JobPostingStatus(jobs: latestJobs),
                          ),
                        ],
                      ),
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
}
