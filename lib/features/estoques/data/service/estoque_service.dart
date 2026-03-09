import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/estoques/data/model/estoque_create_dto.dart';
import 'package:store_app/features/estoques/data/model/estoque_detail_entity.dart';
import 'package:store_app/features/estoques/data/model/estoque_entity.dart';
import 'package:store_app/features/estoques/data/model/item_estoque_entity.dart';
import 'package:store_app/features/estoques/data/model/movimentar_estoque_request.dart';

class EstoqueApiService {
  final HttpClient client;

  EstoqueApiService(this.client);

  Future<List<EstoqueEntity>> getAllEstoques() async {
    final result = await client.get('api/Estoque');
    final data = client.decode(result);
    final list = data as List<dynamic>;
    return list
        .map((json) => EstoqueEntity.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> criarEstoque(EstoqueCreateDto request) async {
    await client.post('api/Estoque', body: request.toMap());
  }

  Future<EstoqueDetailEntity> getEstoqueById(int id) async {
    final result = await client.get('api/Estoque/$id');
    final data = client.decode(result);
    return EstoqueDetailEntity.fromMap(data as Map<String, dynamic>);
  }

  Future<List<ItemEstoqueEntity>> getItensEstoque(int estoqueId) async {
    final result =
        await client.get('api/Estoque/estoque/$estoqueId/ObterItensEstoque');
    final data = client.decode(result);
    final list = data as List<dynamic>;
    return list
        .map((json) => ItemEstoqueEntity.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> movimentarEstoque(MovimentarEstoqueRequest request) async {
    await client.post('api/Estoque/MovimentarEstoque', body: request.toMap());
  }
}
