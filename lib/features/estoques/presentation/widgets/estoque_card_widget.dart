import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_app/features/estoques/data/model/estoque_entity.dart';
import 'package:store_app/features/estoques/presentation/view/estoque_detail_page.dart';

class EstoqueCardWidget extends StatelessWidget {
  final EstoqueEntity estoque;
  final VoidCallback onEdit;

  const EstoqueCardWidget({
    super.key,
    required this.estoque,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataFormatada = DateFormat('dd/MM/yyyy').format(estoque.dataCadastro);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EstoqueDetailPage(estoqueId: estoque.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar com Ícone de Depósito/Estoque
              CircleAvatar(
                radius: 26,
                backgroundColor: theme.colorScheme.secondary.withAlpha(30),
                child: Icon(
                  Icons.warehouse_outlined,
                  color: theme.colorScheme.secondary,
                  size: 26,
                ),
              ),

              const SizedBox(width: 12),

              // Conteúdo principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${estoque.id.toString()} - ${estoque.nome.toUpperCase()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Criado em: $dataFormatada',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _CountBadge(
                          label: 'Produtos',
                          count: estoque.totalProdutos,
                          icon: Icons.category_outlined,
                        ),
                        const SizedBox(width: 8),
                        _CountBadge(
                          label: 'Itens',
                          count: estoque.totalItens,
                          icon: Icons.inventory_2_outlined,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Ação de Editar
              IconButton(
                icon: const Icon(Icons.edit_note, size: 26),
                onPressed: onEdit,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar para os contadores internos do card
class _CountBadge extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;

  const _CountBadge({
    required this.label,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            '$count $label',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
