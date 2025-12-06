import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const _keyIsLoggedIn = "is_logged_in";
  static const userId = "user_id";
  static const userDetails = "user_details";
  static const _keyHasCompletedOnboarding = "has_completed_onboarding";
  static const _keyFinderType = "finder_type";

  final SharedPreferences prefs;

  SharedPrefsHelper(this.prefs);

  Future<void> storeUserDetails({required Map<String, dynamic> data}) async {
    final jsonString = jsonEncode(data);
    await prefs.setString(userDetails, jsonString);
  }

  Future<void> setLoggedIn(bool value, {required String id}) async {
    await prefs.setBool(_keyIsLoggedIn, value);
    await prefs.setString(userId, id);
  }

  bool isLoggedIn() {
    try {
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (error) {
      rethrow;
    } finally {
    }
  }

  Future<void> setOnboardingCompleted(bool value) async {
    await prefs.setBool(_keyHasCompletedOnboarding, value);
  }

  bool hasCompletedOnboarding() {
    try {
      return prefs.getBool(_keyHasCompletedOnboarding) ?? false;
    } catch (error) {
      return false;
    }
  }

  Future<void> setFinderType(String finderType) async {
    await prefs.setString(_keyFinderType, finderType);
  }

  String getFinderType() {
    try {
      return prefs.getString(_keyFinderType) ?? 'course';
    } catch (error) {
      return 'course';
    }
  }

  Future<void> clear() async {
    await prefs.clear();
  }
}

final sharedPrefsProvider = Provider<SharedPrefsHelper>((ref) {
  throw UnimplementedError();
});
