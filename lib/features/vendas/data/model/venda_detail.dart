import 'package:store_app/features/vendas/data/model/create_item_venda_request.dart';
import 'package:store_app/features/vendas/data/model/status_venda.dart';

class VendaDetailEntity {
  final int id;
  final int clienteId;
  final DateTime dataVenda;
  final double valorTotal;
  final double desconto;
  final StatusVenda status;
  final String usuarioVendedor;
  final List<CreateItemVendaRequest> itensVenda;

  const VendaDetailEntity({
    required this.id,
    required this.clienteId,
    required this.dataVenda,
    required this.valorTotal,
    required this.desconto,
    required this.status,
    required this.usuarioVendedor,
    this.itensVenda = const [],
  });

  VendaDetailEntity copyWith({
    int? id,
    int? clienteId,
    DateTime? dataVenda,
    double? valorTotal,
    double? desconto,
    StatusVenda? status,
    String? usuarioVendedor,
    List<CreateItemVendaRequest>? itensVenda, // ← TROQUE PARA ItemVendaDto
  }) {
    return VendaDetailEntity(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      dataVenda: dataVenda ?? this.dataVenda,
      valorTotal: valorTotal ?? this.valorTotal,
      desconto: desconto ?? this.desconto,
      status: status ?? this.status,
      usuarioVendedor: usuarioVendedor ?? this.usuarioVendedor,
      itensVenda: itensVenda ?? this.itensVenda,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'clienteId': clienteId,
      'dataVenda': dataVenda.toIso8601String(),
      'valorTotal': valorTotal,
      'desconto': desconto,
      'status': status.value,
      'usuarioVendedor': usuarioVendedor,
      'itensVenda':
          itensVenda.map((x) => x.toJson()).toList(), // ← Agora funciona
    };
  }

  factory VendaDetailEntity.fromMap(Map<String, dynamic> map) {
    return VendaDetailEntity(
      id: (map['id'] as num).toInt(),
      clienteId: (map['clienteId'] as num).toInt(),
      dataVenda: DateTime.parse(map['dataVenda'] as String),
      valorTotal: (map['valorTotal'] as num).toDouble(),
      desconto: (map['desconto'] as num).toDouble(),
      status: StatusVenda.fromAny(map['status'] ?? map['Status']),
      usuarioVendedor:
          (map['usuarioVendedor'] ?? map['UsuarioVendedor']) as String,
      itensVenda: map['itensVenda'] != null
          ? (map['itensVenda'] as List)
              .map((item) =>
                  CreateItemVendaRequest.fromMap(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  String toJson() => toMap().toString();
  factory VendaDetailEntity.fromJson(Map<String, dynamic> json) =>
      VendaDetailEntity.fromMap(json);

  @override
  String toString() {
    return 'VendaDetailEntity(id: $id, clienteId: $clienteId, dataVenda: $dataVenda, valorTotal: $valorTotal, desconto: $desconto, status: $status, usuarioVendedor: $usuarioVendedor, itensVenda: $itensVenda)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is VendaDetailEntity &&
            other.id == id &&
            other.clienteId == clienteId &&
            other.dataVenda == dataVenda &&
            other.valorTotal == valorTotal &&
            other.desconto == desconto &&
            other.status == status &&
            other.usuarioVendedor == usuarioVendedor);
  }

  @override
  int get hashCode {
    return Object.hash(
        id, dataVenda, valorTotal, desconto, status, usuarioVendedor);
  }
}
