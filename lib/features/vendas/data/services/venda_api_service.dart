import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/vendas/data/model/create_venda_request.dart';
import 'package:store_app/features/vendas/data/model/finalizar_pagamento_request.dart';
import 'package:store_app/features/vendas/data/model/venda_detail.dart';
import 'package:store_app/features/vendas/data/model/venda_entity.dart';

class VendaApiService {
  final HttpClient client;

  VendaApiService(this.client);

  Future<List<VendaEntity>> getAllVendas() async {
    final result = await client.get('api/venda/ObterVendas');
    final data = client.decode(result);
    final list = data as List<dynamic>;
    return list
        .map((json) => VendaEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<VendaDetailEntity> getVenda(int id) async {
    final result = await client.get('api/venda/ObterVendaPorId/$id');
    final data = client.decode(result) as Map<String, dynamic>;
    return VendaDetailEntity.fromMap(data);
  }

  Future<void> cadastrarVenda(VendaRequestModel request) async {
    await client.post(
      'api/venda/CadastrarVenda',
      body: request.toJson(),
    );
  }

  Future<void> validarEstoque(VendaRequestModel request) async {
    final itens = request.itens
        .map(
          (item) => {
            'produtoId': item.produtoId,
            'quantidade': item.quantidade,
          },
        )
        .toList();

    await client.post(
      'api/venda/ValidarEstoque',
      body: {
        'itens': itens,
        'estoqueId': request.estoqueId,
      },
    );
  }

  Future<VendaDetailEntity> finalizarVenda(
    int vendaId,
    List<FinalizarPagamentoRequest> pagamentos,
  ) async {
    final result = await client.put(
      'api/venda/FinalizarVenda?vendaId=$vendaId',
      body: {
        'pagamentos': pagamentos.map((pagamento) => pagamento.toJson()).toList(),
      },
    );

    final data = client.decode(result) as Map<String, dynamic>;
    return VendaDetailEntity.fromMap(data);
  }

  Future<void> cancelarVenda(
    int id,
    String motivo, {
    String? usuarioResponsavel,
  }) async {
    final motivoEncodado = Uri.encodeQueryComponent(motivo);
    final usuarioEncodado = usuarioResponsavel != null &&
            usuarioResponsavel.isNotEmpty
        ? '&usuarioResponsavel=${Uri.encodeQueryComponent(usuarioResponsavel)}'
        : '';

    await client.put(
      'api/venda/CancelarVenda?id=$id&motivo=$motivoEncodado$usuarioEncodado',
    );
  }
}
