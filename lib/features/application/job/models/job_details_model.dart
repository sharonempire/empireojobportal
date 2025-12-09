class JobDetailsModel {
  final String? roleOverview;
  final List<String> languages;
  final List<String> keyResponsibilities;
  final List<String> benefits;

  JobDetailsModel({
    this.roleOverview,
    this.languages = const [],
    this.keyResponsibilities = const [],
    this.benefits = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'role_overview': roleOverview,
      'languages': languages,
      'key_responsibilities': keyResponsibilities,
      'benefits': benefits,
    };
  }

  factory JobDetailsModel.fromJson(Map<String, dynamic> json) {
    return JobDetailsModel(
      roleOverview: json['role_overview'] as String?,
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      keyResponsibilities:
          (json['key_responsibilities'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
      benefits: (json['benefits'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  JobDetailsModel copyWith({
    String? roleOverview,
    List<String>? languages,
    List<String>? keyResponsibilities,
    List<String>? benefits,
  }) {
    return JobDetailsModel(
      roleOverview: roleOverview ?? this.roleOverview,
      languages: languages ?? this.languages,
      keyResponsibilities: keyResponsibilities ?? this.keyResponsibilities,
      benefits: benefits ?? this.benefits,
    );
  }
}

