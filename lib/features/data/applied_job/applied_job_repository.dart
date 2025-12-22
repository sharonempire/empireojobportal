import 'package:empire_job/features/application/applied_job/models/applied_job_model.dart';
import 'package:empire_job/features/data/network/network_calls.dart';
import 'package:empire_job/shared/supabase/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appliedJobRepositoryProvider = Provider<AppliedJobRepository>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return AppliedJobRepository(networkService: networkService);
});

class AppliedJobRepository {
  final NetworkService networkService;

  AppliedJobRepository({required this.networkService});

  /// Fetch applied jobs for a specific company/user
  /// This fetches all applied jobs and filters by jobs belonging to the user
  Future<List<AppliedJobModel>> getAppliedJobsByUserId(String userId) async {
    try {
      // Fetch all applied jobs - API already provides candidate_name and job_title
      final appliedJobs = await networkService.pull(
        table: SupabaseTables.appliedJobs,
        orderBy: 'applied_at',
        ascending: false,
      );

      // API already provides candidate_name and job_title, so just map directly
      return appliedJobs
          .map((job) => AppliedJobModel.fromMap(job))
          .toList();
    } catch (e) {
      debugPrint('Error fetching applied jobs: $e');
      rethrow;
    }
  }

  /// Fetch applied jobs for specific job IDs
  Future<List<AppliedJobModel>> getAppliedJobsByJobIds(
    List<String> jobIds,
  ) async {
    try {
      // Fetch all applied jobs and filter by job_id
      final allAppliedJobs = await networkService.pull(
        table: SupabaseTables.appliedJobs,
        orderBy: 'applied_at',
        ascending: false,
      );
      
      // Filter applied jobs where job_id matches one of the provided job IDs
      final filteredJobs = allAppliedJobs.where((appliedJob) {
        final jobId = appliedJob['job_id']?.toString();
        return jobId != null && jobIds.contains(jobId);
      }).toList();

      // API already provides candidate_name and job_title, so just map directly
      return filteredJobs
          .map((job) => AppliedJobModel.fromMap(job))
          .toList();
    } catch (e) {
      debugPrint('Error fetching applied jobs by job IDs: $e');
      rethrow;
    }
  }

  /// Get count of applied jobs
  Future<int> getAppliedJobsCount() async {
    try {
      final appliedJobs = await networkService.pull(
        table: SupabaseTables.appliedJobs,
      );
      return appliedJobs.length;
    } catch (e) {
      debugPrint('Error getting applied jobs count: $e');
      return 0;
    }
  }
}

