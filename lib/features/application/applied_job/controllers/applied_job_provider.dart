import 'package:empire_job/features/application/applied_job/models/applied_job_model.dart';
import 'package:empire_job/features/application/applied_job/models/applied_job_state.dart';
import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/features/application/job/controllers/job_provider.dart';
import 'package:empire_job/features/data/applied_job/applied_job_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppliedJobNotifier extends StateNotifier<AppliedJobState> {
  final Ref ref;

  AppliedJobNotifier(this.ref) : super(AppliedJobState());

  List<AppliedJobModel> get appliedJobs => state.appliedJobs;
  bool get isLoading => state.isLoading;
  String? get error => state.error;

  /// Load applied jobs for the current user's company
  Future<void> loadAppliedJobs({bool waitForJobs = false}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authState = ref.read(authControllerProvider);
      final userId = authState.userId;

      if (userId == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'User not authenticated',
        );
        return;
      }

      final appliedJobRepository = ref.read(appliedJobRepositoryProvider);
      
      // Wait for jobs to load if requested
      if (waitForJobs) {
        final jobState = ref.read(jobProvider);
        if (jobState.isLoadingJobs) {
          // Wait a bit for jobs to finish loading
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
      
      // Get user's jobs to filter applied jobs
      final jobState = ref.read(jobProvider);
      final userJobIds = jobState.jobs.map((job) => job.id ?? '').where((id) => id.isNotEmpty).toList();

      List<AppliedJobModel> appliedJobs;
      
      if (userJobIds.isNotEmpty) {
        // Filter applied jobs by user's job IDs
        appliedJobs = await appliedJobRepository.getAppliedJobsByJobIds(userJobIds);
      } else {
        // If no jobs, fetch all applied jobs (will be empty anyway)
        appliedJobs = await appliedJobRepository.getAppliedJobsByUserId(userId);
      }

      state = state.copyWith(
        appliedJobs: appliedJobs,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      debugPrint('Error loading applied jobs: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh applied jobs
  Future<void> refreshAppliedJobs() async {
    await loadAppliedJobs();
  }

  /// Get total count of applied jobs
  int get totalApplications => state.appliedJobs.length;
}

final appliedJobProvider =
    StateNotifierProvider<AppliedJobNotifier, AppliedJobState>((ref) {
  return AppliedJobNotifier(ref);
});

