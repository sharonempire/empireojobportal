import 'package:empire_job/features/application/applied_job/models/applied_job_model.dart';

class AppliedJobState {
  final List<AppliedJobModel> appliedJobs;
  final bool isLoading;
  final String? error;

  AppliedJobState({
    List<AppliedJobModel>? appliedJobs,
    this.isLoading = false,
    this.error,
  }) : appliedJobs = appliedJobs ?? const [];

  AppliedJobState copyWith({
    List<AppliedJobModel>? appliedJobs,
    bool? isLoading,
    String? error,
  }) {
    return AppliedJobState(
      appliedJobs: appliedJobs ?? this.appliedJobs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

