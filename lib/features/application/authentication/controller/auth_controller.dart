import 'dart:convert';

import 'package:empire_job/features/application/authentication/models/auth_state.dart';
import 'package:empire_job/features/data/authentication/auth_repository.dart';
import 'package:empire_job/features/data/authentication/models/auth_models.dart';
import 'package:empire_job/features/data/storage/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final sharedPrefs = ref.watch(sharedPrefsProvider);
  return AuthController(
    authRepository: authRepository,
    sharedPrefs: sharedPrefs,
  );
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final SharedPrefsHelper sharedPrefs;

  AuthController({
    required this.authRepository,
    required this.sharedPrefs,
  }) : super(AuthState.initial()) {
    _checkAuthStatus();
  }

  Future<void> refreshVerificationStatus() async {
    if (state.isAuthenticated && state.userId != null) {
      final isVerified = await authRepository.isUserVerified();
      final status = await authRepository.getUserStatus();
      state = state.copyWith(
        isVerified: isVerified,
        status: status,
      );
    }
  }

  Future<void> _checkAuthStatus() async {
    final isAuthenticatedSupabase = authRepository.isAuthenticated();
    
    if (isAuthenticatedSupabase) {
      final user = authRepository.getCurrentUser();
      if (user != null) {
        final userDetailsJson = sharedPrefs.prefs.getString(SharedPrefsHelper.userDetails);
        String? companyName;
        
        if (userDetailsJson != null) {
          try {
            final userDetails = jsonDecode(userDetailsJson) as Map<String, dynamic>;
            companyName = userDetails['company_name'] as String?;
          } catch (e) {
            debugPrint('Error parsing user details: $e');
          }
        }
        
        final isVerified = await authRepository.isUserVerified();
        final status = await authRepository.getUserStatus();
        
        state = AuthState.authenticated(
          userId: user.id,
          email: user.email ?? '',
          companyName: companyName,
          isVerified: isVerified,
          status: status,
        );
        
        await sharedPrefs.setLoggedIn(true, id: user.id);
        if (userDetailsJson == null) {
          await sharedPrefs.storeUserDetails(data: {
            'id': user.id,
            'email': user.email ?? '',
          });
        }
        return;
      }
    }
    
    final isLoggedInPrefs = sharedPrefs.isLoggedIn();
    if (isLoggedInPrefs && !isAuthenticatedSupabase) {
      await sharedPrefs.setLoggedIn(false, id: '');
    }
    
    state = state.copyWith(isCheckingAuth: false);
  }

  Future<void> signup({
    required String email,
    required String password,
    required String companyName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = SignupRequest(
        email: email,
        password: password,
        companyName: companyName,
      );

      final response = await authRepository.signup(request);

      await sharedPrefs.setLoggedIn(true, id: response.userId);
      await sharedPrefs.storeUserDetails(data: {
        'id': response.userId,
        'email': response.email,
        'company_name': response.companyName,
      });

      state = AuthState.authenticated(
        userId: response.userId,
        email: response.email,
        companyName: response.companyName,
        isVerified: false,
        status: 'unverified',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = LoginRequest(
        email: email,
        password: password,
      );

      final response = await authRepository.login(request);

      await sharedPrefs.setLoggedIn(true, id: response.userId);
      await sharedPrefs.storeUserDetails(data: {
        'id': response.userId,
        'email': response.email,
        'company_name': response.companyName,
      });

      final isVerified = await authRepository.isUserVerified();
      final status = await authRepository.getUserStatus();

      state = AuthState.authenticated(
        userId: response.userId,
        email: response.email,
        companyName: response.companyName,
        isVerified: isVerified,
        status: status,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await authRepository.logout();
      await sharedPrefs.setLoggedIn(false, id: '');
      await sharedPrefs.prefs.remove(SharedPrefsHelper.userDetails);
      await sharedPrefs.prefs.remove(SharedPrefsHelper.userId);

      state = AuthState(
        isLoading: false,
        isCheckingAuth: false,
        isAuthenticated: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }
}



