import 'package:store_app/features/vendas/data/model/create_item_venda_request.dart';

class VendaRequestModel {
  final int clienteId;
  final int estoqueId;
  final List<CreateItemVendaRequest> itens;
  final double desconto;
  final String? observacoes;
  final String usuarioVendedor;

  VendaRequestModel({
    required this.clienteId,
    required this.estoqueId,
    required this.itens,
    this.desconto = 0,
    this.observacoes,
    required this.usuarioVendedor,
  });

  Map<String, dynamic> toJson() {
    return {
      'clienteId': clienteId,
      'estoqueId': estoqueId,
      'itens': itens.map((item) => item.toJson()).toList(),
      'desconto': desconto,
      'observacoes': observacoes,
      'usuarioVendedor': usuarioVendedor,
    };
  }
}
