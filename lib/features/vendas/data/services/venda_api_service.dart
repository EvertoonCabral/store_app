import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/vendas/data/model/create_venda_request.dart';
import 'package:store_app/features/vendas/data/model/venda_detail.dart';
import 'package:store_app/features/vendas/data/model/venda_entity.dart';

class VendaApiService {
  final HttpClient client;

  VendaApiService(this.client);

  Future<List<VendaEntity>> getAllVendas() async {
    final result = await client.get('api/Venda/ObterVendas');
    final data = client.decode(result);
    final list = data as List<dynamic>;
    return list
        .map((json) => VendaEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<VendaDetailEntity> getVenda(int id) async {
    final result = await client.get('api/Venda/ObterVendaPorId/$id');
    final data = client.decode(result) as Map<String, dynamic>;
    return VendaDetailEntity.fromMap(data);
  }

  Future<void> cadastrarVenda(VendaRequestModel request) async {
    final result = await client.post(
      'api/Venda/CadastrarVenda',
      body: request.toJson(),
    );

    if (result.statusCode != 200 && result.statusCode != 201) {
      try {
        final decoded = client.decode(result);
        final message = decoded['message'] ?? 'Erro ao cadastrar venda';
        throw Exception(message);
      } catch (_) {
        throw Exception('Erro ao cadastrar venda');
      }
    }
  }

  Future<bool> deleteVenda(int id) async {
    await client.delete('api/Venda/DeletarVenda/$id');
    return true;
  }
}
