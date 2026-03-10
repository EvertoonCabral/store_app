import 'package:flutter/material.dart';
import 'package:store_app/core/token_store.dart';
import 'package:store_app/features/estoques/data/model/estoque_detail_entity.dart';
import 'package:store_app/features/estoques/data/model/item_estoque_entity.dart';
import 'package:store_app/features/estoques/data/model/movimentar_estoque_request.dart';
import 'package:store_app/features/estoques/data/model/tipo_movimentacao.dart';
import 'package:store_app/features/estoques/data/repositories/estoque_repository.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository.dart';

class EstoqueDetailViewmodel extends ChangeNotifier {
  final EstoqueRepository estoqueRepository;
  final ProdutoRepository produtoRepository;
  final TokenStore _tokenStore;

  EstoqueDetailViewmodel(
      this.estoqueRepository, this.produtoRepository, this._tokenStore);

  bool isLoading = false;
  bool isMoving = false;
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

  Future<bool> movimentarEstoque({
    required int produtoId,
    required int quantidade,
    required TipoMovimentacao tipo,
    String? observacoes,
  }) async {
    final estoqueAtual = estoque;
    if (estoqueAtual == null) {
      error = 'Estoque não carregado';
      notifyListeners();
      return false;
    }

    try {
      isMoving = true;
      error = null;
      notifyListeners();

      final request = MovimentarEstoqueRequest(
        produtoId: produtoId,
        estoqueId: estoqueAtual.id,
        quantidade: quantidade,
        tipo: tipo,
        observacoes: observacoes,
        usuarioResponsavel: _tokenStore.nomeUsuario,
      );

      await estoqueRepository.movimentarEstoque(request);
      await carregarDetalhes(estoqueAtual.id);
      return true;
    } catch (_) {
      error = 'Erro ao movimentar estoque';
      notifyListeners();
      return false;
    } finally {
      isMoving = false;
      notifyListeners();
    }
  }
}
