class JobInformationModel {
  final String? jobTitle;
  final String? jobType;
  final String? minExperience;
  final String? maxExperience;
  final String? industryType;
  final String? workMode;

  JobInformationModel({
    this.jobTitle,
    this.jobType,
    this.minExperience,
    this.maxExperience,
    this.industryType,
    this.workMode,
  });

  Map<String, dynamic> toJson() {
    return {
      'job_title': jobTitle,
      'job_type': jobType,
      'min_experience': minExperience,
      'max_experience': maxExperience,
      'industry_type': industryType,
      'work_mode': workMode,
    };
  }

  factory JobInformationModel.fromJson(Map<String, dynamic> json) {
    return JobInformationModel(
      jobTitle: json['job_title'] as String?,
      jobType: json['job_type'] as String?,
      minExperience: json['min_experience'] as String?,
      maxExperience: json['max_experience'] as String?,
      industryType: json['industry_type'] as String?,
      workMode: json['work_mode'] as String?,
    );
  }

  JobInformationModel copyWith({
    String? jobTitle,
    String? jobType,
    String? minExperience,
    String? maxExperience,
    String? industryType,
    String? workMode,
  }) {
    return JobInformationModel(
      jobTitle: jobTitle ?? this.jobTitle,
      jobType: jobType ?? this.jobType,
      minExperience: minExperience ?? this.minExperience,
      maxExperience: maxExperience ?? this.maxExperience,
      industryType: industryType ?? this.industryType,
      workMode: workMode ?? this.workMode,
    );
  }
}

