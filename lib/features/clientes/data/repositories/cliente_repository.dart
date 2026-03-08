import 'package:store_app/features/clientes/data/models/cliente_entity.dart';
import 'package:store_app/features/clientes/data/models/cliente_filtro_dto.dart';
import 'package:store_app/features/clientes/data/models/cliente_request_model.dart';
import 'package:store_app/features/clientes/data/models/paged_result.dart';

abstract class ClientesRepository {
  Future<PagedResult<ClienteDto>> getClientes(ClienteFiltroDto filtros);
  Future<ClienteDto> getCliente(int id);
  Future<ClienteDto> createCliente(ClienteRequestModel request);
  Future<ClienteDto> updateCliente(int id, ClienteRequestModel request);
  Future<void> deleteCliente(int id);
  Future<void> desativarCliente(int id);
}

