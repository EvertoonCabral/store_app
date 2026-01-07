import 'package:flutter/material.dart';
import 'package:store_app/features/estoques/data/model/estoque_entity.dart';

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
    return Card(
      child: ListTile(
        title: Text(
          estoque.nome.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Data de Criação: ${estoque.dataCadastro}'),
            Text('Total de Items: ${estoque.totalItens}'),
            Text('Total de Produtos: ${estoque.totalProdutos}'),
          ],
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
