import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/features/clientes/presentation/viewmodel/cliente_list_viewmodel.dart';
import '../widgets/cliente_card_widget.dart';
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
      context.read<ClienteListViewModel>().retornaClientes();
    });
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
            icon: Icon(Icons.arrow_back_ios_outlined),
          )
        ],
      ),
      body: Builder(
        builder: (_) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (viewModel.error != null) {
            return Center(
              child: Text(viewModel.error!),
            );
          }

          final items = viewModel.page?.items ?? <ClienteDto>[];
          if (items.isEmpty) {
            return const Center(
              child: Text('Nenhum cliente encontrado'),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final c = items[i];
              return ClienteListItem(
                cliente: c,
                onEdit: () {
                  Navigator.of(context).pushReplacementNamed('');
                },
                onDelete: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Excluir: ${c.nome}')),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/cadastrar-cliente');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
