import 'package:flutter/material.dart';
import 'package:store_app/features/clientes/data/models/cliente_dto.dart';
import 'package:store_app/features/clientes/data/models/cliente_filtro_dto.dart';
import 'package:store_app/features/clientes/data/models/paged_result.dart';
import 'package:store_app/features/clientes/data/repositories/cliente_repository.dart';

class ClienteListViewModel extends ChangeNotifier {
  final ClientesRepository repository;

  ClienteListViewModel(this.repository);

  bool isLoading = false;
  String? error;
  PagedResult<ClienteDto>? page;

  Future<void> fetch(
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
}
