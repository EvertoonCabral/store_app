import 'package:store_app/features/estoques/data/model/estoque_create_dto.dart';
import 'package:store_app/features/estoques/data/model/estoque_detail_entity.dart';
import 'package:store_app/features/estoques/data/model/estoque_entity.dart';
import 'package:store_app/features/estoques/data/model/item_estoque_entity.dart';

abstract class EstoqueRepository {
  Future<List<EstoqueEntity>> getEstoques(String token);
  Future<void> criarEstoque(String token, EstoqueCreateDto request);
  Future<EstoqueDetailEntity> getEstoqueById(String token, int id);
  Future<List<ItemEstoqueEntity>> getItensEstoque(String token, int estoqueId);
}
