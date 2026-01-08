import 'package:flutter/material.dart';
import 'package:store_app/core/widgets/status_chip_widget.dart';
import 'package:store_app/features/clientes/data/models/cliente_dto.dart';

class ClienteCardWidget extends StatelessWidget {
  final ClienteDto cliente;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ClienteCardWidget({
    super.key,
    required this.cliente,
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar com ID ou iniciais
            CircleAvatar(
              radius: 26,
              backgroundColor: theme.colorScheme.primary.withAlpha(30),
              child: Text(
                _getAvatarText(cliente),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
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
                          cliente.nome,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      StatusChipWidget(isAtivo: cliente.isAtivo),
                    ],
                  ),

                  if (cliente.email != null && cliente.email!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      cliente.email!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],

                  const SizedBox(height: 6),

                  Text(
                    'Telefone: ${cliente.telefone}',
                    style: const TextStyle(fontSize: 13),
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
    );
  }

  String _getAvatarText(ClienteDto cliente) {
    final parts = cliente.nome.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    if (parts.isNotEmpty) {
      return parts.first[0].toUpperCase();
    }
    return cliente.id.toString();
  }
}
