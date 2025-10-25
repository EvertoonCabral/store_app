// lib/main.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/features/clientes/data/repositories/cliente_repository_impl.dart';
import 'package:store_app/features/clientes/data/services/cliente_api_services.dart';
import 'package:store_app/features/clientes/presentation/viewmodels/cliente_list_viewmodel.dart';
import 'core/config/app_routes.dart';
import 'core/config/app_theme.dart';

void main() {
  final httpClient = HttpClient(
      baseUrl: 'https://burghal-klara-nonextraneously.ngrok-free.dev/',
      client: http.Client()); // ajuste para sua API
  final api = ClienteApiService(httpClient);
  final repo = ClientesRepositoryImpl(api);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ClienteListViewModel(repo),
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
      theme: AppTheme.light, // opcional
      initialRoute: '/login',
      routes: AppRoutes.routes,
    );
  }
}
