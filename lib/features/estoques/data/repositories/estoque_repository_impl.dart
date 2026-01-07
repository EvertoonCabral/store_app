import 'package:store_app/features/estoques/data/model/estoque_entity.dart';
import 'package:store_app/features/estoques/data/repositories/estoque_repository.dart';

class EstoqueRepositoryImpl extends EstoqueRepository {
  @override
  Future<List<EstoqueEntity>> getEstoques(String token) {
    throw UnimplementedError();
  }
}
