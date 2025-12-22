import 'dart:convert';

import 'package:empire_job/features/application/authentication/models/auth_state.dart';
import 'package:empire_job/features/data/authentication/auth_repository.dart';
import 'package:empire_job/features/data/authentication/models/auth_models.dart';
import 'package:empire_job/features/data/storage/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

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
  RealtimeChannel? _verificationChannel;

  AuthController({
    required this.authRepository,
    required this.sharedPrefs,
  }) : super(AuthState.initial()) {
    _checkAuthStatus();
  }

  void _setupVerificationRealtimeSubscription() {
    // Clean up existing subscription if any
    _cleanupVerificationSubscription();

    if (state.isAuthenticated && state.userId != null) {
      debugPrint('Setting up real-time subscription for verification status');
      
      _verificationChannel = authRepository.subscribeToJobProfilesRealtime(
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'profile_id',
          value: state.userId,
        ),
        onUpdate: (payload) {
          debugPrint('Real-time update received for job_profiles: ${payload.newRecord}');
          final newStatus = payload.newRecord['status'] as String?;
          debugPrint('New status from real-time: $newStatus');
          
          // Refresh verification status when update is received
          refreshVerificationStatus();
        },
        onInsert: (payload) {
          debugPrint('Real-time insert received for job_profiles: ${payload.newRecord}');
          // If a new profile is inserted for this user, refresh status
          if (payload.newRecord['profile_id'] == state.userId) {
            refreshVerificationStatus();
          }
        },
      );
      
      debugPrint('Real-time subscription set up successfully');
    }
  }

  void _cleanupVerificationSubscription() {
    if (_verificationChannel != null) {
      debugPrint('Cleaning up real-time verification subscription');
      _verificationChannel?.unsubscribe();
      _verificationChannel = null;
    }
  }

  Future<void> refreshVerificationStatus() async {
    if (state.isAuthenticated && state.userId != null) {
      debugPrint('refreshVerificationStatus: Refreshing for user ${state.userId}');
      final isVerified = await authRepository.isUserVerified();
      final status = await authRepository.getUserStatus();
      debugPrint('refreshVerificationStatus: isVerified=$isVerified, status=$status');
      state = state.copyWith(
        isVerified: isVerified,
        status: status,
      );
      debugPrint('refreshVerificationStatus: State updated, new isVerified=${state.isVerified}');
    } else {
      debugPrint('refreshVerificationStatus: User not authenticated or userId is null');
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
        
        // Set up real-time subscription for verification status
        _setupVerificationRealtimeSubscription();
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
    
    // Set up real-time subscription for verification status
    _setupVerificationRealtimeSubscription();
  } catch (e) {
    state = AuthState(
      isLoading: false,
      isCheckingAuth: false,
      isAuthenticated: false,
      error: e.toString(),
      userId: null,
      email: null,
      companyName: null,
      isVerified: false,
      status: null,
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
      // Save credentials for auto-login
      await sharedPrefs.saveUserCredentials(
        email: email,
        password: password,
      );

      final isVerified = await authRepository.isUserVerified();
      final status = await authRepository.getUserStatus();

      state = AuthState.authenticated(
        userId: response.userId,
        email: response.email,
        companyName: response.companyName,
        isVerified: isVerified,
        status: status,
      );
      
      // Set up real-time subscription for verification status
      _setupVerificationRealtimeSubscription();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is String ? e : e.toString(),
      );
      if (e is String) {
        throw e;
      } else {
        throw e.toString();
      }
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      // Clean up real-time subscription before logout
      _cleanupVerificationSubscription();
      
      await authRepository.logout();
      await sharedPrefs.setLoggedIn(false, id: '');
      await sharedPrefs.prefs.remove(SharedPrefsHelper.userDetails);
      await sharedPrefs.prefs.remove(SharedPrefsHelper.userId);
      await sharedPrefs.clearCredentials();

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
  
  @override
  void dispose() {
    _cleanupVerificationSubscription();
    super.dispose();
  }
}