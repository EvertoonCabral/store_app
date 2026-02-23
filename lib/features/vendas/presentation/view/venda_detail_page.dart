import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:store_app/features/clientes/data/models/cliente_entity.dart';
import 'package:store_app/features/clientes/presentation/viewmodel/cliente_list_viewmodel.dart';
import 'package:store_app/features/vendas/data/model/status_venda.dart';
import 'package:store_app/features/vendas/data/model/venda_detail.dart';
import 'package:store_app/features/vendas/presentation/viewmodel/vendas_list_viewmodel.dart';

class VendaDetailPage extends StatefulWidget {
  final int vendaId;

  const VendaDetailPage({
    super.key,
    required this.vendaId,
  });

  @override
  State<VendaDetailPage> createState() => _VendaDetailPageState();
}

class _VendaDetailPageState extends State<VendaDetailPage> {
  VendaDetailEntity? _venda;
  ClienteDto? _cliente;
  bool _isLoading = true;
  bool _isLoadingCliente = false;
  String? _error;

  // ✅ ADICIONE ESTES GETTERS AQUI (logo após as variáveis de estado)
  double get _subtotalItens {
    if (_venda == null) return 0;

    return _venda!.itensVenda.fold(
      0,
      (total, item) => total + (item.precoUnitario) * item.quantidade,
    );
  }

  double get _totalVenda {
    return _subtotalItens - (_venda?.desconto ?? 0);
  }
  // ✅ FIM DOS GETTERS

  @override
  void initState() {
    super.initState();
    _carregarVenda();
  }

  Future<void> _carregarVenda() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final vm = context.read<VendasListViewmodel>();
    final venda = await vm.retornaVenda(widget.vendaId);

    setState(() {
      _venda = venda;
      _isLoading = false;
      if (venda == null) {
        _error = 'Venda não encontrada';
      }
    });

    // Carrega o cliente se a venda foi encontrada
    if (venda != null) {
      _carregarCliente(venda.clienteId);
    }
  }

  Future<void> _carregarCliente(int clienteId) async {
    setState(() {
      _isLoadingCliente = true;
    });

    final clienteVm = context.read<ClienteListViewModel>();
    final cliente = await clienteVm.retornaClientePorId(clienteId);

    setState(() {
      _cliente = cliente;
      _isLoadingCliente = false;
    });
  }

  Color _getStatusColor(StatusVenda status) {
    switch (status) {
      case StatusVenda.pendente:
        return Colors.orange;
      case StatusVenda.finalizada:
        return Colors.green;
      case StatusVenda.cancelada:
        return Colors.red;
    }
  }

  String _getStatusLabel(StatusVenda status) {
    switch (status) {
      case StatusVenda.pendente:
        return 'Pendente';
      case StatusVenda.finalizada:
        return 'Finalizada';
      case StatusVenda.cancelada:
        return 'Cancelada';
    }
  }

  void _finalizarVenda() {
    if (_venda == null) return;

    if (_venda!.status == StatusVenda.finalizada) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Esta venda já está finalizada')),
      );
      return;
    }

    if (_venda!.status == StatusVenda.cancelada) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Esta venda está cancelada')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Finalizar Venda'),
        content: Text(
          'Deseja realmente finalizar a venda #${_venda!.id}?\n\n'
          'Valor Total: R\$ ${_totalVenda.toStringAsFixed(2)}', // ✅ AJUSTADO
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Aqui você chama o método de finalizar do viewmodel
              // context.read<VendasListViewmodel>().finalizarVenda(_venda!.id);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Venda #${_venda!.id} finalizada com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );

              // Volta para a lista
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text('Venda #${widget.vendaId}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error!, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _carregarVenda,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
              : _venda == null
                  ? const Center(child: Text('Venda não encontrada'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card de Status
                          Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(
                                    _venda!.status == StatusVenda.finalizada
                                        ? Icons.check_circle
                                        : _venda!.status ==
                                                StatusVenda.cancelada
                                            ? Icons.cancel
                                            : Icons.pending,
                                    color: _getStatusColor(_venda!.status),
                                    size: 32,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Status',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          _getStatusLabel(_venda!.status),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                _getStatusColor(_venda!.status),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Informações da Venda
                          const Text(
                            'Informações da Venda',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  _buildInfoRow(
                                    icon: Icons.calendar_today,
                                    label: 'Data da Venda',
                                    value: dateFormat.format(_venda!.dataVenda),
                                  ),
                                  const Divider(height: 24),
                                  _buildInfoRow(
                                    icon: Icons.person,
                                    label: 'Vendedor',
                                    value: _venda!.usuarioVendedor,
                                  ),
                                  const Divider(height: 24),
                                  _buildClienteRow(),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ✅ ITENS DA VENDA (MOVIDO PARA CIMA)
                          const Text(
                            'Itens da Venda',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          if (_venda!.itensVenda.isEmpty)
                            Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Center(
                                  child: Text(
                                    'Nenhum item na venda',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else
                            Card(
                              elevation: 2,
                              child: Column(
                                children: [
                                  // Cabeçalho da tabela
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          flex: 3,
                                          child: Text(
                                            'Produto',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Qtd',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Preço Un.',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Subtotal',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Lista de itens
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _venda!.itensVenda.length,
                                    separatorBuilder: (context, index) =>
                                        const Divider(height: 1),
                                    itemBuilder: (context, index) {
                                      final item = _venda!.itensVenda[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.nomeProduto ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    '#${item.produtoId}',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                '${item.quantidade}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                'R\$ ${item.precoUnitario.toStringAsFixed(2)}',
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                    fontSize: 13),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                'R\$ ${item.subTotal?.toStringAsFixed(2)}',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      theme.colorScheme.primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 16),

                          // ✅ VALORES (AGORA ABAIXO DOS ITENS)
                          const Text(
                            'Valores',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  _buildValorRow(
                                    label: 'Subtotal',
                                    valor: _subtotalItens, // ✅ AJUSTADO
                                    isSubtotal: true,
                                  ),
                                  if (_venda!.desconto > 0) ...[
                                    const Divider(height: 24),
                                    _buildValorRow(
                                      label: 'Desconto',
                                      valor: _venda!.desconto,
                                      isDesconto: true,
                                    ),
                                  ],
                                  const Divider(height: 24, thickness: 2),
                                  _buildValorRow(
                                    label: 'Total',
                                    valor: _totalVenda, // ✅ AJUSTADO
                                    isTotal: true,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Botão Finalizar Venda
                          if (_venda!.status == StatusVenda.pendente)
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildClienteRow() {
    return Row(
      children: [
        Icon(Icons.badge, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cliente',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              if (_isLoadingCliente)
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (_cliente != null) ...[
                Text(
                  '#${_venda!.clienteId} - ${_cliente!.nome}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_cliente!.cpf != null && _cliente!.cpf!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'CPF: ${_cliente!.cpf}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ] else
                Text(
                  '#${_venda!.clienteId} - Cliente não encontrado',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildValorRow({
    required String label,
    required double valor,
    bool isSubtotal = false,
    bool isDesconto = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDesconto ? Colors.red : null,
          ),
        ),
        Text(
          '${isDesconto ? '- ' : ''}R\$ ${valor.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 20 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isDesconto
                ? Colors.red
                : isTotal
                    ? Theme.of(context).colorScheme.primary
                    : isSubtotal
                        ? Colors.grey[600]
                        : null,
          ),
        ),
      ],
    );
  }
}
