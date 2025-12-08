import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobData {
  String? jobTitle;
  String? jobType; 
  String? minExperience;
  String? maxExperience;
  String? industryType;
  String? workMode; 
  String? education;
  List<String> skills;

  String? roleOverview;
  List<String> languages;
  List<String> keyResponsibilities;
  List<String> benefits;

  String? country;
  String? stateProvince;
  String? city;
  double minSalary;
  double maxSalary;
  int currentStep;

  JobData({
    this.jobTitle,
    this.jobType,
    this.minExperience,
    this.maxExperience,
    this.industryType,
    this.workMode,
    this.education,
    this.skills = const [],
    this.roleOverview,
    this.languages = const [],
    this.keyResponsibilities = const [],
    this.benefits = const [],
    this.country,
    this.stateProvince,
    this.city,
    this.minSalary = 0,
    this.maxSalary = 100000,
    this.currentStep = 1,
  });

  JobData copyWith({
    String? jobTitle,
    String? jobType,
    String? minExperience,
    String? maxExperience,
    String? industryType,
    String? workMode,
    String? education,
    List<String>? skills,
    String? roleOverview,
    List<String>? languages,
    List<String>? keyResponsibilities,
    List<String>? benefits,
    String? country,
    String? stateProvince,
    String? city,
    double? minSalary,
    double? maxSalary,
    int? currentStep,
  }) {
    return JobData(
      jobTitle: jobTitle ?? this.jobTitle,
      jobType: jobType ?? this.jobType,
      minExperience: minExperience ?? this.minExperience,
      maxExperience: maxExperience ?? this.maxExperience,
      industryType: industryType ?? this.industryType,
      workMode: workMode ?? this.workMode,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      roleOverview: roleOverview ?? this.roleOverview,
      languages: languages ?? this.languages,
      keyResponsibilities: keyResponsibilities ?? this.keyResponsibilities,
      benefits: benefits ?? this.benefits,
      country: country ?? this.country,
      stateProvince: stateProvince ?? this.stateProvince,
      city: city ?? this.city,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

class JobNotifier extends StateNotifier<JobData> {
  JobNotifier() : super(JobData());

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
    state = JobData();
  }

  Future<void> submitJob() async {
  }
}

final jobProvider = StateNotifierProvider<JobNotifier, JobData>((ref) {
  return JobNotifier();
});

