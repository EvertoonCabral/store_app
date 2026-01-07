import 'package:store_app/features/estoques/data/model/estoque_entity.dart';
import 'package:store_app/core/network/http_client.dart';

class EstoqueApiService {
  final HttpClient client;

  EstoqueApiService({required this.client});

  Future<List<EstoqueEntity>> getAllProdutos(String token) async {
    final result = await client.get(
      'api/Estoque',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = client.decode(result);

    final list = data as List<dynamic>;

    return list
        .map((json) => EstoqueEntity.fromMap(json as Map<String, dynamic>))
        .toList();
  }
}
