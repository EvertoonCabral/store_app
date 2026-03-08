import 'dart:convert';

class ProdutoEntity {
  final int? id;
  final String nome;
  final String marca;
  final double precoCompra;
  final double precoVenda;
  final int quantidadeEstoque;
  final String? descricao;
  final bool isAtivo;
  final DateTime? dataCadastro;
  final int estoqueId;

  const ProdutoEntity({
    this.id,
    required this.nome,
    required this.marca,
    required this.precoCompra,
    required this.precoVenda,
    this.quantidadeEstoque = 0,
    required this.descricao,
    required this.isAtivo,
    this.dataCadastro,
    required this.estoqueId,
  });

  ProdutoEntity copyWith({
    int? id,
    String? nome,
    String? marca,
    double? precoCompra,
    double? precoVenda,
    int? quantidadeEstoque,
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
      quantidadeEstoque: quantidadeEstoque ?? this.quantidadeEstoque,
      descricao: descricao ?? this.descricao,
      isAtivo: isAtivo ?? this.isAtivo,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      estoqueId: estoqueId ?? this.estoqueId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'nome': nome,
      'marca': marca,
      'precoCompra': precoCompra,
      'precoVenda': precoVenda,
      'quantidadeEstoque': quantidadeEstoque,
      'descricao': descricao,
      'isAtivo': isAtivo,
      'estoqueId': estoqueId,
    };
  }

  Map<String, dynamic> toWriteMap() {
    return <String, dynamic>{
      'nome': nome,
      'marca': marca,
      'precoCompra': precoCompra,
      'precoVenda': precoVenda,
      'quantidadeEstoque': quantidadeEstoque,
      'descricao': descricao,
      'isAtivo': isAtivo,
      'estoqueId': estoqueId,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'marca': marca,
      'precoCompra': precoCompra,
      'precoVenda': precoVenda,
      'quantidadeEstoque': quantidadeEstoque,
      'descricao': descricao,
      'isAtivo': isAtivo,
      'estoqueId': estoqueId,
    };
  }

  factory ProdutoEntity.fromMap(Map<String, dynamic> map) {
    final rawDataCadastro = map['dataCadastro'];
    final dataCadastro = rawDataCadastro is String && rawDataCadastro.isNotEmpty
        ? DateTime.parse(rawDataCadastro)
        : null;

    final rawPrecoCompra = map['precoCompra'];
    final precoCompra = rawPrecoCompra is num
        ? rawPrecoCompra.toDouble()
        : double.tryParse('$rawPrecoCompra') ?? 0;

    final rawPrecoVenda = map['precoVenda'];
    final precoVenda = rawPrecoVenda is num
        ? rawPrecoVenda.toDouble()
        : double.tryParse('$rawPrecoVenda') ?? 0;

    final rawQuantidadeEstoque = map['quantidadeEstoque'];
    final quantidadeEstoque = rawQuantidadeEstoque is num
        ? rawQuantidadeEstoque.toInt()
        : int.tryParse('$rawQuantidadeEstoque') ?? 0;

    return ProdutoEntity(
      id: map['id'] as int?,
      nome: (map['nome'] as String?) ?? '',
      marca: (map['marca'] as String?) ?? '',
      precoCompra: precoCompra,
      precoVenda: precoVenda,
      quantidadeEstoque: quantidadeEstoque,
      descricao: map['descricao'] as String?,
      isAtivo: (map['isAtivo'] as bool?) ?? true,
      dataCadastro: dataCadastro,
      estoqueId: (map['estoqueId'] as int?) ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProdutoEntity.fromJson(Map<String, dynamic> json) =>
      ProdutoEntity.fromMap(json);
  @override
  String toString() {
    return 'ProdutoEntity(id: $id, nome: $nome, marca: $marca, precoCompra: $precoCompra, precoVenda: $precoVenda, quantidadeEstoque: $quantidadeEstoque, descricao: $descricao, isAtivo: $isAtivo, dataCadastro: $dataCadastro, estoqueId: $estoqueId)';
  }

  @override
  bool operator ==(covariant ProdutoEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nome == nome &&
        other.marca == marca &&
        other.precoCompra == precoCompra &&
        other.precoVenda == precoVenda &&
        other.quantidadeEstoque == quantidadeEstoque &&
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
        quantidadeEstoque.hashCode ^
        descricao.hashCode ^
        isAtivo.hashCode ^
        dataCadastro.hashCode ^
        estoqueId.hashCode;
  }
}
