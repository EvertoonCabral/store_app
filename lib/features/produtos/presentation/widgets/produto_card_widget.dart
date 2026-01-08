import 'package:flutter/material.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/presentation/views/produto_detail_page.dart';

class ProdutoCardWidget extends StatelessWidget {
  final ProdutoEntity produto;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProdutoCardWidget({
    super.key,
    required this.produto,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              builder: (_) => ProdutoDetailPage(produtoId: produto.id),
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
                  produto.id.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: produto.id.toString().length > 3 ? 11 : 14,
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
                    // Nome + status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            produto.nome,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _StatusChip(isAtivo: produto.isAtivo),
                      ],
                    ),

                    if (produto.marca.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        produto.marca,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],

                    if (produto.descricao != null &&
                        produto.descricao!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        produto.descricao!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],

                    const SizedBox(height: 8),

                    // Preço
                    Text(
                      'R\$ ${produto.precoVenda.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Ações
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onEdit,
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

class _StatusChip extends StatelessWidget {
  final bool isAtivo;

  const _StatusChip({required this.isAtivo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isAtivo ? Colors.green : Colors.red).withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isAtivo ? 'Ativo' : 'Inativo',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isAtivo ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
