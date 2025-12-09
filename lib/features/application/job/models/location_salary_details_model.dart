class LocationSalaryDetailsModel {
  final String? country;
  final String? stateProvince;
  final String? city;
  final double minSalary;
  final double maxSalary;

  LocationSalaryDetailsModel({
    this.country,
    this.stateProvince,
    this.city,
    this.minSalary = 0,
    this.maxSalary = 100000,
  });

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'state_province': stateProvince,
      'city': city,
      'min_salary': minSalary,
      'max_salary': maxSalary,
    };
  }

  factory LocationSalaryDetailsModel.fromJson(Map<String, dynamic> json) {
    return LocationSalaryDetailsModel(
      country: json['country'] as String?,
      stateProvince: json['state_province'] as String?,
      city: json['city'] as String?,
      minSalary: (json['min_salary'] as num?)?.toDouble() ?? 0,
      maxSalary: (json['max_salary'] as num?)?.toDouble() ?? 100000,
    );
  }

  LocationSalaryDetailsModel copyWith({
    String? country,
    String? stateProvince,
    String? city,
    double? minSalary,
    double? maxSalary,
  }) {
    return LocationSalaryDetailsModel(
      country: country ?? this.country,
      stateProvince: stateProvince ?? this.stateProvince,
      city: city ?? this.city,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
    );
  }

  String get formattedLocation {
    if (city != null && country != null) {
      return '$city, $country';
    }
    return country ?? city ?? '';
  }
}

