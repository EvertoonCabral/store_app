import 'package:store_app/features/estoques/data/model/estoque_entity.dart';

abstract class EstoqueRepository {
  Future<List<EstoqueEntity>> getEstoques(String token);
}
