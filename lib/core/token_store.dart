import 'dart:convert';

class TokenStore {
  String? _token;
  String? _nomeUsuario;
  String? _roleUsuario;
  String? _userId;

  String? get token => _token;
  String get nomeUsuario => _nomeUsuario ?? 'Desconhecido';
  String? get roleUsuario => _roleUsuario;
  String? get userId => _userId;

  void setToken(String? token) {
    _token = token;
    if (token != null && token.isNotEmpty) {
      _decodificarJwt(token);
    }
  }

  void clear() {
    _token = null;
    _nomeUsuario = null;
    _roleUsuario = null;
    _userId = null;
  }

  /// Decodifica o payload do JWT (segunda parte, base64url) para extrair
  /// os claims do usuário sem depender de pacote externo.
  void _decodificarJwt(String token) {
    try {
      final partes = token.split('.');
      if (partes.length != 3) return;

      // Normaliza base64url → base64 (padding + caracteres)
      String payload = partes[1];
      payload = payload.replaceAll('-', '+').replaceAll('_', '/');
      switch (payload.length % 4) {
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }

      final decoded = utf8.decode(base64.decode(payload));
      final claims = jsonDecode(decoded) as Map<String, dynamic>;

      _nomeUsuario =
          claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name']
              as String?;
      _roleUsuario =
          claims['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']
              as String?;
      _userId = claims[
              'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier']
          as String?;
    } catch (_) {
      // Se falhar a decodificação, mantém os valores como null.
    }
  }
}
