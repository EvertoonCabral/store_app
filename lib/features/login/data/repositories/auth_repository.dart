import 'package:store_app/features/login/data/models/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String email, String senha);
  Future<void> logout(String token);
}
