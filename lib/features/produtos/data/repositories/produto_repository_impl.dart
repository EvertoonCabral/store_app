// lib/features/produtos/data/repositories/produto_repository_impl.dart
import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/data/services/produto_api_services.dart';

import 'produto_repository.dart';

class ProdutoRepositoryImpl implements ProdutoRepository {
  final ProdutoApiServices api;

  ProdutoRepositoryImpl(this.api);

  @override
  Future<bool> postProdutos(ProdutoEntity request, String token) async {
    try {
      await api.createProduto(request.toMap(), token);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateProduto(
      int id, ProdutoEntity request, String token) async {
    try {
      await api.updateProduto(id, request.toMap(), token);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ProdutoEntity>> getProdutos(String token) {
    return api.getAllProdutos(token);
  }

  @override
  Future<ProdutoEntity> getProdutoById(int id, String token) {
    return api.getProdutoById(id, token);
  }

  @override
  Future<bool> deleteProduto(int id, String token) {
    return api.deleteProduto(id, token);
  }
}
