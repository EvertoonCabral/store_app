import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/features/login/data/repositories/auth_repository.dart';

/// Chave usada para persistir o token no SharedPreferences.
const _kTokenKey = 'auth_token';

class AuthViewModel extends ChangeNotifier {
  /// Depende da INTERFACE [AuthRepository], não da implementação concreta.
  final AuthRepository _repository;

  AuthViewModel(this._repository) {
    _restoreToken();
  }

  bool _isLoading = false;
  String? _error;
  String? _token;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  /// Restaura o token salvo ao iniciar o app.
  Future<void> _restoreToken() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kTokenKey);
    if (saved != null && saved.isNotEmpty) {
      _token = saved;
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
      _isLoading = false;
      notifyListeners();

      // Persiste o token para sobreviver ao restart do app.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kTokenKey, _token!);

      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'Erro inesperado: $e';
      notifyListeners();
      return false;
    }
  }

  /// Limpa o token da memória e do armazenamento local.
  void logout() {
    _token = null;
    _error = null;
    notifyListeners();
    // Remove do storage em background — não bloqueia a UI.
    SharedPreferences.getInstance().then((prefs) => prefs.remove(_kTokenKey));
  }
}
