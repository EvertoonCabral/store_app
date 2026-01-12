import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';

class ProdutoApiServices {
  final HttpClient client;

  ProdutoApiServices(this.client);

  Future<List<ProdutoEntity>> getAllProdutos(String token) async {
    final result = await client.get(
      'api/Produto',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = client.decode(result);

    final list = data as List<dynamic>;

    return list
        .map((json) => ProdutoEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ProdutoEntity> getProdutoById(int? id, String token) async {
    final result = await client
        .get('api/Produto/$id', headers: {'Authorization': 'Bearer $token'});

    final data = client.decode(result) as Map<String, dynamic>;

    return ProdutoEntity.fromMap(data);
  }

  Future<ProdutoEntity> createProduto(
    Map<String, dynamic> produtoData,
    String token,
  ) async {
    final result = await client.post(
      'api/Produto',
      body: produtoData,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = client.decode(result) as Map<String, dynamic>;
    return ProdutoEntity.fromMap(data);
  }

  Future<bool> deleteProduto(int id, String token) async {
    try {
      await client.delete(
        'api/Produto/$id',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ProdutoEntity> updateProduto(
    int id,
    Map<String, dynamic> produtoData,
    String token,
  ) async {
    final result = await client.put(
      'api/Produto/$id',
      body: produtoData,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = client.decode(result) as Map<String, dynamic>;
    return ProdutoEntity.fromMap(data);
  }
}
