import 'package:flutter/material.dart';
import 'package:store_app/features/estoques/data/model/estoque_detail_entity.dart';
import 'package:store_app/features/estoques/data/model/item_estoque_entity.dart';
import 'package:store_app/features/estoques/data/repositories/estoque_repository.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository.dart';

class EstoqueDetailViewmodel extends ChangeNotifier {
  final EstoqueRepository estoqueRepository;
  final ProdutoRepository produtoRepository;

  EstoqueDetailViewmodel(this.estoqueRepository, this.produtoRepository);

  bool isLoading = false;
  String? error;
  EstoqueDetailEntity? estoque;
  List<ItemEstoqueEntity> itens = [];
  Map<int, String> produtosNomes = {};

  Future<void> carregarDetalhes(int estoqueId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      // Carrega os dois endpoints em paralelo
      final results = await Future.wait([
        estoqueRepository.getEstoqueById(estoqueId),
        estoqueRepository.getItensEstoque(estoqueId),
      ]);

      estoque = results[0] as EstoqueDetailEntity;
      itens = results[1] as List<ItemEstoqueEntity>;

      await _carregarNomesProdutos();
    } catch (e) {
      error = 'Erro ao carregar detalhes do estoque';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _carregarNomesProdutos() async {
    final produtoIds = itens.map((item) => item.produtoId).toSet();

    for (final id in produtoIds) {
      if (!produtosNomes.containsKey(id)) {
        try {
          final produto = await produtoRepository.getProdutoById(id);
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
