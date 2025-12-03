import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/data/services/produto_api_services.dart';

import 'produto_repository.dart';

class ProdutoRepositoryImpl implements ProdutoRepository {
  final ProdutoApiServices api;

  ProdutoRepositoryImpl(this.api);

  @override
  Future<bool> postProdutos(ProdutoEntity request) async {
    try {
      await api.createProduto(request.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ProdutoEntity>> getProdutos() {
    return api.getAllProdutos();
  }

  @override
  Future<ProdutoEntity> getProdutoById(int id) {
    return api.getProdutoById(id);
  }

  @override
  Future<bool> deleteProduto(int id) {
    return api.deleteProduto(id);
  }
}
