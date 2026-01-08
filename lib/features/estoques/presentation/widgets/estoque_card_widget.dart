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
    final dataFormatada = DateFormat('dd/MM/yyyy').format(estoque.dataCadastro);

    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EstoqueDetailPage(estoqueId: estoque.id),
            ),
          );
        },
        title: Text(
          estoque.nome.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text('Data de Criação: $dataFormatada'),
            Text('Total de Itens: ${estoque.totalItens}'),
            Text('Total de Produtos: ${estoque.totalProdutos}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
      ),
    );
  }
}
