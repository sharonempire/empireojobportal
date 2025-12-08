
import 'package:empire_job/features/application/settings/models/settings_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState(selectedTabIndex: 0));

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




}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);