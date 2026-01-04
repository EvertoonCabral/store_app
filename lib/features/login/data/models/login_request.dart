class LoginRequest {
  final String email;
  final String senha;

  LoginRequest({
    required this.email,
    required this.senha,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'senha': senha,
    };
  }
}
