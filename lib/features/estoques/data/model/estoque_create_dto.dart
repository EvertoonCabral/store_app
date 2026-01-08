class EstoqueCreateDto {
  final String nome;
  final String descricao;
  final String usuarioResponsavel;

  EstoqueCreateDto({
    required this.nome,
    required this.descricao,
    required this.usuarioResponsavel,
  });

  Map<String, dynamic> toMap() => {
        'nome': nome,
        'descricao': descricao,
        'usuarioResponsavel': usuarioResponsavel,
      };
}
