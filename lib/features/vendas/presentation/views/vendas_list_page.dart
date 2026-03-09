import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/app_routes.dart';
import 'package:store_app/core/utils/show_confirm_dialog.dart';
import 'package:store_app/core/widgets/empty_view.dart';
import 'package:store_app/core/widgets/error_view.dart';
import 'package:store_app/core/widgets/loading_view.dart';
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
      context.read<VendasListViewmodel>().retornaVendas();
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
      body: Builder(
        builder: (_) {
          if (vm.isLoading) {
            return const LoadingView();
          }
          if (vm.error != null) {
            return ErrorView(message: vm.error!);
          }
          final items = vm.items;
          if (items.isEmpty) {
            return const EmptyView(message: 'Nenhuma venda encontrada');
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final vendaItem = items[i];
              return VendaCardWidget(
                venda: vendaItem,
                onEdit: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edição de venda em desenvolvimento'),
                    ),
                  );
                },
                onDelete: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final vm = context.read<VendasListViewmodel>();
                  final confirmed = await showConfirmDialog(
                    context,
                    title: 'Confirmar cancelamento',
                    content:
                        'Deseja realmente cancelar a venda #${vendaItem.id}?',
                    confirmLabel: 'Cancelar venda',
                    icon: Icons.cancel_outlined,
                  );
                  if (confirmed) {
                    final ok = await vm.cancelarVenda(
                      vendaItem.id,
                      motivo: 'Cancelada pelo usuário',
                    );
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          ok
                              ? 'Venda #${vendaItem.id} cancelada'
                              : vm.error ?? 'Erro ao cancelar venda',
                        ),
                        backgroundColor: ok ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final vm = context.read<VendasListViewmodel>();
          final resultado = await Navigator.pushNamed(
            context,
            AppRoutes.cadastrarVenda,
          );
          if (resultado == true && mounted) {
            vm.retornaVendas();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Venda cadastrada com sucesso!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
