import 'package:store_app/features/vendas/data/model/create_venda_request.dart';
import 'package:store_app/features/vendas/data/model/venda_detail.dart';
import 'package:store_app/features/vendas/data/model/venda_entity.dart';

abstract class VendaRepository {
  Future<List<VendaEntity>> getAllVendas();
  Future<VendaDetailEntity> getVendaByid(int id);
  Future<void> cadastrarVenda(VendaRequestModel request);
  Future<bool> deleteVenda(int id);
}
