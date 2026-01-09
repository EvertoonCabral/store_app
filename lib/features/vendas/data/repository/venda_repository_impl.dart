import 'package:store_app/features/vendas/data/model/venda_detail.dart';
import 'package:store_app/features/vendas/data/model/venda_entity.dart';
import 'package:store_app/features/vendas/data/repository/venda_repository.dart';
import 'package:store_app/features/vendas/data/services/venda_api_service.dart';

class VendaRepositoryImpl implements VendaRepository {
  VendaApiService api;

  VendaRepositoryImpl(this.api);

  @override
  Future<List<VendaEntity>> getAllVendas(String token) {
    return api.getAllVendas(token);
  }

  @override
  Future<VendaDetailEntity> getVendaByid(String token, int id) {
    return api.getVenda(id, token);
  }
}
