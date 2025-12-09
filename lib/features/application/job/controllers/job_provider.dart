import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/features/application/job/models/job_model.dart';
import 'package:empire_job/features/application/job/models/job_state.dart';
import 'package:empire_job/features/data/job/job_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class JobNotifier extends StateNotifier<JobState> {
  final Ref ref;

  JobNotifier(this.ref) : super(JobState());

  int get currentStep => state.currentJob.currentStep;
  JobModel get currentJob => state.currentJob;
  List<JobModel> get jobs => state.jobs;
  bool get isLoadingJobs => state.isLoadingJobs;
  bool get isSubmittingJob => state.isSubmittingJob;
  String? get error => state.error;  
  void setJobTitle(String? value) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(jobTitle: value),
    );
  }

  void setJobType(String? value) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(jobType: value),
    );
  }

  void setMinExperience(String? value) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(minExperience: value),
    );
  }

  void setMaxExperience(String? value) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(maxExperience: value),
    );
  }

  void setIndustryType(String? value) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(industryType: value),
    );
  }

  void setWorkMode(String? value) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(workMode: value),
    );
  }

  void setEducation(String? value) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(education: value),
    );
  }

  void setSkills(List<String> skills) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(skills: skills),
    );
  }

  void setRoleOverview(String? value) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(roleOverview: value),
    );
  }

  void setLanguages(List<String> languages) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(languages: languages),
    );
  }

  void setKeyResponsibilities(List<String> responsibilities) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(
        keyResponsibilities: responsibilities,
      ),
    );
  }

  void setBenefits(List<String> benefits) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(benefits: benefits),
    );
  }

  void setCountry(String? value) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(country: value),
    );
  }

  void setStateProvince(String? value) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(stateProvince: value),
    );
  }

  void setCity(String? value) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(city: value),
    );
  }

  void setSalaryRange(double min, double max) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWithFormFields(
        minSalary: min,
        maxSalary: max,
      ),
    );
  }

  void setCurrentStep(int step) {
    state = state.copyWith(
      currentJob: state.currentJob.copyWith(currentStep: step),
    );
  }

  void nextStep() {
    if (state.currentJob.currentStep < 4) {
      state = state.copyWith(
        currentJob: state.currentJob.copyWith(
          currentStep: state.currentJob.currentStep + 1,
        ),
      );
    }
  }

  void previousStep() {
    if (state.currentJob.currentStep > 1) {
      state = state.copyWith(
        currentJob: state.currentJob.copyWith(
          currentStep: state.currentJob.currentStep - 1,
        ),
      );
    }
  }

  void resetJob() {
    state = state.copyWith(
      currentJob: JobModel(),
      error: null,
    );
  }

  Future<void> submitJob() async {
    state = state.copyWith(isSubmittingJob: true, error: null);

    try {
      final authState = ref.read(authControllerProvider);
      final userId = authState.userId;

      if (userId == null) {
        throw 'User not authenticated. Please log in to create a job.';
      }

      final jobRepository = ref.read(jobRepositoryProvider);

      if (state.currentJob.jobTitle == null ||
          state.currentJob.jobTitle!.isEmpty) {
        throw 'Job title is required';
      }
      if (state.currentJob.jobType == null ||
          state.currentJob.jobType!.isEmpty) {
        throw 'Job type is required';
      }
      if (state.currentJob.industryType == null ||
          state.currentJob.industryType!.isEmpty) {
        throw 'Industry type is required';
      }
      if (state.currentJob.workMode == null ||
          state.currentJob.workMode!.isEmpty) {
        throw 'Work mode is required';
      }

      await jobRepository.addJob(
        userId: userId,
        jobModel: state.currentJob,
        status: 'pending',
      );
      resetJob();
      await loadJobs();
      
      state = state.copyWith(isSubmittingJob: false);
    } catch (e) {
      debugPrint('Error submitting job: $e');
      state = state.copyWith(
        isSubmittingJob: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> loadJobs() async {
    state = state.copyWith(isLoadingJobs: true, error: null);

    try {
      final authState = ref.read(authControllerProvider);
      final userId = authState.userId;

      if (userId == null) {
        state = state.copyWith(
          isLoadingJobs: false,
          error: 'User not authenticated',
        );
        return;
      }

      final jobRepository = ref.read(jobRepositoryProvider);
      final jobs = await jobRepository.getJobsByUserId(userId);

      state = state.copyWith(
        jobs: jobs,
        isLoadingJobs: false,
        error: null,
      );
    } catch (e) {
      debugPrint('Error loading jobs: $e');
      state = state.copyWith(
        isLoadingJobs: false,
        error: e.toString(),
      );
    }
  }

  void refreshJobs() {
    loadJobs();
  }
}

final jobProvider = StateNotifierProvider<JobNotifier, JobState>((ref) {
  return JobNotifier(ref);
});
