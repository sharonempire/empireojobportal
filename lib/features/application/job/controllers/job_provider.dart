import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/features/application/job/models/job_model.dart';
import 'package:empire_job/features/data/job/job_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobNotifier extends StateNotifier<JobModel> {
  final Ref ref;

  JobNotifier(this.ref) : super(JobModel());

  int get currentStep => state.currentStep;

  void setJobTitle(String? value) {
    state = state.copyWith(jobTitle: value);
  }

  void setJobType(String? value) {
    state = state.copyWith(jobType: value);
  }

  void setMinExperience(String? value) {
    state = state.copyWith(minExperience: value);
  }

  void setMaxExperience(String? value) {
    state = state.copyWith(maxExperience: value);
  }

  void setIndustryType(String? value) {
    state = state.copyWith(industryType: value);
  }

  void setWorkMode(String? value) {
    state = state.copyWith(workMode: value);
  }

  void setEducation(String? value) {
    state = state.copyWith(education: value);
  }

  void setSkills(List<String> skills) {
    state = state.copyWith(skills: skills);
  }

  void setRoleOverview(String? value) {
    state = state.copyWith(roleOverview: value);
  }

  void setLanguages(List<String> languages) {
    state = state.copyWith(languages: languages);
  }

  void setKeyResponsibilities(List<String> responsibilities) {
    state = state.copyWith(keyResponsibilities: responsibilities);
  }

  void setBenefits(List<String> benefits) {
    state = state.copyWith(benefits: benefits);
  }

  void setCountry(String? value) {
    state = state.copyWith(country: value);
  }

  void setStateProvince(String? value) {
    state = state.copyWith(stateProvince: value);
  }

  void setCity(String? value) {
    state = state.copyWith(city: value);
  }

  void setSalaryRange(double min, double max) {
    state = state.copyWith(minSalary: min, maxSalary: max);
  }

  void setCurrentStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 4) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void reset() {
    state = JobModel();
  }

  Future<void> submitJob() async {
    try {
      final authState = ref.read(authControllerProvider);
      final userId = authState.userId;

      if (userId == null) {
        throw 'User not authenticated. Please log in to create a job.';
      }

      final jobRepository = ref.read(jobRepositoryProvider);

      if (state.jobTitle == null || state.jobTitle!.isEmpty) {
        throw 'Job title is required';
      }
      if (state.jobType == null || state.jobType!.isEmpty) {
        throw 'Job type is required';
      }
      if (state.industryType == null || state.industryType!.isEmpty) {
        throw 'Industry type is required';
      }
      if (state.workMode == null || state.workMode!.isEmpty) {
        throw 'Work mode is required';
      }

      await jobRepository.addJob(
        userId: userId,
        jobModel: state,
        status: 'pending', 
      );

      reset();
    } catch (e) {
      debugPrint('Error submitting job: $e');
      rethrow;
    }
  }
}

final jobProvider = StateNotifierProvider<JobNotifier, JobModel>((ref) {
  return JobNotifier(ref);
});

