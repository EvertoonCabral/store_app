import 'dart:convert';

class ProdutoEntity {
  final int id;
  final String nome;
  final String marca;
  final double precoCompra;
  final double precoVenda;
  final String? descricao;
  final bool isAtivo;
  final DateTime dataCadastro;
  final int estoqueId;

  const ProdutoEntity({
    required this.id,
    required this.nome,
    required this.marca,
    required this.precoCompra,
    required this.precoVenda,
    required this.descricao,
    required this.isAtivo,
    required this.dataCadastro,
    required this.estoqueId,
  });

  ProdutoEntity copyWith({
    int? id,
    String? nome,
    String? marca,
    double? precoCompra,
    double? precoVenda,
    String? descricao,
    bool? isAtivo,
    DateTime? dataCadastro,
    int? estoqueId,
  }) {
    return ProdutoEntity(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      marca: marca ?? this.marca,
      precoCompra: precoCompra ?? this.precoCompra,
      precoVenda: precoVenda ?? this.precoVenda,
      descricao: descricao ?? this.descricao,
      isAtivo: isAtivo ?? this.isAtivo,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      estoqueId: estoqueId ?? this.estoqueId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'marca': marca,
      'precoCompra': precoCompra,
      'precoVenda': precoVenda,
      'descricao': descricao,
      'isAtivo': isAtivo,
      // ISO 8601 (compatível com DateTime do .NET e JSON padrão)
      'dataCadastro': dataCadastro.toIso8601String(),
      'estoqueId': estoqueId,
    };
  }

  factory ProdutoEntity.fromMap(Map<String, dynamic> map) {
    return ProdutoEntity(
      id: map['id'] as int,
      nome: map['nome'] as String,
      marca: map['marca'] as String,
      precoCompra: (map['precoCompra'] as num).toDouble(),
      precoVenda: (map['precoVenda'] as num).toDouble(),
      descricao: map['descricao'] as String?,
      isAtivo: map['isAtivo'] as bool,
      dataCadastro: DateTime.parse(map['dataCadastro'] as String),
      estoqueId: map['estoqueId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProdutoEntity.fromJson(String source) =>
      ProdutoEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProdutoEntity(id: $id, nome: $nome, marca: $marca, precoCompra: $precoCompra, precoVenda: $precoVenda, descricao: $descricao, isAtivo: $isAtivo, dataCadastro: $dataCadastro, estoqueId: $estoqueId)';
  }

  @override
  bool operator ==(covariant ProdutoEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nome == nome &&
        other.marca == marca &&
        other.precoCompra == precoCompra &&
        other.precoVenda == precoVenda &&
        other.descricao == descricao &&
        other.isAtivo == isAtivo &&
        other.dataCadastro == dataCadastro &&
        other.estoqueId == estoqueId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        marca.hashCode ^
        precoCompra.hashCode ^
        precoVenda.hashCode ^
        descricao.hashCode ^
        isAtivo.hashCode ^
        dataCadastro.hashCode ^
        estoqueId.hashCode;
  }
}
