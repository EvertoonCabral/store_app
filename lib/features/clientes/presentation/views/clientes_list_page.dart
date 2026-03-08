import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/app_routes.dart';
import 'package:store_app/features/clientes/presentation/viewmodel/cliente_list_viewmodel.dart';
import '../widgets/cliente_card_widget.dart';
import '../../data/models/cliente_entity.dart';

class ClientesListPage extends StatefulWidget {
  const ClientesListPage({super.key});

  @override
  State<ClientesListPage> createState() => _ClientesListPageState();
}

class _ClientesListPageState extends State<ClientesListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClienteListViewModel>().retornaClientes();
    });
  }

  Future<void> _showDeleteDialog(ClienteDto cliente) async {
    final vm = context.read<ClienteListViewModel>();

    final acao = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover cliente'),
        content: Text(
          'O que deseja fazer com "${cliente.nome}"?\n\n'
          '• Desativar: mantém o histórico de vendas\n'
          '• Excluir: remoção permanente (só funciona sem vendas)',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'desativar'),
            child: const Text('Desativar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'excluir'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir permanentemente'),
          ),
        ],
      ),
    );

    if (acao == null || !mounted) return;

    bool ok;
    if (acao == 'desativar') {
      ok = await vm.desativarCliente(cliente.id);
    } else {
      ok = await vm.deletarCliente(cliente.id);
      // Se falhou (provavelmente tem vendas), oferecer desativar
      if (!ok && mounted) {
        final fallback = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Não foi possível excluir'),
            content: const Text(
              'Este cliente possui vendas associadas. '
              'Deseja desativá-lo em vez disso?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Desativar'),
              ),
            ],
          ),
        );
        if (fallback == true && mounted) {
          ok = await vm.desativarCliente(cliente.id);
        }
      }
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? (acao == 'desativar'
                ? 'Cliente desativado com sucesso'
                : 'Cliente excluído com sucesso')
            : (vm.error ?? 'Erro ao remover cliente')),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ClienteListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            icon: const Icon(Icons.arrow_back_ios_outlined),
          )
        ],
      ),
      body: Builder(
        builder: (_) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.error != null) {
            return Center(child: Text(viewModel.error!));
          }

          final items = viewModel.page?.items ?? <ClienteDto>[];
          if (items.isEmpty) {
            return const Center(child: Text('Nenhum cliente encontrado'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final c = items[i];
              return ClienteCardWidget(
                cliente: c,
                onEdit: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.editarCliente,
                    arguments: c,
                  );
                },
                onDelete: () => _showDeleteDialog(c),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.cadastrarCliente);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

