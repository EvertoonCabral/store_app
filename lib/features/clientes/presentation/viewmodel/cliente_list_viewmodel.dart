import 'package:flutter/material.dart';
import 'package:store_app/features/clientes/data/models/cliente_entity.dart';
import 'package:store_app/features/clientes/data/models/cliente_filtro_dto.dart';
import 'package:store_app/features/clientes/data/models/cliente_request_model.dart';
import 'package:store_app/features/clientes/data/models/paged_result.dart';
import 'package:store_app/features/clientes/data/repositories/cliente_repository.dart';

class ClienteListViewModel extends ChangeNotifier {
  final ClientesRepository repository;

  ClienteListViewModel(this.repository);

  bool isLoading = false;
  bool isSubmitting = false;
  String? error;
  PagedResult<ClienteDto>? page;

  Future<void> retornaClientes(
      {ClienteFiltroDto filtros = const ClienteFiltroDto()}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      page = await repository.getClientes(filtros);
    } catch (e) {
      error = 'Erro ao carregar clientes';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<ClienteDto?> retornaClientePorId(int id) async {
    try {
      return await repository.getCliente(id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> cadastrarCliente(ClienteRequestModel request) async {
    try {
      isSubmitting = true;
      error = null;
      notifyListeners();

      await repository.createCliente(request);
      await retornaClientes();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> atualizarCliente(int id, ClienteRequestModel request) async {
    try {
      isSubmitting = true;
      error = null;
      notifyListeners();

      await repository.updateCliente(id, request);
      await retornaClientes();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> deletarCliente(int id) async {
    try {
      await repository.deleteCliente(id);
      page?.items.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> desativarCliente(int id) async {
    try {
      await repository.desativarCliente(id);
      await retornaClientes();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}

