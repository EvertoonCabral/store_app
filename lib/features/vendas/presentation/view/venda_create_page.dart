import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store_app/features/clientes/data/models/cliente_entity.dart';
import 'package:store_app/features/clientes/presentation/viewmodel/cliente_list_viewmodel.dart';
import 'package:store_app/features/estoques/data/model/estoque_entity.dart';
import 'package:store_app/features/estoques/presentation/viewmodel/estoque_viewmodel.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/presentation/viewmodel/produto_list_viewmodel.dart';
import 'package:store_app/features/vendas/presentation/viewmodel/cadastrar_venda_viewmodel.dart';

class VendaCadastroPage extends StatefulWidget {
  const VendaCadastroPage({super.key});

  @override
  State<VendaCadastroPage> createState() => _VendaCadastroPageState();
}

class _VendaCadastroPageState extends State<VendaCadastroPage> {
  final _descontoController = TextEditingController();
  final _observacoesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClienteListViewModel>().retornaClientes();
      context.read<EstoqueViewmodel>().retornaEstoques();
      context.read<ProdutoListViewmodel>().retornaProdutos();
    });
  }

  @override
  void dispose() {
    _descontoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _selecionarCliente() async {
    final clienteVm = context.read<ClienteListViewModel>();
    final clientes = clienteVm.page?.items ?? [];

    if (clientes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum cliente disponível')),
      );
      return;
    }

    final ClienteDto? selected = await showDialog(
      context: context,
      builder: (context) => _ClienteSelectionDialog(clientes: clientes),
    );

    if (selected != null && mounted) {
      context.read<VendaCadastroViewmodel>().selecionarCliente(selected);
    }
  }

  Future<void> _selecionarEstoque() async {
    final estoqueVm = context.read<EstoqueViewmodel>();
    final estoques = estoqueVm.items;

    if (estoques.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum estoque disponível')),
      );
      return;
    }

    final EstoqueEntity? selected = await showDialog(
      context: context,
      builder: (context) => _EstoqueSelectionDialog(estoques: estoques),
    );

    if (selected != null && mounted) {
      context.read<VendaCadastroViewmodel>().selecionarEstoque(selected);
    }
  }

  Future<void> _adicionarProduto() async {
    final produtoVm = context.read<ProdutoListViewmodel>();
    final produtos = produtoVm.items;

    if (produtos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum produto disponível')),
      );
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _ProdutoSelectionDialog(produtos: produtos),
    );

    if (result != null && mounted) {
      context.read<VendaCadastroViewmodel>().adicionarItem(
            result['produto'] as ProdutoEntity,
            result['quantidade'] as int,
          );
    }
  }

  Future<void> _finalizarVenda() async {
    final vm = context.read<VendaCadastroViewmodel>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Venda'),
        content: Text(
          'Deseja cadastrar esta venda?\n\n'
          'Cliente: ${vm.clienteSelecionado?.nome}\n'
          'Estoque: ${vm.estoqueSelecionado?.nome}\n'
          'Total: R\$ ${vm.valorTotal.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final sucesso = await vm.cadastrarVenda();

      if (mounted) {
        if (sucesso) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Venda cadastrada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                vm.error ?? 'Erro ao cadastrar venda',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VendaCadastroViewmodel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Venda'),
        actions: [
          if (vm.itens.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Limpar Venda'),
                    content: const Text('Deseja limpar todos os dados?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          vm.limpar();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Limpar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cliente
                  _buildSectionTitle('Cliente'),
                  const SizedBox(height: 8),
                  _buildSelectionCard(
                    icon: Icons.person,
                    label: vm.clienteSelecionado != null
                        ? '#${vm.clienteSelecionado!.id} - ${vm.clienteSelecionado!.nome}'
                        : 'Selecione o Cliente',
                    subtitle: vm.clienteSelecionado?.cpf,
                    onTap: _selecionarCliente,
                    isSelected: vm.clienteSelecionado != null,
                  ),

                  const SizedBox(height: 16),

                  // Estoque
                  _buildSectionTitle('Estoque'),
                  const SizedBox(height: 8),
                  _buildSelectionCard(
                    icon: Icons.warehouse,
                    label: vm.estoqueSelecionado != null
                        ? '#${vm.estoqueSelecionado!.id} - ${vm.estoqueSelecionado!.nome}'
                        : 'Selecionar Estoque',
                    subtitle: vm.estoqueSelecionado?.descricao,
                    onTap: _selecionarEstoque,
                    isSelected: vm.estoqueSelecionado != null,
                  ),

                  const SizedBox(height: 16),

                  // Produtos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Produtos'),
                      TextButton.icon(
                        onPressed: _adicionarProduto,
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (vm.itens.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Nenhum produto adicionado',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    ...vm.itens.map((item) => _buildItemCard(item, vm)),

                  // Campos adicionais (só aparecem se tiver itens)
                  if (vm.podeExibirCampos) ...[
                    const SizedBox(height: 16),
                    _buildSectionTitle('Informações Adicionais'),
                    const SizedBox(height: 8),

                    // Desconto
                    TextField(
                      controller: _descontoController,
                      decoration: const InputDecoration(
                        labelText: 'Desconto (R\$)',
                        prefixIcon: Icon(Icons.discount),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      onChanged: (value) {
                        final desconto = double.tryParse(value) ?? 0;
                        vm.setDesconto(desconto);
                      },
                    ),

                    const SizedBox(height: 12),

                    // Observações
                    TextField(
                      controller: _observacoesController,
                      decoration: const InputDecoration(
                        labelText: 'Observações',
                        prefixIcon: Icon(Icons.notes),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: vm.setObservacoes,
                    ),

                    const SizedBox(height: 16),

                    // Resumo
                    Card(
                      color: theme.colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildResumoRow('Subtotal', vm.subtotal),
                            if (vm.desconto > 0) ...[
                              const Divider(),
                              _buildResumoRow('Desconto', vm.desconto,
                                  isDesconto: true),
                            ],
                            const Divider(thickness: 2),
                            _buildResumoRow('Total', vm.valorTotal,
                                isTotal: true),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botão Finalizar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _finalizarVenda,
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text(
                          'Finalizar Venda',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSelectionCard({
    required IconData icon,
    required String label,
    String? subtitle,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return Card(
      elevation: isSelected ? 3 : 1,
      color: isSelected ? Colors.green.shade50 : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.green : null,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : null,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: Icon(
          isSelected ? Icons.check_circle : Icons.arrow_forward_ios,
          color: isSelected ? Colors.green : null,
          size: isSelected ? 24 : 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildItemCard(ItemVendaTemp item, VendaCadastroViewmodel vm) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${item.produto.id} - ${item.produto.nome}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'R\$ ${item.precoUnitario.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => vm.removerItem(item.produto.id),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => vm.atualizarQuantidade(
                    item.produto.id,
                    item.quantidade - 1,
                  ),
                ),
                Text(
                  '${item.quantidade}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => vm.atualizarQuantidade(
                    item.produto.id,
                    item.quantidade + 1,
                  ),
                ),
                const Spacer(),
                Text(
                  'Subtotal: R\$ ${item.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoRow(String label, double valor,
      {bool isDesconto = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : null,
          ),
        ),
        Text(
          '${isDesconto ? '- ' : ''}R\$ ${valor.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isDesconto ? Colors.red : null,
          ),
        ),
      ],
    );
  }
}

// Dialogs com busca
class _ClienteSelectionDialog extends StatefulWidget {
  final List<ClienteDto> clientes;

  const _ClienteSelectionDialog({required this.clientes});

  @override
  State<_ClienteSelectionDialog> createState() =>
      _ClienteSelectionDialogState();
}

class _ClienteSelectionDialogState extends State<_ClienteSelectionDialog> {
  final _searchController = TextEditingController();
  List<ClienteDto> _clientesFiltrados = [];

  @override
  void initState() {
    super.initState();
    _clientesFiltrados = widget.clientes;
    _searchController.addListener(_filtrar);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filtrar() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _clientesFiltrados = widget.clientes;
      } else {
        _clientesFiltrados = widget.clientes.where((cliente) {
          final nome = cliente.nome.toLowerCase();
          final cpf = (cliente.cpf ?? '').toLowerCase();
          return nome.contains(query) || cpf.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecionar Cliente'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar cliente',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _clientesFiltrados.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            'Nenhum cliente encontrado',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _clientesFiltrados.length,
                      itemBuilder: (context, index) {
                        final cliente = _clientesFiltrados[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                cliente.nome[0].toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text('#${cliente.id} - ${cliente.nome}'),
                            subtitle: Text(cliente.cpf ?? 'Sem CPF'),
                            onTap: () => Navigator.pop(context, cliente),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}

class _EstoqueSelectionDialog extends StatefulWidget {
  final List<EstoqueEntity> estoques;

  const _EstoqueSelectionDialog({required this.estoques});

  @override
  State<_EstoqueSelectionDialog> createState() =>
      _EstoqueSelectionDialogState();
}

class _EstoqueSelectionDialogState extends State<_EstoqueSelectionDialog> {
  final _searchController = TextEditingController();
  List<EstoqueEntity> _estoquesFiltrados = [];

  @override
  void initState() {
    super.initState();
    _estoquesFiltrados = widget.estoques;
    _searchController.addListener(_filtrar);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filtrar() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _estoquesFiltrados = widget.estoques;
      } else {
        _estoquesFiltrados = widget.estoques.where((estoque) {
          final nome = estoque.nome.toLowerCase();
          final descricao = (estoque.descricao).toLowerCase();
          return nome.contains(query) || descricao.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecionar Estoque'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar estoque',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _estoquesFiltrados.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            'Nenhum estoque encontrado',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _estoquesFiltrados.length,
                      itemBuilder: (context, index) {
                        final estoque = _estoquesFiltrados[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.warehouse),
                            ),
                            title: Text('#${estoque.id} - ${estoque.nome}'),
                            subtitle: Text(estoque.descricao),
                            onTap: () => Navigator.pop(context, estoque),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}

class _ProdutoSelectionDialog extends StatefulWidget {
  final List<ProdutoEntity> produtos;

  const _ProdutoSelectionDialog({required this.produtos});

  @override
  State<_ProdutoSelectionDialog> createState() =>
      _ProdutoSelectionDialogState();
}

class _ProdutoSelectionDialogState extends State<_ProdutoSelectionDialog> {
  final _searchController = TextEditingController();
  final _quantidadeController = TextEditingController(text: '1');
  List<ProdutoEntity> _produtosFiltrados = [];
  ProdutoEntity? _produtoSelecionado;

  @override
  void initState() {
    super.initState();
    _produtosFiltrados = widget.produtos;
    _searchController.addListener(_filtrar);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  void _filtrar() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _produtosFiltrados = widget.produtos;
      } else {
        _produtosFiltrados = widget.produtos.where((produto) {
          final nome = produto.nome.toLowerCase();
          final marca = produto.marca.toLowerCase();
          final descricao = (produto.descricao ?? '').toLowerCase();
          return nome.contains(query) ||
              marca.contains(query) ||
              descricao.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Produto'),
      content: SizedBox(
        width: double.maxFinite,
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Campo de busca
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar produto',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),

            // Lista de produtos
            Expanded(
              child: _produtosFiltrados.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            'Nenhum produto encontrado',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _produtosFiltrados.length,
                      itemBuilder: (context, index) {
                        final produto = _produtosFiltrados[index];
                        final isSelected =
                            _produtoSelecionado?.id == produto.id;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          color: isSelected ? Colors.blue.shade50 : null,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  isSelected ? Colors.blue : Colors.grey[300],
                              child: Icon(
                                isSelected ? Icons.check : Icons.shopping_bag,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[700],
                              ),
                            ),
                            title: Text(
                              '#${produto.id} - ${produto.nome}',
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(produto.marca),
                                Text(
                                  'R\$ ${produto.precoVenda.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle,
                                    color: Colors.blue)
                                : null,
                            onTap: () {
                              setState(() {
                                _produtoSelecionado = produto;
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 12),

            // Quantidade
            TextField(
              controller: _quantidadeController,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                prefixIcon: Icon(Icons.numbers),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),

            if (_produtoSelecionado != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Preço Unitário:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'R\$ ${_produtoSelecionado!.precoVenda.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_produtoSelecionado == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Selecione um produto')),
              );
              return;
            }

            final quantidade = int.tryParse(_quantidadeController.text) ?? 1;
            if (quantidade <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quantidade inválida')),
              );
              return;
            }

            Navigator.pop(context, {
              'produto': _produtoSelecionado,
              'quantidade': quantidade,
            });
          },
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}
