import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/clientes/data/models/cliente_dto.dart';
import 'package:store_app/features/clientes/data/models/cliente_filtro_dto.dart';
import 'package:store_app/features/clientes/data/models/paged_result.dart';

class ClienteApiService {
  final HttpClient client;

  ClienteApiService(this.client);

  Future<PagedResult<ClienteDto>> getClientes(ClienteFiltroDto filtros) async {
    final result = await client.get(
      'api/Cliente',
      query: filtros.toQuery(),
    );
    final data = client.decode(result) as Map<String, dynamic>;
    return PagedResult.fromJson(
      data,
      (json) => ClienteDto.fromJson(json),
    );
  }
}
