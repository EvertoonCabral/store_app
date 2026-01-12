import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/clientes/data/models/cliente_entity.dart';
import 'package:store_app/features/clientes/data/models/cliente_filtro_dto.dart';
import 'package:store_app/features/clientes/data/models/paged_result.dart';

class ClienteApiService {
  final HttpClient client;

  ClienteApiService(this.client);

  Future<PagedResult<ClienteDto>> getClientes(
      ClienteFiltroDto filtros, String token) async {
    final result = await client.get('api/Cliente',
        query: filtros.toQuery(), headers: {'Authorization': 'Bearer $token'});
    final data = client.decode(result) as Map<String, dynamic>;
    return PagedResult.fromJson(
      data,
      (json) => ClienteDto.fromJson(json),
    );
  }

  Future<ClienteDto> getCliente(int id, String token) async {
    final result = await client
        .get('api/Cliente/$id', headers: {'Authorization': 'Bearer $token'});

    final data = client.decode(result) as Map<String, dynamic>;

    return ClienteDto.fromJson(data);
  }
}
