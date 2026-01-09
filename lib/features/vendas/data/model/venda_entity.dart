import 'package:store_app/features/vendas/data/model/status_venda.dart';

class VendaEntity {
  final int id;
  final DateTime dataVenda;
  final double valorTotal;
  final double desconto;
  final StatusVenda status;
  final String usuarioVendedor;

  const VendaEntity({
    required this.id,
    required this.dataVenda,
    required this.valorTotal,
    required this.desconto,
    required this.status,
    required this.usuarioVendedor,
  });

  VendaEntity copyWith({
    int? id,
    DateTime? dataVenda,
    double? valorTotal,
    double? desconto,
    StatusVenda? status,
    String? usuarioVendedor,
  }) {
    return VendaEntity(
      id: id ?? this.id,
      dataVenda: dataVenda ?? this.dataVenda,
      valorTotal: valorTotal ?? this.valorTotal,
      desconto: desconto ?? this.desconto,
      status: status ?? this.status,
      usuarioVendedor: usuarioVendedor ?? this.usuarioVendedor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dataVenda': dataVenda.toIso8601String(),
      'valorTotal': valorTotal,
      'desconto': desconto,
      'status': status.value, // salva como int (1,2,3)
      'usuarioVendedor': usuarioVendedor,
    };
  }

  factory VendaEntity.fromMap(Map<String, dynamic> map) {
    return VendaEntity(
      id: (map['id'] as num).toInt(),
      dataVenda: DateTime.parse(map['dataVenda'] as String),
      valorTotal: (map['valorTotal'] as num).toDouble(),
      desconto: (map['desconto'] as num).toDouble(),
      status: StatusVenda.fromAny(map['status'] ?? map['Status']),
      usuarioVendedor:
          (map['usuarioVendedor'] ?? map['UsuarioVendedor']) as String,
    );
  }

  String toJson() =>
      toMap().toString(); // simples (se quiser JSON real, uso dart:convert)
  factory VendaEntity.fromJson(Map<String, dynamic> json) =>
      VendaEntity.fromMap(json);

  @override
  String toString() {
    return 'VendaEntity(id: $id, dataVenda: $dataVenda, valorTotal: $valorTotal, desconto: $desconto, status: $status, usuarioVendedor: $usuarioVendedor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is VendaEntity &&
            other.id == id &&
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
