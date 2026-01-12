import 'package:flutter/material.dart';
import 'package:store_app/features/clientes/data/models/cliente_entity.dart';
import 'package:store_app/features/estoques/data/model/estoque_entity.dart';
import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/vendas/data/model/create_item_venda_request.dart';
import 'package:store_app/features/vendas/data/model/create_venda_request.dart';
import 'package:store_app/features/vendas/data/repository/venda_repository.dart';

class ItemVendaTemp {
  final ProdutoEntity produto;
  int quantidade;
  double precoUnitario;

  ItemVendaTemp({
    required this.produto,
    required this.quantidade,
    required this.precoUnitario,
  });

  double get subtotal => quantidade * precoUnitario;
}

class VendaCadastroViewmodel extends ChangeNotifier {
  final VendaRepository repository;
  final AuthViewModel authVm;

  VendaCadastroViewmodel(this.repository, this.authVm);

  bool isLoading = false;
  String? error;

  // Dados da venda
  ClienteDto? clienteSelecionado;
  EstoqueEntity? estoqueSelecionado;
  List<ItemVendaTemp> itens = [];
  double desconto = 0;
  String? observacoes;

  // Getters
  double get subtotal => itens.fold(0, (sum, item) => sum + item.subtotal);
  double get valorTotal => subtotal - desconto;
  bool get podeExibirCampos => itens.isNotEmpty;

  void selecionarCliente(ClienteDto? cliente) {
    clienteSelecionado = cliente;
    notifyListeners();
  }

  void selecionarEstoque(EstoqueEntity? estoque) {
    estoqueSelecionado = estoque;
    notifyListeners();
  }

  void adicionarItem(ProdutoEntity produto, int quantidade) {
    // Verifica se o produto já está na lista
    final index = itens.indexWhere((item) => item.produto.id == produto.id);

    if (index >= 0) {
      itens[index].quantidade += quantidade;
    } else {
      itens.add(ItemVendaTemp(
        produto: produto,
        quantidade: quantidade,
        precoUnitario: produto.precoVenda,
      ));
    }
    notifyListeners();
  }

  void removerItem(int? produtoId) {
    itens.removeWhere((item) => item.produto.id == produtoId);
    notifyListeners();
  }

  void atualizarQuantidade(int? produtoId, int novaQuantidade) {
    final index = itens.indexWhere((item) => item.produto.id == produtoId);
    if (index >= 0) {
      if (novaQuantidade <= 0) {
        removerItem(produtoId);
      } else {
        itens[index].quantidade = novaQuantidade;
        notifyListeners();
      }
    }
  }

  void atualizarPrecoUnitario(int produtoId, double novoPreco) {
    final index = itens.indexWhere((item) => item.produto.id == produtoId);
    if (index >= 0) {
      itens[index].precoUnitario = novoPreco;
      notifyListeners();
    }
  }

  void setDesconto(double valor) {
    desconto = valor;
    notifyListeners();
  }

  void setObservacoes(String? obs) {
    observacoes = obs;
    notifyListeners();
  }

  String? validar() {
    if (clienteSelecionado == null) {
      return 'Selecione um cliente';
    }
    if (estoqueSelecionado == null) {
      return 'Selecione um estoque';
    }
    if (itens.isEmpty) {
      return 'Adicione pelo menos um produto';
    }
    if (valorTotal < 0) {
      return 'O desconto não pode ser maior que o subtotal';
    }
    return null;
  }

  Future<bool> cadastrarVenda() async {
    final validacao = validar();
    if (validacao != null) {
      error = validacao;
      notifyListeners();
      return false;
    }

    final token = authVm.token;
    if (token == null || token.isEmpty) {
      error = 'Usuário não autenticado';
      notifyListeners();
      return false;
    }

    final usuario = 'ADMIN';

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final request = VendaRequestModel(
        clienteId: clienteSelecionado!.id,
        estoqueId: estoqueSelecionado!.id,
        itens: itens
            .map((item) => CreateItemVendaRequest(
                  produtoId: item.produto.id,
                  quantidade: item.quantidade,
                  precoUnitario: item.precoUnitario,
                ))
            .toList(),
        desconto: desconto,
        observacoes: observacoes,
        usuarioVendedor: usuario,
      );

      await repository.cadastrarVenda(token, request);
      limpar();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void limpar() {
    clienteSelecionado = null;
    estoqueSelecionado = null;
    itens.clear();
    desconto = 0;
    observacoes = null;
    error = null;
    notifyListeners();
  }
}
