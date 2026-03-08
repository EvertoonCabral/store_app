import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';

class ProdutoApiServices {
  final HttpClient client;

  ProdutoApiServices(this.client);

  Future<List<ProdutoEntity>> getAllProdutos() async {
    final result = await client.get('api/produto');
    final data = client.decode(result);
    final list = data as List<dynamic>;
    return list
        .map((json) => ProdutoEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ProdutoEntity> getProdutoById(int? id) async {
    final result = await client.get('api/produto/$id');
    final data = client.decode(result) as Map<String, dynamic>;
    return ProdutoEntity.fromMap(data);
  }

  Future<void> createProduto(Map<String, dynamic> produtoData) async {
    final body = Map<String, dynamic>.from(produtoData)
      ..remove('id')
      ..remove('dataCadastro');
    await client.post('api/produto', body: body);
  }

  Future<bool> deleteProduto(int id) async {
    try {
      await client.delete('api/produto/$id');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateProduto(int id, Map<String, dynamic> produtoData) async {
    final body = Map<String, dynamic>.from(produtoData)..remove('dataCadastro');
    await client.put('api/produto/$id', body: body);
  }
}
