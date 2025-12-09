import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/features/application/job/models/job_model.dart';
import 'package:empire_job/features/data/job/job_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobListState {
  final List<JobModel> jobs;
  final bool isLoading;
  final String? error;

  JobListState({
    this.jobs = const [],
    this.isLoading = false,
    this.error,
  });

  JobListState copyWith({
    List<JobModel>? jobs,
    bool? isLoading,
    String? error,
  }) {
    return JobListState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class JobListNotifier extends StateNotifier<JobListState> {
  final Ref ref;

  JobListNotifier(this.ref) : super(JobListState());

  Future<void> loadJobs() async {
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

      final jobRepository = ref.read(jobRepositoryProvider);
      final jobs = await jobRepository.getJobsByUserId(userId);

      state = state.copyWith(
        jobs: jobs,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      debugPrint('Error loading jobs: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void refresh() {
    loadJobs();
  }
}

final jobListProvider =
    StateNotifierProvider<JobListNotifier, JobListState>((ref) {
  return JobListNotifier(ref);
});

