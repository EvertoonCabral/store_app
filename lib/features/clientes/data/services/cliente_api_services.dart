import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/clientes/data/models/cliente_entity.dart';
import 'package:store_app/features/clientes/data/models/cliente_filtro_dto.dart';
import 'package:store_app/features/clientes/data/models/cliente_request_model.dart';
import 'package:store_app/features/clientes/data/models/paged_result.dart';

class ClienteApiService {
  final HttpClient client;

  ClienteApiService(this.client);

  Future<PagedResult<ClienteDto>> getClientes(ClienteFiltroDto filtros) async {
    final result = await client.get('api/Cliente', query: filtros.toQuery());
    final data = client.decode(result) as Map<String, dynamic>;
    return PagedResult.fromJson(data, (json) => ClienteDto.fromJson(json));
  }

  Future<ClienteDto> getCliente(int id) async {
    final result = await client.get('api/Cliente/$id');
    final data = client.decode(result) as Map<String, dynamic>;
    return ClienteDto.fromJson(data);
  }

  Future<ClienteDto> createCliente(ClienteRequestModel request) async {
    final result = await client.post('api/Cliente', body: request.toJson());
    final data = client.decode(result) as Map<String, dynamic>;
    return ClienteDto.fromJson(data);
  }

  Future<ClienteDto> updateCliente(int id, ClienteRequestModel request) async {
    final result =
        await client.put('api/Cliente/$id', body: request.toJson());
    final data = client.decode(result) as Map<String, dynamic>;
    return ClienteDto.fromJson(data);
  }

  Future<void> deleteCliente(int id) async {
    await client.delete('api/Cliente/$id');
  }

  Future<void> desativarCliente(int id) async {
    await client.patch('api/Cliente/$id/desativar');
  }
}

