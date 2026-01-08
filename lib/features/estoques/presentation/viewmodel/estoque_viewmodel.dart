import 'package:flutter/material.dart';
import 'package:store_app/features/estoques/data/model/estoque_create_dto.dart';
import 'package:store_app/features/estoques/data/model/estoque_entity.dart';
import 'package:store_app/features/estoques/data/repositories/estoque_repository.dart';
import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';

class EstoqueViewmodel extends ChangeNotifier {
  final EstoqueRepository estoqueRepository;
  final AuthViewModel authViewModel;

  EstoqueViewmodel(this.estoqueRepository, this.authViewModel);

  bool isLoading = false;
  String? error;
  List<EstoqueEntity> items = [];

  Future<void> retornaEstoques() async {
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

      items = await estoqueRepository.getEstoques(token);
    } catch (e) {
      error = 'Erro ao carregar produtos';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> criarEstoque(String nome, String descricao) async {
    final token = authViewModel.token;
    if (token == null || token.isEmpty) {
      error = 'Usuário não autenticado';
      notifyListeners();
      return false;
    }

    final request = EstoqueCreateDto(
      nome: nome.trim(),
      descricao: descricao.trim(),
      usuarioResponsavel: 'ADMIN',
    );

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await estoqueRepository.criarEstoque(token, request);
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
