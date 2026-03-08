import 'package:flutter/material.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository.dart';

class ProdutoListViewmodel extends ChangeNotifier {
  final ProdutoRepository repository;

  ProdutoListViewmodel(this.repository);

  bool isLoading = false;
  String? error;
  List<ProdutoEntity> items = [];
  ProdutoEntity? produtoSelecionado;

  Future<void> cadastrarProduto(ProdutoEntity produto) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await repository.postProdutos(produto);
    } catch (e) {
      error = 'Erro ao cadastrar produto';
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retornaProdutos() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      items = await repository.getProdutos();
    } catch (e) {
      error = 'Erro ao carregar produtos';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<ProdutoEntity?> retornaProdutoPorId(int id) async {
    try {
      return await repository.getProdutoById(id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> deletarProduto(int id) async {
    try {
      final ok = await repository.deleteProduto(id);
      if (ok) {
        items.removeWhere((p) => p.id == id);
        notifyListeners();
      }
      return ok;
    } catch (e) {
      error = 'Erro ao excluir produto';
      notifyListeners();
      return false;
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
