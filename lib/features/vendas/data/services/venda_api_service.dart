import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/vendas/data/model/venda_detail.dart';
import 'package:store_app/features/vendas/data/model/venda_entity.dart';

class VendaApiService {
  HttpClient client;

  VendaApiService(this.client);

  Future<List<VendaEntity>> getAllVendas(String token) async {
    final result = await client.get('api/Venda/ObterVendas',
        headers: {'Authorization': 'Bearer $token'});
    final data = client.decode(result);
    final list = data as List<dynamic>;
    return list
        .map((json) => VendaEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<VendaDetailEntity> getVenda(int id, String token) async {
    final result = await client.get('api/Venda/ObterVendaPorId/$id',
        headers: {'Authorization': 'Bearer $token'});

    final data = client.decode(result) as Map<String, dynamic>;

    return VendaDetailEntity.fromMap(data);
  }
}
