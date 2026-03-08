import 'package:flutter/material.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository.dart';

class ProdutoDetailViewmodel extends ChangeNotifier {
  final ProdutoRepository repository;

  ProdutoDetailViewmodel(this.repository);

  bool isLoading = false;
  String? error;
  ProdutoEntity? produto;

  Future<void> carregarProduto(int? produtoId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      produto = await repository.getProdutoById(produtoId);
    } catch (e) {
      error = 'Erro ao carregar detalhes do produto';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
