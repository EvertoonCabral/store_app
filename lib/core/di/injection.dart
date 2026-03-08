import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:store_app/core/network/http_client.dart';

import 'package:store_app/features/clientes/data/services/cliente_api_services.dart';
import 'package:store_app/features/clientes/data/repositories/cliente_repository_impl.dart';
import 'package:store_app/features/clientes/data/repositories/cliente_repository.dart';

import 'package:store_app/features/produtos/data/services/produto_api_services.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository_impl.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository.dart';

import 'package:store_app/features/estoques/data/service/estoque_service.dart';
import 'package:store_app/features/estoques/data/repositories/estoque_repository_impl.dart';
import 'package:store_app/features/estoques/data/repositories/estoque_repository.dart';

import 'package:store_app/features/vendas/data/services/venda_api_service.dart';
import 'package:store_app/features/vendas/data/repository/venda_repository_impl.dart';
import 'package:store_app/features/vendas/data/repository/venda_repository.dart';

import 'package:store_app/features/login/data/service/auth_api_service.dart';
import 'package:store_app/features/login/data/repositories/auth_repository.dart';
import 'package:store_app/features/login/data/repositories/auth_repository_impl.dart';

final GetIt getIt = GetIt.instance;

/// Configure and register app-wide dependencies.
void configureDependencies({String? baseUrl}) {
  if (getIt.isRegistered<HttpClient>()) return;

  final httpClient = HttpClient(
    baseUrl: baseUrl ?? 'https://burghal-klara-nonextraneously.ngrok-free.dev/',
    client: http.Client(),
  );

  // Core
  getIt.registerSingleton<HttpClient>(httpClient);

  // Login / Auth
  getIt.registerLazySingleton<AuthApiService>(
      () => AuthApiService(getIt<HttpClient>()));
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthApiService>()));

  // Clientes
  getIt.registerLazySingleton<ClienteApiService>(
      () => ClienteApiService(getIt<HttpClient>()));
  getIt.registerLazySingleton<ClientesRepository>(
      () => ClientesRepositoryImpl(getIt<ClienteApiService>()));

  // Produtos
  getIt.registerLazySingleton<ProdutoApiServices>(
      () => ProdutoApiServices(getIt<HttpClient>()));
  getIt.registerLazySingleton<ProdutoRepository>(
      () => ProdutoRepositoryImpl(getIt<ProdutoApiServices>()));

  // Estoques
  getIt.registerLazySingleton<EstoqueApiService>(
      () => EstoqueApiService(getIt<HttpClient>()));
  getIt.registerLazySingleton<EstoqueRepository>(
      () => EstoqueRepositoryImpl(getIt<EstoqueApiService>()));

  // Vendas
  getIt.registerLazySingleton<VendaApiService>(
      () => VendaApiService(getIt<HttpClient>()));
  getIt.registerLazySingleton<VendaRepository>(
      () => VendaRepositoryImpl(getIt<VendaApiService>()));
}
