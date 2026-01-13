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
      'nomeProduto': nomeProduto,
      'precoUnitario': precoUnitario,
      'subTotal': subTotal
    };
  }

  factory CreateItemVendaRequest.fromMap(Map<String, dynamic> map) {
    return CreateItemVendaRequest(
        produtoId: (map['produtoId'] as num).toInt(),
        quantidade: (map['quantidade'] as num).toInt(),
        nomeProduto: (map['nomeProduto'] as String),
        precoUnitario: (map['precoUnitario'] as num).toDouble(),
        subTotal: (map['subtotal'] as num).toDouble());
  }
}
