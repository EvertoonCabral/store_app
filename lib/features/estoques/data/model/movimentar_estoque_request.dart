import 'package:store_app/features/estoques/data/model/tipo_movimentacao.dart';

class MovimentarEstoqueRequest {
  final int produtoId;
  final int estoqueId;
  final int quantidade;
  final TipoMovimentacao tipo;
  final String? observacoes;
  final String usuarioResponsavel;

  const MovimentarEstoqueRequest({
    required this.produtoId,
    required this.estoqueId,
    required this.quantidade,
    required this.tipo,
    this.observacoes,
    required this.usuarioResponsavel,
  });

  Map<String, dynamic> toMap() {
    return {
      'produtoId': produtoId,
      'estoqueId': estoqueId,
      'quantidade': quantidade,
      'tipo': tipo.apiValue,
      if (observacoes != null && observacoes!.trim().isNotEmpty)
        'observacoes': observacoes!.trim(),
      'usuarioResponsavel': usuarioResponsavel,
    };
  }
}
