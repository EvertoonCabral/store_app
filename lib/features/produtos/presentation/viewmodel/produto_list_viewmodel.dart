import 'package:flutter/material.dart';
import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository.dart';

class ProdutoListViewmodel extends ChangeNotifier {
  final ProdutoRepository repository;
  final AuthViewModel authViewModel;

  ProdutoListViewmodel(this.repository, this.authViewModel);

  bool isLoading = false;
  String? error;
  List<ProdutoEntity> items = [];
  ProdutoEntity? produtoSelecionado;

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

      items = await repository.getProdutos(token);
    } catch (e) {
      error = 'Erro ao carregar produtos';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<ProdutoEntity?> retornaProdutoPorId(int id) async {
    final token = authViewModel.token;
    if (token == null || token.isEmpty) {
      return null;
    }

    try {
      return await repository.getProdutoById(id, token);
    } catch (e) {
      return null;
    }
  }

  String getNomeProduto(int produtoId) {
    final produto = items.firstWhere(
      (p) => p.id == produtoId,
      orElse: () => ProdutoEntity(
        id: produtoId,
        nome: 'Produto #$produtoId',
        marca: '',
        precoCompra: 0,
        precoVenda: 0,
        descricao: null,
        isAtivo: true,
        dataCadastro: DateTime.now(),
        estoqueId: 0,
      ),
    );
    return produto.nome;
  }
}
