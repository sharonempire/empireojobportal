import 'package:empire_job/features/data/network/network_calls.dart';
import 'package:empire_job/shared/supabase/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return SettingsRepository(networkService: networkService);
});

class SettingsRepository {
  final NetworkService networkService;

  SettingsRepository({required this.networkService});

  Future<Map<String, dynamic>?> loadCompanyProfile(String userId) async {
    try {
      final profiles = await networkService.pull(
        table: SupabaseTables.jobProfiles,
        filters: {'profile_id': userId},
        limit: 1,
      );

      if (profiles.isEmpty) {
        return null;
      }

      return profiles.first;
    } catch (e) {
      debugPrint('Error loading company profile: $e');
      rethrow;
    }
  }

  Future<void> saveCompanyInfo({
    required String userId,
    required String website,
    required String address,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'company_website': website.trim().isEmpty ? null : website.trim(),
        'company_address': address.trim().isEmpty ? null : address.trim(),
      };

      await networkService.supabase
          .from(SupabaseTables.jobProfiles)
          .update(updateData)
          .eq('profile_id', userId);
    } catch (e) {
      debugPrint('Error saving company info: $e');
      rethrow;
    }
  }
}

