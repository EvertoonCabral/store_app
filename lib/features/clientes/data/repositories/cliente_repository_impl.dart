import 'package:store_app/features/clientes/data/repositories/cliente_repository.dart';
import 'package:store_app/features/clientes/data/services/cliente_api_services.dart';

import '../models/cliente_entity.dart';
import '../models/cliente_filtro_dto.dart';
import '../models/cliente_request_model.dart';
import '../models/paged_result.dart';

class ClientesRepositoryImpl implements ClientesRepository {
  final ClienteApiService api;

  ClientesRepositoryImpl(this.api);

  @override
  Future<PagedResult<ClienteDto>> getClientes(ClienteFiltroDto filtros) {
    return api.getClientes(filtros);
  }

  @override
  Future<ClienteDto> getCliente(int id) {
    return api.getCliente(id);
  }

  @override
  Future<ClienteDto> createCliente(ClienteRequestModel request) {
    return api.createCliente(request);
  }

  @override
  Future<ClienteDto> updateCliente(int id, ClienteRequestModel request) {
    return api.updateCliente(id, request);
  }

  @override
  Future<void> deleteCliente(int id) {
    return api.deleteCliente(id);
  }

  @override
  Future<void> desativarCliente(int id) {
    return api.desativarCliente(id);
  }
}

