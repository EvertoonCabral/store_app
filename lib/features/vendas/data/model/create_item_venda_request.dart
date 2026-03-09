class CreateItemVendaRequest {
  final int? produtoId;
  final int quantidade;
  final String? nomeProduto;
  final double precoUnitario;
  final double? subTotal;

  CreateItemVendaRequest(
      {this.nomeProduto,
      this.produtoId,
      required this.quantidade,
      required this.precoUnitario,
      this.subTotal});

  Map<String, dynamic> toJson() {
    return {
      'produtoId': produtoId,
      'quantidade': quantidade,
      'precoUnitario': precoUnitario,
    };
  }

  factory CreateItemVendaRequest.fromMap(Map<String, dynamic> map) {
    final rawSubtotal = map['subtotal'] ?? map['subTotal'];
    return CreateItemVendaRequest(
      produtoId: (map['produtoId'] as num?)?.toInt(),
      quantidade: (map['quantidade'] as num).toInt(),
      nomeProduto: map['nomeProduto'] as String?,
      precoUnitario: (map['precoUnitario'] as num).toDouble(),
      subTotal: rawSubtotal is num ? rawSubtotal.toDouble() : null,
    );
  }
}
