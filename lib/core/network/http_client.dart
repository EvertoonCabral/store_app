// lib/core/network/http_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClient {
  HttpClient({required this.baseUrl, required http.Client? client})
      : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse('$baseUrl$path').replace(
      queryParameters: query?.map((k, v) => MapEntry(k, '$v')),
    );
  }

  Map<String, String> _buildHeaders([Map<String, String>? extra]) {
    return {
      'Content-type': 'application/json',
      ...?extra,
    };
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
