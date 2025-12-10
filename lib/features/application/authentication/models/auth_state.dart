class AuthState {
  final bool isLoading;
  final bool isCheckingAuth;
  final String? error;
  final bool isAuthenticated;
  final String? userId;
  final String? email;
  final String? companyName;
  final bool isVerified;
  final String? status;

  AuthState({
    required this.isLoading,
    this.isCheckingAuth = false,
    this.error,
    required this.isAuthenticated,
    this.userId,
    this.email,
    this.companyName,
    this.isVerified = false,
    this.status,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isCheckingAuth: true,
      isAuthenticated: false,
    );
  }

  factory AuthState.authenticated({
    required String userId,
    required String email,
    String? companyName,
    bool isVerified = false,
    String? status,
  }) {
    return AuthState(
      isLoading: false,
      isCheckingAuth: false,
      isAuthenticated: true,
      userId: userId,
      email: email,
      companyName: companyName,
      isVerified: isVerified,
      status: status,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    bool? isCheckingAuth,
    String? error,
    bool? isAuthenticated,
    String? userId,
    String? email,
    String? companyName,
    bool? isVerified,
    String? status,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isCheckingAuth: isCheckingAuth ?? this.isCheckingAuth,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      companyName: companyName ?? this.companyName,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
    );
  }
}