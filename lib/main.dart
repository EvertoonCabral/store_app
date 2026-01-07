import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:store_app/core/config/app_routes.dart';
import 'package:store_app/core/config/app_theme.dart';
import 'package:store_app/core/network/http_client.dart';

import 'package:store_app/features/clientes/data/services/cliente_api_services.dart';
import 'package:store_app/features/clientes/data/repositories/cliente_repository_impl.dart';
import 'package:store_app/features/clientes/presentation/viewmodel/cliente_list_viewmodel.dart';
import 'package:store_app/features/estoques/data/repositories/estoque_repository_impl.dart';
import 'package:store_app/features/estoques/data/service/estoque_service.dart';
import 'package:store_app/features/estoques/presentation/viewmodel/estoque_viewmodel.dart';

import 'package:store_app/features/login/data/service/auth_api_service.dart';
import 'package:store_app/features/login/data/repositories/auth_repository_impl.dart';
import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';

import 'package:store_app/features/produtos/data/services/produto_api_services.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository_impl.dart';
import 'package:store_app/features/produtos/presentation/viewmodel/produto_list_viewmodel.dart';

void main() {
  final httpClient = HttpClient(
    baseUrl: 'https://burghal-klara-nonextraneously.ngrok-free.dev/',
    client: http.Client(),
  );

  // Clientes
  final clienteApi = ClienteApiService(httpClient);
  final clienteRepo = ClientesRepositoryImpl(clienteApi);

  // Auth
  final authApi = AuthApiService(httpClient);
  final authRepo = AuthRepositoryImpl(authApi);

  // Produtos
  final produtoApi = ProdutoApiServices(httpClient);
  final produtoRepo = ProdutoRepositoryImpl(produtoApi);

  //Estoque
  final estoqueApi = EstoqueApiService(httpClient);
  final estoqueRepo = EstoqueRepositoryImpl(estoqueApi);

  runApp(
    MultiProvider(
      providers: [
        // 1) AuthViewModel: criado UMA vez só
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(authRepo),
        ),

        ChangeNotifierProxyProvider<AuthViewModel, ClienteListViewModel>(
          create: (context) => ClienteListViewModel(
            clienteRepo,
            context.read<AuthViewModel>(),
          ),
          update: (context, authVm, previous) =>
              ClienteListViewModel(clienteRepo, authVm),
        ),

        // 3) ProdutoListViewmodel depende do MESMO AuthViewModel
        ChangeNotifierProxyProvider<AuthViewModel, ProdutoListViewmodel>(
          create: (context) => ProdutoListViewmodel(
            produtoRepo,
            context.read<AuthViewModel>(),
          ),
          update: (context, authVm, previous) =>
              ProdutoListViewmodel(produtoRepo, authVm),
        ),
        ChangeNotifierProxyProvider<AuthViewModel, EstoqueViewmodel>(
          create: (context) => EstoqueViewmodel(
            estoqueRepo,
            context.read<AuthViewModel>(),
          ),
          update: (context, authVm, previous) =>
              EstoqueViewmodel(estoqueRepo, authVm),
        ),
      ],
      child: const PerfumeStoreApp(),
    ),
  );
}

class PerfumeStoreApp extends StatelessWidget {
  const PerfumeStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfume Store',
      theme: AppTheme.light,
      initialRoute: '/login',
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
