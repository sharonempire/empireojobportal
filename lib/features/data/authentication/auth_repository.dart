import 'package:empire_job/features/data/authentication/models/auth_models.dart';
import 'package:empire_job/features/data/network/network_calls.dart';
import 'package:empire_job/shared/supabase/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return AuthRepository(networkService: networkService);
});

class AuthRepository {
  final NetworkService networkService;

  AuthRepository({required this.networkService});

  Future<UserAuthResponse> signup(SignupRequest request) async {
    try {
      final authResponse = await networkService.auth.signUp(
        email: request.email,
        password: request.password,
      );

      if (authResponse.user == null) {
        throw 'Failed to create user account';
      }

      final userId = authResponse.user!.id;
      final email = authResponse.user!.email ?? request.email;

      try {
        await networkService.push(
          table: SupabaseTables.jobProfiles,
          data: {
            'id': userId, 
            'email_address': email,
            'company_name': request.companyName,
            'created_at': DateTime.now().toIso8601String(),
          },
        );
      } catch (e) {
        throw 'Failed to create profile: ${e.toString()}';
      }

      return UserAuthResponse(
        userId: userId,
        email: email,
        companyName: request.companyName,
        accessToken: authResponse.session?.accessToken,
      );
    } on AuthException catch (e) {
      throw _parseAuthError(e.message);
    } catch (e) {
      throw 'Signup failed: ${e.toString()}';
    }
  }

  Future<UserAuthResponse> login(LoginRequest request) async {
    try {
      final authResponse = await networkService.auth.signInWithPassword(
        email: request.email,
        password: request.password,
      );

      if (authResponse.user == null) {
        throw 'Login failed: User not found';
      }

      final userId = authResponse.user!.id;
      final email = authResponse.user!.email ?? request.email;

      String? companyName;
      try {
        final profile = await networkService.pullById(
          table: SupabaseTables.jobProfiles,
          id: userId,
        );
        companyName = profile?['company_name'] as String?;
      } catch (e) {
        debugPrint('Profile not found for user: $userId');
      }

      return UserAuthResponse(
        userId: userId,
        email: email,
        companyName: companyName,
        accessToken: authResponse.session?.accessToken,
      );
    } on AuthException catch (e) {
      throw _parseAuthError(e.message);
    } catch (e) {
      throw 'Login failed: ${e.toString()}';
    }
  }

  Future<void> logout() async {
    try {
      await networkService.auth.signOut();
    } catch (e) {
      throw 'Logout failed: ${e.toString()}';
    }
  }

  User? getCurrentUser() {
    return networkService.supabase.auth.currentUser;
  }

  bool isAuthenticated() {
    return networkService.isAuthenticated;
  }

  String _parseAuthError(String error) {
    final errorLower = error.toLowerCase();
    if (errorLower.contains('invalid login credentials') ||
        errorLower.contains('invalid email or password') ||
        errorLower.contains('invalid_credentials')) {
      return 'Invalid email or password. Please check your credentials and try again.';
    }
    if (errorLower.contains('email already registered') ||
        errorLower.contains('user already registered') ||
        errorLower.contains('duplicate key') ||
        errorLower.contains('email already exists')) {
      return 'This email is already registered. Please use a different email or try logging in.';
    }
    if (errorLower.contains('weak password') ||
        errorLower.contains('password too short') ||
        errorLower.contains('password should be at least')) {
      return 'Password is too weak. Please use at least 6 characters.';
    }
    if (errorLower.contains('invalid email') ||
        errorLower.contains('email format') ||
        errorLower.contains('malformed email')) {
      return 'Please enter a valid email address.';
    }
    if (errorLower.contains('email not confirmed')) {
      return 'Please verify your email address before logging in.';
    }
    return error;
  }
}

