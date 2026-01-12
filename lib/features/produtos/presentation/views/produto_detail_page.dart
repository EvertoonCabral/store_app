import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:store_app/features/produtos/presentation/viewmodel/produto_detail_viewmodel.dart';

class ProdutoDetailPage extends StatefulWidget {
  final int? produtoId;

  const ProdutoDetailPage({
    super.key,
    required this.produtoId,
  });

  @override
  State<ProdutoDetailPage> createState() => _ProdutoDetailPageState();
}

class _ProdutoDetailPageState extends State<ProdutoDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProdutoDetailViewmodel>().carregarProduto(widget.produtoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProdutoDetailViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
      ),
      body: Builder(
        builder: (_) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(vm.error!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => vm.carregarProduto(widget.produtoId),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final produto = vm.produto;
          if (produto == null) {
            return const Center(child: Text('Produto não encontrado'));
          }

          final dataFormatada =
              DateFormat('dd/MM/yyyy').format(produto.dataCadastro);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          produto.nome.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          produto.marca,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (produto.descricao != null &&
                            produto.descricao!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(produto.descricao!),
                        ],
                        const SizedBox(height: 16),
                        const Divider(),
                        _infoRow(
                          Icons.attach_money,
                          'Preço de Compra',
                          'R\$ ${produto.precoCompra.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 8),
                        _infoRow(
                          Icons.sell,
                          'Preço de Venda',
                          'R\$ ${produto.precoVenda.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 8),
                        _infoRow(
                          Icons.inventory_2,
                          'Estoque ID',
                          produto.estoqueId.toString(),
                        ),
                        const SizedBox(height: 8),
                        _infoRow(
                          Icons.calendar_today,
                          'Cadastrado em',
                          dataFormatada,
                        ),
                        const SizedBox(height: 8),
                        _infoRow(
                          Icons.check_circle,
                          'Status',
                          produto.isAtivo ? 'Ativo' : 'Inativo',
                          valueColor:
                              produto.isAtivo ? Colors.green : Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(color: Colors.grey[600]),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
