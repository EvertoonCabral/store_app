import 'package:flutter/material.dart';
import 'package:store_app/features/clientes/data/models/paged_result.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository.dart';

class ProdutoListViewmodel extends ChangeNotifier {
  final ProdutoRepository repository;

  ProdutoListViewmodel(this.repository);

  bool isLoading = false;
  String? error;
  PagedResult<ProdutoEntity>? result;

  Future<void> retornaProdutos() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      result = await repository.getProdutos();
    } catch (e) {
      error = 'Erro ao carregar clientes';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
