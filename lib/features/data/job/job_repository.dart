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

  Future<int?> getJobProfileId(String userId) async {
    try {
      final profiles = await networkService.pull(
        table: SupabaseTables.jobProfiles,
        filters: {'profile_id': userId},
        limit: 1,
      );

      if (profiles.isEmpty) {
        return null;
      }

      final id = profiles.first['id'];
      if (id is int) {
        return id;
      } else if (id is String) {
        return int.tryParse(id);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting job profile id: $e');
      rethrow;
    }
  }

  Future<JobModel> addJob({
    required String userId,
    required JobModel jobModel,
    String status = 'pending',
  }) async {
    try {
      final jobProfileId = await getJobProfileId(userId);
      if (jobProfileId == null) {
        throw 'Job profile not found. Please complete your profile setup.';
      }

      final jobData = jobModel.copyWith(
        jobProfileId: jobProfileId,
        status: status,
      ).toJson();

      final response = await networkService.push(
        table: SupabaseTables.jobs,
        data: jobData,
      );

      return JobModel.fromMap(response);
    } catch (e) {
      debugPrint('Error adding job: $e');
      rethrow;
    }
  }

  Future<List<JobModel>> getJobsByUserId(String userId) async {
    try {
      final jobProfileId = await getJobProfileId(userId);
      if (jobProfileId == null) {
        return [];
      }

      final jobs = await networkService.pull(
        table: SupabaseTables.jobs,
        filters: {'job_profile_id': jobProfileId},
        orderBy: 'created_at',
        ascending: false,
      );

      return jobs.map((job) => JobModel.fromMap(job)).toList();
    } catch (e) {
      debugPrint('Error fetching jobs: $e');
      rethrow;
    }
  }
}

