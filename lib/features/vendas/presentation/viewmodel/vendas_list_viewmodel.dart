import 'package:flutter/material.dart';
import 'package:store_app/features/vendas/data/model/finalizar_pagamento_request.dart';
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

  Future<bool> cancelarVenda(int id, {required String motivo}) async {
    try {
      await repository.cancelarVenda(id, motivo);
      await retornaVendas();
      return true;
    } catch (e) {
      error = 'Erro ao cancelar venda';
      notifyListeners();
      return false;
    }
  }

  Future<bool> finalizarVenda(int id, double valorTotal) async {
    try {
      await repository.finalizarVenda(
        id,
        [
          FinalizarPagamentoRequest(
            valorPago: valorTotal,
            formaPagamento: 'PIX',
          ),
        ],
      );
      await retornaVendas();
      return true;
    } catch (e) {
      error = 'Erro ao finalizar venda';
      notifyListeners();
      return false;
    }
  }
}
