class RequiredQualificationModel {
  final String? education;
  final List<String> skills;

  RequiredQualificationModel({
    this.education,
    this.skills = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'education': education,
      'skills': skills,
    };
  }

  factory RequiredQualificationModel.fromJson(Map<String, dynamic> json) {
    return RequiredQualificationModel(
      education: json['education'] as String?,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  RequiredQualificationModel copyWith({
    String? education,
    List<String>? skills,
  }) {
    return RequiredQualificationModel(
      education: education ?? this.education,
      skills: skills ?? this.skills,
    );
  }
}

