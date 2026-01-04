// lib/main.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/clientes/data/repositories/cliente_repository_impl.dart';
import 'package:store_app/features/clientes/data/services/cliente_api_services.dart';
import 'package:store_app/features/clientes/presentation/viewmodel/cliente_list_viewmodel.dart';
import 'package:store_app/features/login/data/repositories/auth_repository_impl.dart';
import 'package:store_app/features/login/data/service/auth_api_service.dart';
import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository_impl.dart';
import 'package:store_app/features/produtos/data/services/produto_api_services.dart';
import 'package:store_app/features/produtos/presentation/viewmodel/produto_list_viewmodel.dart';
import 'core/config/app_routes.dart';
import 'core/config/app_theme.dart';

void main() {
  final httpClient = HttpClient(
    baseUrl: 'https://burghal-klara-nonextraneously.ngrok-free.dev/',
    client: http.Client(),
  );

  final clienteApi = ClienteApiService(httpClient);
  final clienteRepo = ClientesRepositoryImpl(clienteApi);

  final produtoApi = ProdutoApiServices(httpClient);
  final produtoRepo = ProdutoRepositoryImpl(produtoApi);

  final authApi = AuthApiService(httpClient);
  final authRepo = AuthRepositoryImpl(authApi);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ClienteListViewModel(clienteRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => ProdutoListViewmodel(produtoRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(authRepo),
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
