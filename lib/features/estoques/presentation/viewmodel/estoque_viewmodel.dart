import 'package:flutter/material.dart';
import 'package:store_app/features/estoques/data/model/estoque_entity.dart';
import 'package:store_app/features/estoques/data/repositories/estoque_repository.dart';
import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';

class EstoqueViewmodel extends ChangeNotifier {
  final EstoqueRepository estoqueRepository;
  final AuthViewModel authViewModel;

  EstoqueViewmodel(
      {required this.estoqueRepository, required this.authViewModel});

  bool isLoading = false;
  String? error;
  List<EstoqueEntity>? items = [];

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
}
