import 'package:flutter/material.dart';
import 'package:store_app/core/token_store.dart';
import 'package:store_app/features/estoques/data/model/estoque_create_dto.dart';
import 'package:store_app/features/estoques/data/model/estoque_entity.dart';
import 'package:store_app/features/estoques/data/repositories/estoque_repository.dart';

class EstoqueViewmodel extends ChangeNotifier {
  final EstoqueRepository estoqueRepository;
  final TokenStore _tokenStore;

  EstoqueViewmodel(this.estoqueRepository, this._tokenStore);

  bool isLoading = false;
  String? error;
  List<EstoqueEntity> items = [];

  Future<void> retornaEstoques() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      items = await estoqueRepository.getEstoques();
    } catch (e) {
      error = 'Erro ao carregar estoques';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> criarEstoque(String nome, String descricao) async {
    final request = EstoqueCreateDto(
      nome: nome.trim(),
      descricao: descricao.trim(),
      usuarioResponsavel: _tokenStore.nomeUsuario,
    );

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await estoqueRepository.criarEstoque(request);
      await retornaEstoques();
      return true;
    } catch (e) {
      error = 'Erro ao criar estoque';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
