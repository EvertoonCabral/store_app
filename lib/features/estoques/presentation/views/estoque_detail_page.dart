import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/features/estoques/presentation/viewmodel/estoque_detail_viewmodel.dart';

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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EstoqueDetailViewmodel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Estoque')),
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(estoque.nome,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(estoque.descricao),
                    ],
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
