import 'package:flutter/material.dart';
import 'package:store_app/features/estoques/data/model/estoque_entity.dart';

class EstoqueCardWidget extends StatelessWidget {
  final EstoqueEntity estoque;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EstoqueCardWidget(
      {super.key,
      required this.estoque,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(estoque.nome),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data de Criação: ${estoque.dataCadastro}'),
            Text('Total de Items: ${estoque.totalItens}'),
            Text('Total de Produtos: ${estoque.totalItens}'),
          ],
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
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
