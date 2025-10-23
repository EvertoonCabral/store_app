import 'package:store_app/features/clientes/data/models/cliente_dto.dart';
import 'package:store_app/features/clientes/data/models/cliente_filtro_dto.dart';
import 'package:store_app/features/clientes/data/models/paged_result.dart';

abstract class ClientesRepository {
  Future<PagedResult<ClienteDto>> getClientes(ClienteFiltroDto filtros);
}
