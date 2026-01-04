import 'package:store_app/features/login/data/models/login_request.dart';
import 'package:store_app/features/login/data/models/login_response.dart';
import 'package:store_app/features/login/data/service/auth_api_service.dart';

class AuthRepositoryImpl {
  final AuthApiService _api;

  AuthRepositoryImpl(this._api);

  Future<LoginResponse> login(String email, String senha) async {
    final request = LoginRequest(email: email, senha: senha);
    return _api.login(request);
  }
}
