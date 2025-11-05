import 'package:flutter/material.dart';
import 'package:store_app/features/clientes/data/models/cliente_dto.dart';

class ClienteListItem extends StatelessWidget {
  final ClienteDto cliente;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ClienteListItem(
      {super.key,
      required this.cliente,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(cliente.nome),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cliente.email != null && cliente.email!.isNotEmpty)
              Text(cliente.email!),
            Text('Telefone: ${cliente.telefone}'),
            Text(cliente.isAtivo ? 'Ativo' : 'Inativo'),
          ],
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/editar-cliente');
              },
            ),
            IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
