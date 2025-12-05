import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            icon: Icon(Icons.arrow_back_ios_outlined),
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
              onEdit: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Editar: ${p.nome}')),
                );
              },
              onDelete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Excluir: ${p.nome}')),
                );
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/cadastrar-cliente');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
