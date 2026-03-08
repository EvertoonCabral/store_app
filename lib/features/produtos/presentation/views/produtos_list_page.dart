import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/app_routes.dart';
import 'package:store_app/features/produtos/presentation/viewmodel/produto_list_viewmodel.dart';
import 'package:store_app/features/produtos/presentation/widgets/produto_card_widget.dart';
import 'package:store_app/core/utils/show_confirm_dialog.dart';
import 'package:store_app/core/widgets/loading_view.dart';
import 'package:store_app/core/widgets/error_view.dart';
import 'package:store_app/core/widgets/empty_view.dart';

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
          return const LoadingView();
        }
        if (vm.error != null) {
          return ErrorView(message: vm.error!);
        }
        final items = vm.items;
        if (items.isEmpty) {
          return const EmptyView(message: 'Nenhum produto encontrado');
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final produtoItem = items[i];
            return ProdutoCardWidget(
              produto: produtoItem,
              onEdit: () async {
                final resultado = await Navigator.pushNamed(
                  context,
                  AppRoutes.editarProduto,
                  arguments: produtoItem,
                );

                if (resultado != null) {
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    context.read<ProdutoListViewmodel>().retornaProdutos();
                  }
                }
              },
              onDelete: () async {
                final messenger = ScaffoldMessenger.of(context);
                final confirmed = await showConfirmDialog(
                  context,
                  title: 'Confirmar excluão',
                  content: 'Deseja realmente excluir "${produtoItem.nome}"?',
                  confirmLabel: 'Excluir',
                  icon: Icons.delete_outline,
                );
                if (confirmed) {
                  // context.read<ProdutoListViewmodel>().deletarProduto(produtoItem.id);
                  messenger.showSnackBar(
                    SnackBar(content: Text('${produtoItem.nome} excluído')),
                  );
                }
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          final vm = context.read<ProdutoListViewmodel>();
          final result = await Navigator.pushNamed(
            context,
            AppRoutes.cadastrarProduto,
          );
          if (result == true && mounted) {
            messenger.showSnackBar(
              const SnackBar(
                content: Text('Produto cadastrado com sucesso!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            vm.retornaProdutos();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
