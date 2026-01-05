import 'package:store_app/features/clientes/data/models/paged_result.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';

abstract class ProdutoRepository {
  Future<bool> postProdutos(ProdutoEntity request, String token);
  Future<PagedResult<ProdutoEntity>> getProdutos(String token);
  Future<ProdutoEntity> getProdutoById(int id, String token);
  Future<bool> updateProduto(int id, ProdutoEntity request, String token);
  Future<bool> deleteProduto(int id, String token);
}
