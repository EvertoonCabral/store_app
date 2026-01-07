class EstoqueEntity {
  final int id;
  final String nome;
  final DateTime dataCadastro;
  final int totalItens;
  final int totalProdutos;

  EstoqueEntity({
    required this.id,
    required this.nome,
    required this.dataCadastro,
    required this.totalItens,
    required this.totalProdutos,
  });

  factory EstoqueEntity.fromMap(Map<String, dynamic> map) {
    return EstoqueEntity(
      id: map['id'] as int,
      nome: map['nome'] as String,
      dataCadastro: DateTime.parse(map['dataCriacao'] as String),
      totalItens: map['totalItens'] as int,
      totalProdutos: map['totalProdutos'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'dataCriacao': dataCadastro.toIso8601String(),
      'totalItens': totalItens,
      'totalProdutos': totalProdutos,
    };
  }

  EstoqueEntity copyWith({
    int? id,
    String? nome,
    DateTime? dataCadastro,
    int? totalItens,
    int? totalProdutos,
  }) {
    return EstoqueEntity(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      totalItens: totalItens ?? this.totalItens,
      totalProdutos: totalProdutos ?? this.totalProdutos,
    );
  }

  @override
  String toString() {
    return 'EstoqueEntity(id: $id, nome: $nome, dataCadastro: $dataCadastro, totalItens: $totalItens, totalProdutos: $totalProdutos)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EstoqueEntity &&
        other.id == id &&
        other.nome == nome &&
        other.dataCadastro == dataCadastro &&
        other.totalItens == totalItens &&
        other.totalProdutos == totalProdutos;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        dataCadastro.hashCode ^
        totalItens.hashCode ^
        totalProdutos.hashCode;
  }
}
