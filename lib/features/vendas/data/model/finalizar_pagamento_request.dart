class FinalizarPagamentoRequest {
  final double valorPago;
  final String formaPagamento;
  final String? dataPagamento;
  final String? observacoes;

  const FinalizarPagamentoRequest({
    required this.valorPago,
    required this.formaPagamento,
    this.dataPagamento,
    this.observacoes,
  });

  Map<String, dynamic> toJson() {
    return {
      'valorPago': valorPago,
      'formaPagamento': formaPagamento,
      if (dataPagamento != null && dataPagamento!.isNotEmpty)
        'dataPagamento': dataPagamento,
      if (observacoes != null && observacoes!.isNotEmpty)
        'observacoes': observacoes,
    };
  }
}
