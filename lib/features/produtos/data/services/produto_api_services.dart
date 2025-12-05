import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/clientes/data/models/paged_result.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';

class ProdutoApiServices {
  final HttpClient client;

  ProdutoApiServices(this.client);

  Future<PagedResult<ProdutoEntity>> getAllProdutos() async {
    final result = await client.get('api/Produto');

    final data = client.decode(result) as Map<String, dynamic>;

    return PagedResult.fromJson(
      data,
      (json) => ProdutoEntity.fromJson(json),
    );
  }

  Future<ProdutoEntity> getProdutoById(int id) async {
    final result = await client.get('api/Produto/$id');

    final data = client.decode(result) as Map<String, dynamic>;

    return ProdutoEntity.fromMap(data);
  }

  Future<ProdutoEntity> createProduto(Map<String, dynamic> produtoData) async {
    final result = await client.post('api/Produto', body: produtoData);

    final data = client.decode(result) as Map<String, dynamic>;

    return ProdutoEntity.fromMap(data);
  }

  Future<bool> deleteProduto(int id) async {
    try {
      await client.delete('api/Produto/$id');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ProdutoEntity> updateProduto(
      int id, Map<String, dynamic> produtoData) async {
    final result = await client.put('api/Produto/$id', body: produtoData);

    final data = client.decode(result) as Map<String, dynamic>;

    return ProdutoEntity.fromMap(data);
  }
}
