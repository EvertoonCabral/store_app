import 'package:store_app/features/vendas/data/model/create_venda_request.dart';
import 'package:store_app/features/vendas/data/model/finalizar_pagamento_request.dart';
import 'package:store_app/features/vendas/data/model/venda_detail.dart';
import 'package:store_app/features/vendas/data/model/venda_entity.dart';

abstract class VendaRepository {
  Future<List<VendaEntity>> getAllVendas();
  Future<VendaDetailEntity> getVendaByid(int id);
  Future<void> validarEstoque(VendaRequestModel request);
  Future<void> cadastrarVenda(VendaRequestModel request);
  Future<VendaDetailEntity> finalizarVenda(
    int vendaId,
    List<FinalizarPagamentoRequest> pagamentos,
  );
  Future<void> cancelarVenda(
    int id,
    String motivo, {
    String? usuarioResponsavel,
  });
}
