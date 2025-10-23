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

  Future<http.Response> get(String path, {Map<String, dynamic>? query}) async {
    final result = await _client.get(
      _uri(path, query),
      headers: {'Content-type': 'application/json'},
    );
    if (result.statusCode != 200) {
      throw Exception(
          'GET $path falhou (${result.statusCode}): ${result.body}');
    }
    return result;
  }

  dynamic decode(http.Response res) {
    if (res.body.isEmpty) return null;
    return jsonDecode(utf8.decode(res.bodyBytes));
  }
}
