import 'package:flutter/material.dart';
import 'package:store_app/features/estoques/data/model/estoque_detail_entity.dart';
import 'package:store_app/features/estoques/data/model/item_estoque_entity.dart';
import 'package:store_app/features/estoques/data/repositories/estoque_repository.dart';
import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository.dart';

class EstoqueDetailViewmodel extends ChangeNotifier {
  final EstoqueRepository estoqueRepository;
  final ProdutoRepository produtoRepository;
  final AuthViewModel authViewModel;

  EstoqueDetailViewmodel(
    this.estoqueRepository,
    this.produtoRepository,
    this.authViewModel,
  );

  bool isLoading = false;
  String? error;
  EstoqueDetailEntity? estoque;
  List<ItemEstoqueEntity> itens = [];
  Map<int, String> produtosNomes = {};

  Future<void> carregarDetalhes(int estoqueId) async {
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

      // Carrega os dois endpoints em paralelo
      final results = await Future.wait([
        estoqueRepository.getEstoqueById(token, estoqueId),
        estoqueRepository.getItensEstoque(token, estoqueId),
      ]);

      estoque = results[0] as EstoqueDetailEntity;
      itens = results[1] as List<ItemEstoqueEntity>;

      // Busca os nomes dos produtos
      await _carregarNomesProdutos(token);
    } catch (e) {
      error = 'Erro ao carregar detalhes do estoque';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _carregarNomesProdutos(String token) async {
    final produtoIds = itens.map((item) => item.produtoId).toSet();

    for (final id in produtoIds) {
      if (!produtosNomes.containsKey(id)) {
        try {
          final produto = await produtoRepository.getProdutoById(id, token);
          produtosNomes[id] = produto.nome;
        } catch (e) {
          produtosNomes[id] = 'Produto #$id';
        }
      }
    }
    notifyListeners();
  }

  String getNomeProduto(int produtoId) {
    return produtosNomes[produtoId] ?? 'Carregando...';
  }
}
