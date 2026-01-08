import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:store_app/features/estoques/presentation/viewmodel/estoque_detail_viewmodel.dart';

class EstoqueDetailPage extends StatefulWidget {
  final int estoqueId;

  const EstoqueDetailPage({
    super.key,
    required this.estoqueId,
  });

  @override
  State<EstoqueDetailPage> createState() => _EstoqueDetailPageState();
}

class _EstoqueDetailPageState extends State<EstoqueDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EstoqueDetailViewmodel>().carregarDetalhes(widget.estoqueId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EstoqueDetailViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Estoque'),
      ),
      body: Builder(
        builder: (context) {
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
                      onPressed: () => vm.carregarDetalhes(widget.estoqueId),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final estoque = vm.estoque;
          if (estoque == null) {
            return const Center(child: Text('Estoque não encontrado'));
          }

          final dataFormatada =
              DateFormat('dd/MM/yyyy').format(estoque.dataCriacao);

          return RefreshIndicator(
            onRefresh: () => vm.carregarDetalhes(widget.estoqueId),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card com informações gerais
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            estoque.nome.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (estoque.descricao.isNotEmpty) ...[
                            Text(
                              estoque.descricao,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          const Divider(),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Data de Criação',
                            dataFormatada,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.inventory,
                            'Total de Itens',
                            estoque.totalItens.toString(),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.shopping_bag,
                            'Total de Produtos',
                            estoque.totalProdutos.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Lista de itens
                  Row(
                    children: [
                      const Icon(Icons.list_alt, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Itens do Estoque (${vm.itens.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (vm.itens.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('Nenhum item neste estoque'),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: vm.itens.length,
                      itemBuilder: (context, index) {
                        final item = vm.itens[index];
                        final dataMovimentacao = DateFormat('dd/MM/yyyy HH:mm')
                            .format(item.dataUltimaMovimentacao);
                        final nomeProduto = vm.getNomeProduto(item.produtoId);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${item.produtoId}'),
                            ),
                            title: Text(nomeProduto),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quantidade: ${item.quantidade}'),
                                Text(
                                  'Última movimentação: $dataMovimentacao',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            trailing: item.quantidadeMinima != null ||
                                    item.quantidadeMaxima != null
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (item.quantidadeMinima != null)
                                        Text(
                                          'Min: ${item.quantidadeMinima}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      if (item.quantidadeMaxima != null)
                                        Text(
                                          'Max: ${item.quantidadeMaxima}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                    ],
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
