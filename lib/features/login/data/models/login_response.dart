class LoginResponse {
  final bool success;
  final String message;
  final String token;

  LoginResponse({
    required this.success,
    required this.message,
    required this.token,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      success: map['success'] as bool,
      message: map['message'] as String? ?? '',
      token: map['data'] as String? ?? '',
    );
  }
}
