import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/features/estoques/presentation/viewmodel/estoque_viewmodel.dart';
import 'package:store_app/features/estoques/presentation/widgets/Estoque_add_bottom_sheet.dart';
import 'package:store_app/features/estoques/presentation/widgets/estoque_card_widget.dart';

class EstoqueListPage extends StatefulWidget {
  const EstoqueListPage({super.key});

  @override
  State<EstoqueListPage> createState() => _EstoqueListPageState();
}

class _EstoqueListPageState extends State<EstoqueListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EstoqueViewmodel>().retornaEstoques();
    });
  }

  Future<void> _openAddSheet() async {
    final vm = context.read<EstoqueViewmodel>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => EstoqueAddBottomSheet(
        onSubmit: (nome, descricao) async {
          return await vm.criarEstoque(nome, descricao);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EstoqueViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estoques'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            icon: const Icon(Icons.arrow_back_ios_outlined),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSheet,
        child: const Icon(Icons.add),
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
                      onPressed: vm.retornaEstoques,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final items = vm.items;
          if (items.isEmpty) {
            return const Center(child: Text('Nenhum estoque encontrado.'));
          }

          return RefreshIndicator(
            onRefresh: vm.retornaEstoques,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final estoque = items[index];
                return EstoqueCardWidget(
                  estoque: estoque,
                  onEdit: () {
                    // TODO
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
