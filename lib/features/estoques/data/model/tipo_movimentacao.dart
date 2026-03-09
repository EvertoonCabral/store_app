enum TipoMovimentacao {
  entrada('Entrada'),
  saida('Saida'),
  transferencia('Transferencia'),
  ajuste('Ajuste'),
  perda('Perda'),
  devolucao('Devolucao'),
  criacao('Criacao');

  final String apiValue;
  const TipoMovimentacao(this.apiValue);

  @override
  String toString() => apiValue;
}
