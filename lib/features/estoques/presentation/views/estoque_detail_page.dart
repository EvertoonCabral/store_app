import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/features/estoques/data/model/tipo_movimentacao.dart';
import 'package:store_app/features/estoques/presentation/viewmodel/estoque_detail_viewmodel.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/presentation/viewmodel/produto_list_viewmodel.dart';

class EstoqueDetailPage extends StatefulWidget {
  final int estoqueId;

  const EstoqueDetailPage({super.key, required this.estoqueId});

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

  Future<void> _abrirMovimentacaoDialog() async {
    final vm = context.read<EstoqueDetailViewmodel>();
    final produtoVm = context.read<ProdutoListViewmodel>();

    if (produtoVm.items.isEmpty) {
      await produtoVm.retornaProdutos();
    }

    if (!mounted) return;

    final produtosDisponiveis =
        produtoVm.items.where((produto) => produto.id != null).toList();

    if (produtosDisponiveis.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não há produtos disponíveis para movimentação'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final quantidadeController = TextEditingController();
    final observacoesController = TextEditingController();

    ProdutoEntity produtoSelecionado = produtosDisponiveis.first;
    TipoMovimentacao tipoSelecionado = TipoMovimentacao.entrada;

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Movimentar estoque'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<ProdutoEntity>(
                      value: produtoSelecionado,
                      decoration: const InputDecoration(
                        labelText: 'Produto',
                        border: OutlineInputBorder(),
                      ),
                      items: produtosDisponiveis
                          .map(
                            (produto) => DropdownMenuItem<ProdutoEntity>(
                              value: produto,
                              child: Text(
                                '#${produto.id} - ${produto.nome}',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            produtoSelecionado = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<TipoMovimentacao>(
                      value: tipoSelecionado,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de movimentação',
                        border: OutlineInputBorder(),
                      ),
                      items: TipoMovimentacao.values
                          .map(
                            (tipo) => DropdownMenuItem<TipoMovimentacao>(
                              value: tipo,
                              child: Text(tipo.apiValue),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            tipoSelecionado = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: quantidadeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: observacoesController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Observações (opcional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmado != true || !mounted) return;

    final quantidade = int.tryParse(quantidadeController.text.trim());
    if (quantidade == null || quantidade <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe uma quantidade válida'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final ok = await vm.movimentarEstoque(
      produtoId: produtoSelecionado.id!,
      quantidade: quantidade,
      tipo: tipoSelecionado,
      observacoes: observacoesController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Movimentação realizada com sucesso'
              : (vm.error ?? 'Erro ao movimentar estoque'),
        ),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EstoqueDetailViewmodel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Estoque')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            vm.isLoading || vm.isMoving ? null : _abrirMovimentacaoDialog,
        icon: vm.isMoving
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.swap_horiz),
        label: const Text('Movimentar'),
      ),
      body: Builder(builder: (_) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.error != null) return Center(child: Text(vm.error!));
        final estoque = vm.estoque;
        if (estoque == null) {
          return const Center(child: Text('Estoque não encontrado'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          estoque.nome,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(estoque.descricao),
                        const SizedBox(height: 12),
                        Text('Itens: ${estoque.totalItens}'),
                        Text('Produtos: ${estoque.totalProdutos}'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Produtos neste estoque',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (vm.itens.isEmpty)
                const SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Nenhum produto neste estoque ainda'),
                    ),
                  ),
                )
              else
                ...vm.itens.map(
                  (item) => SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: ListTile(
                        title: Text(
                          '#${item.produtoId} - ${vm.getNomeProduto(item.produtoId)}',
                        ),
                        subtitle: Text('Quantidade: ${item.quantidade}'),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
