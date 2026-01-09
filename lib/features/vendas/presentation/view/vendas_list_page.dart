import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/features/vendas/presentation/viewmodel/vendas_list_viewmodel.dart';
import 'package:store_app/features/vendas/presentation/widgets/venda_card_widget.dart';

class VendasListPage extends StatefulWidget {
  const VendasListPage({super.key});

  @override
  State<VendasListPage> createState() => _VendasListPageState();
}

class _VendasListPageState extends State<VendasListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendasListViewmodel>().retornaProdutos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VendasListViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendas'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            icon: const Icon(Icons.arrow_back_ios_outlined),
          )
        ],
      ),
      body: Builder(builder: (_) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.error != null) {
          return Center(
            child: Text(vm.error!),
          );
        }
        final items = vm.items;
        if (items.isEmpty) {
          return const Center(
            child: Text('Nenhuma venda encontrada'),
          );
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final vendaItem = items[i];
            return VendaCardWidget(
              venda: vendaItem,
              onEdit: () async {
                // Navegação para editar venda (se houver rota)
                // final resultado = await Navigator.pushNamed(
                //   context,
                //   AppRoutes.editarVenda,
                //   arguments: vendaItem,
                // );
                // if (resultado != null && mounted) {
                //   context.read<VendasListViewmodel>().retornaProdutos();
                // }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Edição de venda em desenvolvimento')),
                );
              },
              onDelete: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Confirmar exclusão'),
                    content: Text(
                        'Deseja realmente excluir a venda #${vendaItem.id}?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          // Aqui você chama o método de deletar do viewmodel
                          // context.read<VendasListViewmodel>().deletarVenda(vendaItem.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Venda #${vendaItem.id} excluída')),
                          );
                        },
                        child: const Text(
                          'Excluir',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navega para cadastrar venda
          // final resultado = await Navigator.pushNamed(
          //   context,
          //   AppRoutes.cadastrarVenda,
          // );
          // if (resultado != null && mounted) {
          //   context.read<VendasListViewmodel>().retornaProdutos();
          // }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Cadastro de venda em desenvolvimento')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
