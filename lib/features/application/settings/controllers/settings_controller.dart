import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/features/application/settings/models/settings_state.dart';
import 'package:empire_job/features/data/settings/settings_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  final Ref ref;

  SettingsNotifier(this.ref) : super(SettingsState(selectedTabIndex: 0));

  void selectTab(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  Future<void> changePassword() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false);
  }

  Future<void> loadCompanyData() async {
    state = state.copyWith(isLoadingCompanyData: true);

    try {
      final authState = ref.read(authControllerProvider);
      final settingsRepository = ref.read(settingsRepositoryProvider);

      final userId = authState.userId;
      if (userId == null) {
        state = state.copyWith(isLoadingCompanyData: false);
        return;
      }

      String? companyName = authState.companyName;
      String? companyEmail = authState.email;

      try {
        final profile = await settingsRepository.loadCompanyProfile(userId);

        if (profile != null) {
          companyName ??= profile['company_name'] as String?;
          companyEmail ??= profile['email_address'] as String?;

          final website = profile['company_website'] as String?;
          final address = profile['company_address'] as String?;

          state = state.copyWith(
            companyName: companyName,
            companyEmail: companyEmail,
            companyWebsite: website,
            companyAddress: address,
            isLoadingCompanyData: false,
          );
        } else {
          state = state.copyWith(
            companyName: companyName,
            companyEmail: companyEmail,
            isLoadingCompanyData: false,
          );
        }
      } catch (e) {
        debugPrint('Error loading profile data: $e');
        state = state.copyWith(
          companyName: companyName,
          companyEmail: companyEmail,
          isLoadingCompanyData: false,
        );
      }
    } catch (e) {
      debugPrint('Error loading company data: $e');
      state = state.copyWith(isLoadingCompanyData: false);
    }
  }

  Future<void> saveCompanyInfo({
    required String website,
    required String address,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final authState = ref.read(authControllerProvider);
      final settingsRepository = ref.read(settingsRepositoryProvider);

      final userId = authState.userId;
      if (userId == null) {
        throw 'User not authenticated';
      }

      await settingsRepository.saveCompanyInfo(
        userId: userId,
        website: website,
        address: address,
      );

      state = state.copyWith(
        companyWebsite: website.trim().isEmpty ? null : website.trim(),
        companyAddress: address.trim().isEmpty ? null : address.trim(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(ref),
);