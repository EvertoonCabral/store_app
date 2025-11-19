import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';

class ProdutoApiServices {
  final HttpClient client;

  ProdutoApiServices(this.client);

  Future<List<ProdutoEntity>> getAllProdutos() async {
    final result = await client.get('api/Produto');

    final data = client.decode(result) as List<dynamic>;

    final produtos = data
        .map((item) => ProdutoEntity.fromMap(item as Map<String, dynamic>))
        .toList();

    return produtos;
  }
}
