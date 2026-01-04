// lib/features/auth/presentation/viewmodel/auth_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:store_app/features/login/data/repositories/auth_repository_impl.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepositoryImpl _repository;

  AuthViewModel(this._repository);

  bool _isLoading = false;
  String? _error;
  String? _token; // se quiser guardar em memória

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;

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
      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'Erro inesperado: $e';
      notifyListeners();
      return false;
    }
  }
}
