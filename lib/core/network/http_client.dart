import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:store_app/core/token_store.dart';

class HttpClient {
  HttpClient({
    required this.baseUrl,
    required http.Client? client,
    this.tokenStore,
    this.onUnauthorized,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;
  final TokenStore? tokenStore;

  /// Callback disparado quando a API retorna 401. Use para forçar logout e redirecionar ao login.
  void Function()? onUnauthorized;

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse('$baseUrl$path').replace(
      queryParameters: query?.map((k, v) => MapEntry(k, '$v')),
    );
  }

  Map<String, String> _buildHeaders([Map<String, String>? extra]) {
    final token = tokenStore?.token;
    return {
      'Content-type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      ...?extra,
    };
  }

  void _checkUnauthorized(http.Response result) {
    if (result.statusCode == 401) {
      onUnauthorized?.call();
      throw Exception('Sessão expirada. Faça login novamente.');
    }
  }

  Future<http.Response> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final result = await _client.get(
      _uri(path, query),
      headers: _buildHeaders(headers),
    );
    _checkUnauthorized(result);
    if (result.statusCode != 200) {
      throw Exception(
          'GET $path falhou (${result.statusCode}): ${result.body}');
    }
    return result;
  }

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final result = await _client.post(
      _uri(path),
      headers: _buildHeaders(headers),
      body: jsonEncode(body),
    );
    _checkUnauthorized(result);
    if (result.statusCode != 200 && result.statusCode != 201) {
      throw Exception(
          'POST $path falhou (${result.statusCode}): ${result.body}');
    }
    return result;
  }

  Future<http.Response> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final result = await _client.put(
      _uri(path),
      headers: _buildHeaders(headers),
      body: jsonEncode(body),
    );
    _checkUnauthorized(result);
    if (result.statusCode != 200 && result.statusCode != 204) {
      throw Exception(
          'PUT $path falhou (${result.statusCode}): ${result.body}');
    }
    return result;
  }

  Future<http.Response> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    final result = await _client.delete(
      _uri(path),
      headers: _buildHeaders(headers),
    );
    _checkUnauthorized(result);
    if (result.statusCode != 200 && result.statusCode != 204) {
      throw Exception(
          'DELETE $path falhou (${result.statusCode}): ${result.body}');
    }
    return result;
  }

  dynamic decode(http.Response res) {
    if (res.body.isEmpty) return null;
    return jsonDecode(utf8.decode(res.bodyBytes));
  }
}
