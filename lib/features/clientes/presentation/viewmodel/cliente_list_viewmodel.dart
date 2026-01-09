import 'package:flutter/material.dart';
import 'package:store_app/features/clientes/data/models/cliente_dto.dart';
import 'package:store_app/features/clientes/data/models/cliente_filtro_dto.dart';
import 'package:store_app/features/clientes/data/models/paged_result.dart';
import 'package:store_app/features/clientes/data/repositories/cliente_repository.dart';
import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';

class ClienteListViewModel extends ChangeNotifier {
  final ClientesRepository repository;
  final AuthViewModel authViewModel;

  ClienteListViewModel(this.repository, this.authViewModel);

  bool isLoading = false;
  String? error;
  PagedResult<ClienteDto>? page;

  Future<void> retornaClientes(
      {ClienteFiltroDto filtros = const ClienteFiltroDto()}) async {
    final token = authViewModel.token;
    if (token == null || token.isEmpty) {
      error = 'Usuário não autenticado';
      notifyListeners();
      return;
    }
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      page = await repository.getClientes(filtros, token);
    } catch (e) {
      error = 'Erro ao carregar clientes';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<ClienteDto?> retornaClientePorId(int id) async {
    final token = authViewModel.token;
    if (token == null || token.isEmpty) {
      return null;
    }

    try {
      return await repository.getCliente(id, token);
    } catch (e) {
      return null;
    }
  }
}
