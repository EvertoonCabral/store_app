import 'package:store_app/features/vendas/data/model/venda_entity.dart';

abstract class VendaRepository {
  Future<List<VendaEntity>> getAllVendas(String token);
}
