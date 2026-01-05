// lib/features/produtos/presentation/viewmodel/produto_list_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:store_app/features/clientes/data/models/paged_result.dart';
import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository.dart';

class ProdutoListViewmodel extends ChangeNotifier {
  final ProdutoRepository repository;
  final AuthViewModel authViewModel;

  ProdutoListViewmodel(this.repository, this.authViewModel);

  bool isLoading = false;
  String? error;
  PagedResult<ProdutoEntity>? result;

  Future<void> retornaProdutos() async {
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

      result = await repository.getProdutos(token);
    } catch (e) {
      error = 'Erro ao carregar produtos';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
