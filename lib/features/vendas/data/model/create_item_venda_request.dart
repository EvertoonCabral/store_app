class CreateItemVendaRequest {
  final int? produtoId;
  final int quantidade;
  final double? precoUnitario;

  CreateItemVendaRequest({
    required this.produtoId,
    required this.quantidade,
    this.precoUnitario,
  });

  Map<String, dynamic> toJson() {
    return {
      'produtoId': produtoId,
      'quantidade': quantidade,
      'precoUnitario': precoUnitario,
    };
  }
}
