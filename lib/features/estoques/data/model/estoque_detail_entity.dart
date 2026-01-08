class EstoqueDetailEntity {
  final int id;
  final String nome;
  final String descricao;
  final DateTime dataCriacao;
  final int totalItens;
  final int totalProdutos;

  EstoqueDetailEntity({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.dataCriacao,
    required this.totalItens,
    required this.totalProdutos,
  });

  factory EstoqueDetailEntity.fromMap(Map<String, dynamic> map) {
    return EstoqueDetailEntity(
      id: map['id'] as int,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String? ?? '',
      dataCriacao: DateTime.parse(map['dataCriacao'] as String),
      totalItens: map['totalItens'] as int,
      totalProdutos: map['totalProdutos'] as int,
    );
  }
}
