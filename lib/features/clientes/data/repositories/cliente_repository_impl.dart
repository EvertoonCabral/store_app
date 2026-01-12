import 'package:store_app/features/clientes/data/repositories/cliente_repository.dart';
import 'package:store_app/features/clientes/data/services/cliente_api_services.dart';

import '../models/cliente_entity.dart';
import '../models/paged_result.dart';
import '../models/cliente_filtro_dto.dart';

class ClientesRepositoryImpl implements ClientesRepository {
  final ClienteApiService api;
  ClientesRepositoryImpl(this.api);

  @override
  Future<PagedResult<ClienteDto>> getClientes(
      ClienteFiltroDto filtros, String token) {
    return api.getClientes(filtros, token);
  }

  @override
  Future<ClienteDto> getCliente(int id, String token) {
    return api.getCliente(id, token);
  }
}
