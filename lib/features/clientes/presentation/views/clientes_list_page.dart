import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/features/clientes/presentation/viewmodels/cliente_list_viewmodel.dart';
import '../widgets/cliente_list_item.dart';
import '../../data/models/cliente_dto.dart';

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
      context.read<ClienteListViewModel>().fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClienteListViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: Builder(builder: (_) {
        if (vm.isLoading)
          return const Center(child: CircularProgressIndicator());
        if (vm.error != null) return Center(child: Text(vm.error!));

        final items = vm.page?.items ?? <ClienteDto>[];
        if (items.isEmpty)
          return const Center(child: Text('Nenhum cliente encontrado'));

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final c = items[i];
            return ClienteListItem(
              cliente: c,
              onEdit: () {
                // Navegação para tela de edição (implementará depois)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Editar: ${c.nome}')),
                );
              },
              onDelete: () {
                // Confirmação/exclusão será implementada depois
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Excluir: ${c.nome}')),
                );
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para tela de criação (implementará depois)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ir para novo cliente')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
