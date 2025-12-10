import 'dart:convert';
import 'package:empire_job/features/application/job/models/job_details_model.dart';
import 'package:empire_job/features/application/job/models/job_information_model.dart';
import 'package:empire_job/features/application/job/models/location_salary_details_model.dart';
import 'package:empire_job/features/application/job/models/required_qualification_model.dart';

class JobModel {
  final String? id;
  final int? jobProfileId;
  final JobInformationModel? jobInformation;
  final JobDetailsModel? jobDetails;
  final LocationSalaryDetailsModel? locationSalaryDetails;
  final RequiredQualificationModel? requiredQualification;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  int currentStep;

  JobModel({
    this.id,
    this.jobProfileId,
    this.jobInformation,
    this.jobDetails,
    this.locationSalaryDetails,
    this.requiredQualification,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
    this.currentStep = 1,
  });

  String? get jobTitle => jobInformation?.jobTitle;
  String? get jobType => jobInformation?.jobType;
  String? get minExperience => jobInformation?.minExperience;
  String? get maxExperience => jobInformation?.maxExperience;
  String? get industryType => jobInformation?.industryType;
  String? get workMode => jobInformation?.workMode;

  String? get roleOverview => jobDetails?.roleOverview;
  List<String> get languages => jobDetails?.languages ?? [];
  List<String> get keyResponsibilities => jobDetails?.keyResponsibilities ?? [];
  List<String> get benefits => jobDetails?.benefits ?? [];

  String? get country => locationSalaryDetails?.country;
  String? get stateProvince => locationSalaryDetails?.stateProvince;
  String? get city => locationSalaryDetails?.city;
  double get minSalary => locationSalaryDetails?.minSalary ?? 0;
  double get maxSalary => locationSalaryDetails?.maxSalary ?? 100000;
  String get location => locationSalaryDetails?.formattedLocation ?? '';

  String? get education => requiredQualification?.education;
  List<String> get skills => requiredQualification?.skills ?? [];

  String get formattedDate {
    if (createdAt == null) return 'N/A';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${createdAt!.day} ${months[createdAt!.month - 1]} ${createdAt!.year}';
  }

  String get companyInitial {
    if (jobTitle == null || jobTitle!.isEmpty) return 'J';
    return jobTitle![0].toUpperCase();
  }
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (jobProfileId != null) 'job_profile_id': jobProfileId,
      'job_information': jobInformation?.toJson(),
      'job_details': jobDetails?.toJson(),
      'location_salary_details': locationSalaryDetails?.toJson(),
      'required_qualification': requiredQualification?.toJson(),
      'status': status,
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic>? parseJsonField(dynamic field) {
      if (field == null) return null;
      if (field is Map<String, dynamic>) return field;
      if (field is Map) {
        return Map<String, dynamic>.from(field);
      }
      if (field is String) {
        try {
          final decoded = jsonDecode(field);
          if (decoded is Map) {
            return Map<String, dynamic>.from(decoded);
          }
          return null;
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    final jobInformationJson = parseJsonField(map['job_information']);
    final jobDetailsJson = parseJsonField(map['job_details']);
    final locationSalaryDetailsJson =
        parseJsonField(map['location_salary_details']);
    final requiredQualificationJson =
        parseJsonField(map['required_qualification']);

    DateTime? createdAt;
    if (map['created_at'] != null) {
      try {
        createdAt = DateTime.parse(map['created_at'].toString());
      } catch (e) {
        createdAt = null;
      }
    }

    DateTime? updatedAt;
    if (map['updated_at'] != null) {
      try {
        updatedAt = DateTime.parse(map['updated_at'].toString());
      } catch (e) {
        updatedAt = null;
      }
    }

    return JobModel(
      id: map['id']?.toString(),
      jobProfileId: map['job_profile_id'] is int
          ? map['job_profile_id'] as int
          : (map['job_profile_id'] is String
              ? int.tryParse(map['job_profile_id'])
              : null),
      jobInformation: jobInformationJson != null
          ? JobInformationModel.fromJson(jobInformationJson)
          : null,
      jobDetails: jobDetailsJson != null
          ? JobDetailsModel.fromJson(jobDetailsJson)
          : null,
      locationSalaryDetails: locationSalaryDetailsJson != null
          ? LocationSalaryDetailsModel.fromJson(locationSalaryDetailsJson)
          : null,
      requiredQualification: requiredQualificationJson != null
          ? RequiredQualificationModel.fromJson(requiredQualificationJson)
          : null,
      status: map['status']?.toString() ?? 'pending',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  JobModel copyWith({
    String? id,
    int? jobProfileId,
    JobInformationModel? jobInformation,
    JobDetailsModel? jobDetails,
    LocationSalaryDetailsModel? locationSalaryDetails,
    RequiredQualificationModel? requiredQualification,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? currentStep,
  }) {
    return JobModel(
      id: id ?? this.id,
      jobProfileId: jobProfileId ?? this.jobProfileId,
      jobInformation: jobInformation ?? this.jobInformation,
      jobDetails: jobDetails ?? this.jobDetails,
      locationSalaryDetails: locationSalaryDetails ?? this.locationSalaryDetails,
      requiredQualification: requiredQualification ?? this.requiredQualification,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  JobModel copyWithFormFields({
    String? jobTitle,
    String? jobType,
    String? minExperience,
    String? maxExperience,
    String? industryType,
    String? workMode,
    String? roleOverview,
    List<String>? languages,
    List<String>? keyResponsibilities,
    List<String>? benefits,
    String? country,
    String? stateProvince,
    String? city,
    double? minSalary,
    double? maxSalary,
    String? education,
    List<String>? skills,
    int? currentStep,
  }) {
    return copyWith(
      jobInformation: jobInformation?.copyWith(
            jobTitle: jobTitle,
            jobType: jobType,
            minExperience: minExperience,
            maxExperience: maxExperience,
            industryType: industryType,
            workMode: workMode,
          ) ??
          (jobTitle != null ||
                  jobType != null ||
                  minExperience != null ||
                  maxExperience != null ||
                  industryType != null ||
                  workMode != null
              ? JobInformationModel(
                  jobTitle: jobTitle,
                  jobType: jobType,
                  minExperience: minExperience,
                  maxExperience: maxExperience,
                  industryType: industryType,
                  workMode: workMode,
                )
              : null),
      jobDetails: jobDetails?.copyWith(
            roleOverview: roleOverview,
            languages: languages,
            keyResponsibilities: keyResponsibilities,
            benefits: benefits,
          ) ??
          (roleOverview != null ||
                  languages != null ||
                  keyResponsibilities != null ||
                  benefits != null
              ? JobDetailsModel(
                  roleOverview: roleOverview,
                  languages: languages ?? [],
                  keyResponsibilities: keyResponsibilities ?? [],
                  benefits: benefits ?? [],
                )
              : null),
      locationSalaryDetails: locationSalaryDetails?.copyWith(
            country: country,
            stateProvince: stateProvince,
            city: city,
            minSalary: minSalary,
            maxSalary: maxSalary,
          ) ??
          (country != null ||
                  stateProvince != null ||
                  city != null ||
                  minSalary != null ||
                  maxSalary != null
              ? LocationSalaryDetailsModel(
                  country: country,
                  stateProvince: stateProvince,
                  city: city,
                  minSalary: minSalary ?? 0,
                  maxSalary: maxSalary ?? 100000,
                )
              : null),
      requiredQualification: requiredQualification?.copyWith(
            education: education,
            skills: skills,
          ) ??
          (education != null || skills != null
              ? RequiredQualificationModel(
                  education: education,
                  skills: skills ?? [],
                )
              : null),
      currentStep: currentStep,
    );
  }
}
