import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/estoques/data/model/estoque_create_dto.dart';
import 'package:store_app/features/estoques/data/model/estoque_entity.dart';

class EstoqueApiService {
  final HttpClient client;

  EstoqueApiService(this.client);

  Future<List<EstoqueEntity>> getAllEstoques(String token) async {
    final result = await client.get(
      'api/Estoque',
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = client.decode(result);
    final list = data as List<dynamic>;

    return list
        .map((json) => EstoqueEntity.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> criarEstoque(String token, EstoqueCreateDto request) async {
    await client.post(
      'api/Estoque',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: request.toMap(),
    );
  }
}
