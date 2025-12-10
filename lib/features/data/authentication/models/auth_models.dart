class SignupRequest {
  final String email;
  final String password;
  final String companyName;

  SignupRequest({
    required this.email,
    required this.password,
    required this.companyName,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'company_name': companyName,
    };
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class UserAuthResponse {
  final String userId;
  final String email;
  final String? companyName;
  final String? accessToken;

  UserAuthResponse({
    required this.userId,
    required this.email,
    this.companyName,
    this.accessToken,
  });

  factory UserAuthResponse.fromJson(Map<String, dynamic> json) {
    return UserAuthResponse(
      userId: json['id'] ?? json['user_id'] ?? '',
      email: json['email'] ?? '',
      companyName: json['company_name'],
      accessToken: json['access_token'],
    );
  }
}

