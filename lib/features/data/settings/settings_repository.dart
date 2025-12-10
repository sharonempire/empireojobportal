import 'package:empire_job/features/data/network/network_calls.dart';
import 'package:empire_job/shared/supabase/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final currentUser = networkService.supabase.auth.currentUser;
      if (currentUser?.email == null) {
        throw 'User not authenticated';
      }
      try {
        await networkService.auth.signInWithPassword(
          email: currentUser!.email!,
          password: oldPassword,
        );
      } on AuthException catch (e) {
        debugPrint('Old password verification failed: ${e.message}');
        final errorMessage = e.message.toLowerCase();
        if (errorMessage.contains('invalid') ||
            errorMessage.contains('credentials') ||
            errorMessage.contains('invalid_credentials') ||
            errorMessage.contains('email not confirmed')) {
          throw 'Current password is incorrect. Please check your password and try again.';
        }
        throw 'Current password is incorrect. Please check your password and try again.';
      } catch (e) {
        if (e is String) {
          rethrow;
        }
        final errorStr = e.toString().toLowerCase();
        if (errorStr.contains('invalid') ||
            errorStr.contains('credentials') ||
            errorStr.contains('invalid_credentials') ||
            errorStr.contains('wrong password') ||
            errorStr.contains('authapiexception')) {
          throw 'Current password is incorrect. Please check your password and try again.';
        }
        rethrow;
      }

      await networkService.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      debugPrint('Error changing password: $e');
      if (e.toString().contains('Current password is incorrect') ||
          e.toString().contains('User not authenticated')) {
        rethrow;
      }
      throw 'Failed to change password. Please try again.';
    }
  }
}

