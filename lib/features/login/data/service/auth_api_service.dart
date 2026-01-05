// lib/features/auth/data/services/auth_api_service.dart
import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/login/data/models/login_request.dart';
import 'package:store_app/features/login/data/models/login_response.dart';

class AuthApiService {
  final HttpClient _client;

  AuthApiService(this._client);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _client.post(
      'api/auth/login',
      body: request.toMap(),
    );

    final data = _client.decode(response) as Map<String, dynamic>;
    return LoginResponse.fromMap(data);
  }
}
