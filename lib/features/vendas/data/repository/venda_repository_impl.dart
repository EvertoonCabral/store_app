import 'package:store_app/features/vendas/data/model/create_venda_request.dart';
import 'package:store_app/features/vendas/data/model/finalizar_pagamento_request.dart';
import 'package:store_app/features/vendas/data/model/venda_detail.dart';
import 'package:store_app/features/vendas/data/model/venda_entity.dart';
import 'package:store_app/features/vendas/data/repository/venda_repository.dart';
import 'package:store_app/features/vendas/data/services/venda_api_service.dart';

class VendaRepositoryImpl implements VendaRepository {
  final VendaApiService api;

  VendaRepositoryImpl(this.api);

  @override
  Future<List<VendaEntity>> getAllVendas() {
    return api.getAllVendas();
  }

  @override
  Future<VendaDetailEntity> getVendaByid(int id) {
    return api.getVenda(id);
  }

  @override
  Future<void> validarEstoque(VendaRequestModel request) {
    return api.validarEstoque(request);
  }

  @override
  Future<void> cadastrarVenda(VendaRequestModel venda) async {
    return await api.cadastrarVenda(venda);
  }

  @override
  Future<VendaDetailEntity> finalizarVenda(
    int vendaId,
    List<FinalizarPagamentoRequest> pagamentos,
  ) {
    return api.finalizarVenda(vendaId, pagamentos);
  }

  @override
  Future<void> cancelarVenda(
    int id,
    String motivo, {
    String? usuarioResponsavel,
  }) {
    return api.cancelarVenda(
      id,
      motivo,
      usuarioResponsavel: usuarioResponsavel,
    );
  }
}
