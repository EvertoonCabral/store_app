import 'package:store_app/features/produtos/data/models/produto_entity.dart';

abstract class ProdutoRepository {
  Future<bool> postProdutos(ProdutoEntity request);
  Future<List<ProdutoEntity>> getProdutos();
  Future<ProdutoEntity> getProdutoById(int id);
  Future<bool> deleteProduto(int id);
}
