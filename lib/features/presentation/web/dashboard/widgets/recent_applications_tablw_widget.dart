import 'package:empire_job/features/application/applied_job/controllers/applied_job_provider.dart';
import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/features/application/job/controllers/job_provider.dart';
import 'package:empire_job/features/presentation/web/dashboard/widgets/status_cell_widget.dart';
import 'package:empire_job/features/presentation/web/dashboard/widgets/table_cell_widget.dart';
import 'package:empire_job/features/presentation/web/dashboard/widgets/table_header_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentApplicationsTable extends ConsumerStatefulWidget {
  const RecentApplicationsTable({super.key});

  @override
  ConsumerState<RecentApplicationsTable> createState() =>
      _RecentApplicationsTableState();
}

class _RecentApplicationsTableState
    extends ConsumerState<RecentApplicationsTable> {
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadDataIfNeeded();
    });
  }

  Future<void> _loadDataIfNeeded() async {
    if (_hasLoadedData) return;
    
    final authState = ref.read(authControllerProvider);
    if (authState.isCheckingAuth || !authState.isAuthenticated || authState.userId == null) {
      return; 
    }
    
    final appliedJobState = ref.read(appliedJobProvider);
    if (appliedJobState.appliedJobs.isNotEmpty && !appliedJobState.isLoading) {
      _hasLoadedData = true;
      return;
    }

    _hasLoadedData = true;

    final jobState = ref.read(jobProvider);
    if (jobState.jobs.isEmpty && !jobState.isLoadingJobs) {
      await ref.read(jobProvider.notifier).loadJobs();
    }

    if (jobState.isLoadingJobs) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Load applied jobs
    await ref.read(appliedJobProvider.notifier).loadAppliedJobs(
          waitForJobs: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final appliedJobState = ref.watch(appliedJobProvider);
    final applications = appliedJobState.appliedJobs;

    if (!_hasLoadedData &&
        !authState.isCheckingAuth &&
        authState.isAuthenticated &&
        authState.userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _loadDataIfNeeded();
      });
    }

    return Container(
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: context.themeWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.themeIconGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Recent Applications',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                // Fixed header
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(1.5),
                    3: FlexColumnWidth(1.5),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableHeaderWidget('Candidate Name'),
                        TableHeaderWidget('Job Title'),
                        TableHeaderWidget('Applied On'),
                        TableHeaderWidget('Status'),
                      ],
                    ),
                  ],
                ),
                Divider(color: context.themeDivider.withOpacity(.5)),
                // Scrollable content
                if (appliedJobState.isLoading)
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: context.themeDark,
                      ),
                    ),
                  )
                else if (applications.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                      child: CustomText(
                        text: 'No applications yet',
                        fontSize: 14,
                        color: context.themeIconGrey,
                      ),
                    ),
                  )
                else
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 500),
                    child: SingleChildScrollView(
                      child: Column(
                        children: applications.map((app) {
                          return Column(
                            children: [
                              Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(2),
                                  2: FlexColumnWidth(1.5),
                                  3: FlexColumnWidth(1.5),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      TableCellWidget(app.candidateName),
                                      TableCellWidget(app.jobTitle),
                                      TableCellWidget(app.formattedAppliedDate),
                                      StatusCell(app.displayStatus),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                color: context.themeDivider.withOpacity(0.5),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
