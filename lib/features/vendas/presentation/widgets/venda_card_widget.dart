import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_app/features/vendas/data/model/venda_entity.dart';
import 'package:store_app/features/vendas/data/model/status_venda.dart';
import 'package:store_app/features/vendas/presentation/view/venda_detail_page.dart';

class VendaCardWidget extends StatelessWidget {
  final VendaEntity venda;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VendaCardWidget({
    super.key,
    required this.venda,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getStatusColor(StatusVenda status) {
    switch (status) {
      case StatusVenda.pendente:
        return Colors.orange;
      case StatusVenda.finalizada:
        return Colors.green;
      case StatusVenda.cancelada:
        return Colors.red;
    }
  }

  String _getStatusLabel(StatusVenda status) {
    switch (status) {
      case StatusVenda.pendente:
        return 'Pendente';
      case StatusVenda.finalizada:
        return 'Finalizada';
      case StatusVenda.cancelada:
        return 'Cancelada';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final valorFinal = venda.valorTotal - venda.desconto;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VendaDetailPage(vendaId: venda.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar / Ícone
              CircleAvatar(
                radius: 26,
                backgroundColor: theme.colorScheme.primary.withAlpha(30),
                child: Text(
                  '${venda.id}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: venda.id.toString().length > 3 ? 11 : 14,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Conteúdo principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID + status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Venda #${venda.id}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(venda.status).withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getStatusLabel(venda.status),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(venda.status),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Vendedor
                    Text(
                      'Vendedor: ${venda.usuarioVendedor}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Data
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 13,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(venda.dataVenda),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Valores
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total: R\$ ${venda.valorTotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              if (venda.desconto > 0)
                                Text(
                                  'Desconto aplicado: R\$ ${venda.desconto.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Ações
              Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
