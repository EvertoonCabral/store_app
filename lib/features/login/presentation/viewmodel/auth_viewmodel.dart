import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:store_app/core/token_store.dart';
import 'package:store_app/features/login/data/repositories/auth_repository.dart';

const _kTokenKey = 'auth_token';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  final TokenStore _tokenStore;
  final FlutterSecureStorage _secureStorage;

  AuthViewModel(this._repository, this._tokenStore)
      : _secureStorage = const FlutterSecureStorage() {
    _restoreToken();
  }

  bool _isLoading = false;
  String? _error;
  String? _token;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  Future<void> _restoreToken() async {
    final saved = await _secureStorage.read(key: _kTokenKey);
    if (saved != null && saved.isNotEmpty) {
      _token = saved;
      _tokenStore.setToken(saved);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String senha) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _repository.login(email, senha);

      if (!result.success) {
        _error =
            result.message.isNotEmpty ? result.message : 'Falha ao autenticar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _token = result.token;
      _tokenStore.setToken(_token);
      _isLoading = false;
      notifyListeners();

      await _secureStorage.write(key: _kTokenKey, value: _token!);

      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'Erro inesperado: $e';
      notifyListeners();
      return false;
    }
  }

  /// Logout iniciado pelo usuário: invalida o token no servidor antes de limpar localmente.
  Future<void> logout() async {
    final currentToken = _token;
    _clearSession();

    if (currentToken != null && currentToken.isNotEmpty) {
      try {
        await _repository.logout(currentToken);
      } catch (_) {
        // Ignora erros de rede no logout — sessão local já foi limpa.
      }
    }
  }

  /// Logout forçado por resposta 401 — apenas limpa a sessão local.
  void forceLogout() {
    _clearSession();
  }

  void _clearSession() {
    _token = null;
    _error = null;
    _tokenStore.clear();
    notifyListeners();
    _secureStorage.delete(key: _kTokenKey);
  }
}
