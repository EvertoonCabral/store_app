import 'package:store_app/features/estoques/data/model/estoque_entity.dart';
import 'package:store_app/features/estoques/data/repositories/estoque_repository.dart';
import 'package:store_app/features/estoques/data/service/estoque_service.dart';

class EstoqueRepositoryImpl extends EstoqueRepository {
  final EstoqueApiService apiService;

  EstoqueRepositoryImpl(this.apiService);

  @override
  Future<List<EstoqueEntity>> getEstoques(String token) async {
    return await apiService.getAllEstoques(token);
  }
}
