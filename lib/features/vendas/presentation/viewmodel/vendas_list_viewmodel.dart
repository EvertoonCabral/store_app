import 'package:flutter/material.dart';
import 'package:store_app/features/vendas/data/model/venda_detail.dart';
import 'package:store_app/features/vendas/data/model/venda_entity.dart';
import 'package:store_app/features/vendas/data/repository/venda_repository.dart';

class VendasListViewmodel extends ChangeNotifier {
  final VendaRepository repository;

  VendasListViewmodel(this.repository);

  bool isLoading = false;
  String? error;
  List<VendaEntity> items = [];
  VendaEntity? vendaSelecionada;

  Future<void> retornaVendas() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      items = await repository.getAllVendas();
    } catch (e) {
      error = 'Erro ao carregar vendas';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<VendaDetailEntity?> retornaVenda(int id) async {
    try {
      return await repository.getVendaByid(id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> deletarVenda(int id) async {
    try {
      final ok = await repository.deleteVenda(id);
      if (ok) {
        items.removeWhere((v) => v.id == id);
        notifyListeners();
      }
      return ok;
    } catch (e) {
      error = 'Erro ao excluir venda';
      notifyListeners();
      return false;
    }
  }
}
