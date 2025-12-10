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
        final profileData = {
          'profile_id': userId, 
          'email_address': email,
          'company_name': request.companyName,
          'status': 'unverified', // Initial status
        };

        await networkService.push(
          table: SupabaseTables.jobProfiles,
          data: profileData,
        );
      } on PostgrestException catch (e) {
        debugPrint('Postgrest error during signup: ${e.code} - ${e.message}');
        debugPrint('Details: ${e.details}');
        throw 'Failed to create profile: ${networkService.parseError(e.message, 'Database error')}';
      } catch (e) {
        debugPrint('Error creating profile: $e');
        throw 'Failed to create profile: ${e.toString()}';
      }

      return UserAuthResponse(
        userId: userId,
        email: email,
        companyName: request.companyName,
        accessToken: authResponse.session?.accessToken,
      );
    } on AuthException catch (e) {
      debugPrint('Auth error during signup: ${e.message}');
      final errorMessage = _parseAuthError(e.message);
      throw errorMessage;
    } catch (e) {
      debugPrint('General error during signup: $e');
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('email already registered') ||
          errorStr.contains('already exists') ||
          errorStr.contains('duplicate')) {
        throw 'This email is already registered. Please use a different email or try logging in.';
      }
      if (errorStr.contains('weak password') ||
          errorStr.contains('password too short')) {
        throw 'Password is too weak. Please use at least 6 characters.';
      }
      if (errorStr.contains('invalid email')) {
        throw 'Please enter a valid email address.';
      }
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
        final profiles = await networkService.pull(
          table: SupabaseTables.jobProfiles,
          filters: {'profile_id': userId},
          limit: 1,
        );
        if (profiles.isNotEmpty) {
          companyName = profiles.first['company_name'] as String?;
        }
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
      debugPrint('Auth error during login: ${e.message}');
      final errorMessage = _parseAuthError(e.message);
      throw errorMessage;
    } catch (e) {
      debugPrint('General error during login: $e');
      // Check if it's an AuthApiException or similar
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('invalid') ||
          errorStr.contains('credentials') ||
          errorStr.contains('invalid_credentials') ||
          errorStr.contains('authapiexception')) {
        throw 'Invalid email or password. Please check your credentials and try again.';
      }
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

  Future<bool> isUserVerified() async {
    try {
      final user = getCurrentUser();
      if (user == null) return false;

      final profiles = await networkService.pull(
        table: SupabaseTables.jobProfiles,
        filters: {'profile_id': user.id},
        limit: 1,
      );

      if (profiles.isEmpty) return false;

      final status = profiles.first['status'] as String?;
      return status == 'verified';
    } catch (e) {
      debugPrint('Error checking verification status: $e');
      return false;
    }
  }

  Future<String?> getUserStatus() async {
    try {
      final user = getCurrentUser();
      if (user == null) return null;

      final profiles = await networkService.pull(
        table: SupabaseTables.jobProfiles,
        filters: {'profile_id': user.id},
        limit: 1,
      );

      if (profiles.isEmpty) return null;

      return profiles.first['status'] as String?;
    } catch (e) {
      debugPrint('Error getting user status: $e');
      return null;
    }
  }

  RealtimeChannel subscribeToJobProfilesRealtime({
    void Function(PostgresChangePayload payload)? onInsert,
    void Function(PostgresChangePayload payload)? onUpdate,
    void Function(PostgresChangePayload payload)? onDelete,
    PostgresChangeFilter? filter,
  }) {
    return networkService.subscribeToRealtime(
      table: SupabaseTables.jobProfiles,
      onInsert: onInsert,
      onUpdate: onUpdate,
      onDelete: onDelete,
      filter: filter,
    );
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

