import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:store_app/core/di/injection.dart';
import 'package:store_app/core/config/app_routes.dart';
import 'package:store_app/core/config/app_theme.dart';
import 'package:store_app/core/network/http_client.dart';
import 'package:store_app/core/token_store.dart';

import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';
import 'package:store_app/features/clientes/presentation/viewmodel/cliente_list_viewmodel.dart';
import 'package:store_app/features/produtos/presentation/viewmodel/produto_list_viewmodel.dart';
import 'package:store_app/features/estoques/presentation/viewmodel/estoque_viewmodel.dart';
import 'package:store_app/features/vendas/presentation/viewmodel/vendas_list_viewmodel.dart';

import 'package:store_app/features/clientes/data/repositories/cliente_repository.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository.dart';
import 'package:store_app/features/estoques/data/repositories/estoque_repository.dart';
import 'package:store_app/features/vendas/data/repository/venda_repository.dart';
import 'package:store_app/features/login/data/repositories/auth_repository.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const baseUrl = String.fromEnvironment('BASE_URL');
  configureDependencies(baseUrl: baseUrl.isNotEmpty ? baseUrl : null);

  // Quando a API retornar 401, força logout e redireciona para login.
  getIt<HttpClient>().onUnauthorized = () {
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.read<AuthViewModel>().forceLogout();
    }
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  };

  runApp(
    MultiProvider(
      providers: [
        // AuthViewModel: instância única para todo o app
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(
            getIt<AuthRepository>(),
            getIt<TokenStore>(),
          ),
        ),

        // Os demais ViewModels não dependem mais de AuthViewModel —
        // o token é injetado automaticamente pelo HttpClient via TokenStore.
        ChangeNotifierProvider<ClienteListViewModel>(
          create: (_) => ClienteListViewModel(getIt<ClientesRepository>()),
        ),
        ChangeNotifierProvider<ProdutoListViewmodel>(
          create: (_) => ProdutoListViewmodel(getIt<ProdutoRepository>()),
        ),
        ChangeNotifierProvider<EstoqueViewmodel>(
          create: (_) => EstoqueViewmodel(
            getIt<EstoqueRepository>(),
            getIt<TokenStore>(),
          ),
        ),
        ChangeNotifierProvider<VendasListViewmodel>(
          create: (_) => VendasListViewmodel(getIt<VendaRepository>()),
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
      navigatorKey: navigatorKey,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
