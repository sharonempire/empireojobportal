class JobModel {
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

  JobModel({
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

  JobModel copyWith({
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
    return JobModel(
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