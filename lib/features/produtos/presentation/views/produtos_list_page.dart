import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/app_routes.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/presentation/viewmodel/produto_list_viewmodel.dart';
import 'package:store_app/features/produtos/presentation/widgets/produto_card_widget.dart';

class ProdutosListPage extends StatefulWidget {
  const ProdutosListPage({super.key});

  @override
  State<ProdutosListPage> createState() => _ProdutoListPageState();
}

class _ProdutoListPageState extends State<ProdutosListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProdutoListViewmodel>().retornaProdutos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProdutoListViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
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
        final items = vm.result?.items ?? <ProdutoEntity>[];
        if (items.isEmpty) {
          return const Center(
            child: Text('Nenhum produto encontrado'),
          );
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final p = items[i];
            return ProdutoCardWidget(
              produto: p,
              onEdit: () async {
                final resultado = await Navigator.pushNamed(
                  context,
                  AppRoutes.editarProduto,
                  arguments: p,
                );

                if (resultado != null) {
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    context.read<ProdutoListViewmodel>().retornaProdutos();
                  }
                }
              },
              onDelete: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Confirmar exclusão'),
                    content: Text('Deseja realmente excluir "${p.nome}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          // Aqui você chama o método de deletar do viewmodel
                          // context.read<ProdutoListViewmodel>().deletarProduto(p.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${p.nome} excluído')),
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
          // Navega para cadastrar produto
          final resultado = await Navigator.pushNamed(
            context,
            AppRoutes.cadastrarProduto,
          );

          // Se retornou algo (produto criado), recarrega a lista
          if (resultado != null) {
            if (mounted) {
              // ignore: use_build_context_synchronously
              context.read<ProdutoListViewmodel>().retornaProdutos();
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
