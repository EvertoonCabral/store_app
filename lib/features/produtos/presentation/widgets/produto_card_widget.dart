import 'package:flutter/material.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';

class ProdutoCardWidget extends StatelessWidget {
  final ProdutoEntity produto;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProdutoCardWidget(
      {super.key,
      required this.produto,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(produto.nome),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (produto.descricao != null && produto.descricao!.isNotEmpty)
              Text(produto.descricao!),
            Text('Valor: ${produto.precoVenda}'),
            Text(produto.isAtivo ? 'Ativo' : 'Inativo'),
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
