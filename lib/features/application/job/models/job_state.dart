import 'package:empire_job/features/application/job/models/job_model.dart';

class JobState {
  final JobModel currentJob;
  final List<JobModel> jobs;
  final bool isLoadingJobs;
  final bool isSubmittingJob;
  final String? error;
  JobState({
    JobModel? currentJob,
    List<JobModel>? jobs,
    this.isLoadingJobs = false,
    this.isSubmittingJob = false,
    this.error,
  })  : currentJob = currentJob ?? JobModel(),
        jobs = jobs ?? const [];

  JobState copyWith({
    JobModel? currentJob,
    List<JobModel>? jobs,
    bool? isLoadingJobs,
    bool? isSubmittingJob,
    String? error,
  }) {
    return JobState(
      currentJob: currentJob ?? this.currentJob,
      jobs: jobs ?? this.jobs,
      isLoadingJobs: isLoadingJobs ?? this.isLoadingJobs,
      isSubmittingJob: isSubmittingJob ?? this.isSubmittingJob,
      error: error,
    );
  }
}