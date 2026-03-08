import 'package:store_app/features/login/data/models/login_response.dart';

/// Contrato da camada de autenticação.
/// O AuthViewModel depende desta interface, não da implementação concreta.
abstract class AuthRepository {
  Future<LoginResponse> login(String email, String senha);
}
