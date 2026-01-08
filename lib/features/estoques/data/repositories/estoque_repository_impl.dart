import 'package:store_app/features/estoques/data/model/estoque_create_dto.dart';
import 'package:store_app/features/estoques/data/model/estoque_detail_entity.dart';
import 'package:store_app/features/estoques/data/model/estoque_entity.dart';
import 'package:store_app/features/estoques/data/model/item_estoque_entity.dart';
import 'package:store_app/features/estoques/data/repositories/estoque_repository.dart';
import 'package:store_app/features/estoques/data/service/estoque_service.dart';

class EstoqueRepositoryImpl extends EstoqueRepository {
  final EstoqueApiService apiService;

  EstoqueRepositoryImpl(this.apiService);

  @override
  Future<List<EstoqueEntity>> getEstoques(String token) async {
    return await apiService.getAllEstoques(token);
  }

  @override
  Future<void> criarEstoque(String token, EstoqueCreateDto request) async {
    await apiService.criarEstoque(token, request);
  }

  @override
  Future<EstoqueDetailEntity> getEstoqueById(String token, int id) async {
    return await apiService.getEstoqueById(token, id);
  }

  @override
  Future<List<ItemEstoqueEntity>> getItensEstoque(
      String token, int estoqueId) async {
    return await apiService.getItensEstoque(token, estoqueId);
  }
}
