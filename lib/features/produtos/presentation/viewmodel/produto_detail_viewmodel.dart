import 'package:flutter/material.dart';
import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository.dart';

class ProdutoDetailViewmodel extends ChangeNotifier {
  final ProdutoRepository repository;
  final AuthViewModel authViewModel;

  ProdutoDetailViewmodel(this.repository, this.authViewModel);

  bool isLoading = false;
  String? error;
  ProdutoEntity? produto;

  Future<void> carregarProduto(int? produtoId) async {
    final token = authViewModel.token;

    if (token == null || token.isEmpty) {
      error = 'Usuário não autenticado';
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      produto = await repository.getProdutoById(produtoId, token);
    } catch (e) {
      error = 'Erro ao carregar detalhes do produto';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
