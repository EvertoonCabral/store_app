class ItemEstoqueEntity {
  final int id;
  final int produtoId;
  final int estoqueId;
  final int quantidade;
  final int? quantidadeMinima;
  final int? quantidadeMaxima;
  final DateTime dataUltimaMovimentacao;

  ItemEstoqueEntity({
    required this.id,
    required this.produtoId,
    required this.estoqueId,
    required this.quantidade,
    this.quantidadeMinima,
    this.quantidadeMaxima,
    required this.dataUltimaMovimentacao,
  });

  factory ItemEstoqueEntity.fromMap(Map<String, dynamic> map) {
    return ItemEstoqueEntity(
      id: map['id'] as int,
      produtoId: map['produtoId'] as int,
      estoqueId: map['estoqueId'] as int,
      quantidade: map['quantidade'] as int,
      quantidadeMinima: map['quantidadeMinima'] as int?,
      quantidadeMaxima: map['quantidadeMaxima'] as int?,
      dataUltimaMovimentacao:
          DateTime.parse(map['dataUltimaMovimentacao'] as String),
    );
  }
}
