import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/data/services/produto_api_services.dart';

import 'produto_repository.dart';

class ProdutoRepositoryImpl implements ProdutoRepository {
  final ProdutoApiServices api;

  ProdutoRepositoryImpl(this.api);

  @override
  Future<bool> postProdutos(ProdutoEntity request) {
    throw UnimplementedError();
  }

  @override
  Future<List<ProdutoEntity>> getProdutos() {
    return api.getAllProdutos();
  }
}
