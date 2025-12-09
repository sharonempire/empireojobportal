import 'dart:convert';
import 'package:empire_job/features/application/job/models/job_model.dart';
import 'package:empire_job/features/data/network/network_calls.dart';
import 'package:empire_job/shared/supabase/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final jobRepositoryProvider = Provider<JobRepository>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return JobRepository(networkService: networkService);
});

class JobRepository {
  final NetworkService networkService;

  JobRepository({required this.networkService});

  Future<String?> getJobProfileId(String userId) async {
    try {
      final profiles = await networkService.pull(
        table: SupabaseTables.jobProfiles,
        filters: {'profile_id': userId},
        limit: 1,
      );

      if (profiles.isEmpty) {
        return null;
      }

      return profiles.first['id'] as String?;
    } catch (e) {
      debugPrint('Error getting job profile id: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addJob({
    required String userId,
    required JobModel jobModel,
    String status = 'pending',
  }) async {
    try {
      final jobProfileId = await getJobProfileId(userId);
      if (jobProfileId == null) {
        throw 'Job profile not found. Please complete your profile setup.';
      }

      final jobInformation = {
        'job_title': jobModel.jobTitle,
        'job_type': jobModel.jobType,
        'min_experience': jobModel.minExperience,
        'max_experience': jobModel.maxExperience,
        'industry_type': jobModel.industryType,
        'work_mode': jobModel.workMode,
      };

      final jobDetails = {
        'role_overview': jobModel.roleOverview,
        'languages': jobModel.languages,
        'key_responsibilities': jobModel.keyResponsibilities,
        'benefits': jobModel.benefits,
      };

      final locationSalaryDetails = {
        'country': jobModel.country,
        'state_province': jobModel.stateProvince,
        'city': jobModel.city,
        'min_salary': jobModel.minSalary,
        'max_salary': jobModel.maxSalary,
      };

      final requiredQualification = {
        'education': jobModel.education,
        'skills': jobModel.skills,
      };

      final jobData = {
        'job_profile_id': jobProfileId,
        'job_information': jsonEncode(jobInformation),
        'job_details': jsonEncode(jobDetails),
        'location_salary_details': jsonEncode(locationSalaryDetails),
        'required_qualification': jsonEncode(requiredQualification),
        'status': status,
      };

      final response = await networkService.push(
        table: SupabaseTables.jobs,
        data: jobData,
      );

      return response;
    } catch (e) {
      debugPrint('Error adding job: $e');
      rethrow;
    }
  }
}

