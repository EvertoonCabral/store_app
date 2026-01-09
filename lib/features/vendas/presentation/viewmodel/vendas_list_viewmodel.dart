import 'package:flutter/material.dart';
import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';
import 'package:store_app/features/vendas/data/model/venda_entity.dart';
import 'package:store_app/features/vendas/data/repository/venda_repository.dart';

class VendasListViewmodel extends ChangeNotifier {
  final VendaRepository repository;
  final AuthViewModel authVm;

  VendasListViewmodel(
    this.repository,
    this.authVm,
  );

  bool isLoading = false;
  String? error;
  List<VendaEntity> items = [];
  VendaEntity? vendaSelecionada;

  Future<void> retornaProdutos() async {
    final token = authVm.token;
    if (token == null || token.isEmpty) {
      error = 'Usuário não autenticado';
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      items = await repository.getAllVendas(token);
    } catch (e) {
      error = 'Erro ao carregar produtos';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
