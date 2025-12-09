import 'package:empire_job/features/data/authentication/auth_repository.dart';
import 'package:empire_job/features/data/authentication/models/auth_models.dart';
import 'package:empire_job/features/data/storage/shared_preferences.dart';
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

  void _checkAuthStatus() {
    if (authRepository.isAuthenticated()) {
      final user = authRepository.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(
          userId: user.id,
          email: user.email ?? '',
        );
      }
    }
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

      state = AuthState.authenticated(
        userId: response.userId,
        email: response.email,
        companyName: response.companyName,
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
      await sharedPrefs.clear();

      state = AuthState.initial();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }
}

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final String? userId;
  final String? email;
  final String? companyName;

  AuthState({
    required this.isLoading,
    this.error,
    required this.isAuthenticated,
    this.userId,
    this.email,
    this.companyName,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isAuthenticated: false,
    );
  }

  factory AuthState.authenticated({
    required String userId,
    required String email,
    String? companyName,
  }) {
    return AuthState(
      isLoading: false,
      isAuthenticated: true,
      userId: userId,
      email: email,
      companyName: companyName,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    String? userId,
    String? email,
    String? companyName,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      companyName: companyName ?? this.companyName,
    );
  }
}

