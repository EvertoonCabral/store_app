import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:store_app/core/di/injection.dart';
import 'package:store_app/core/config/app_routes.dart';
import 'package:store_app/core/config/app_theme.dart';

import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';
import 'package:store_app/features/clientes/presentation/viewmodel/cliente_list_viewmodel.dart';
import 'package:store_app/features/produtos/presentation/viewmodel/produto_list_viewmodel.dart';
import 'package:store_app/features/produtos/presentation/viewmodel/produto_detail_viewmodel.dart';
import 'package:store_app/features/estoques/presentation/viewmodel/estoque_viewmodel.dart';
import 'package:store_app/features/estoques/presentation/viewmodel/estoque_detail_viewmodel.dart';
import 'package:store_app/features/vendas/presentation/viewmodel/vendas_list_viewmodel.dart';
import 'package:store_app/features/vendas/presentation/viewmodel/cadastrar_venda_viewmodel.dart';

import 'package:store_app/features/clientes/data/repositories/cliente_repository.dart';
import 'package:store_app/features/produtos/data/repositories/produto_repository.dart';
import 'package:store_app/features/estoques/data/repositories/estoque_repository.dart';
import 'package:store_app/features/vendas/data/repository/venda_repository.dart';
import 'package:store_app/features/login/data/repositories/auth_repository_impl.dart';

void main() {
  configureDependencies();

  runApp(
    MultiProvider(
      providers: [
        // 1) AuthViewModel: criado UMA vez só
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(getIt<AuthRepositoryImpl>()),
        ),

        // 2) ClienteListViewModel: disponível globalmente
        ChangeNotifierProxyProvider<AuthViewModel, ClienteListViewModel>(
          create: (context) => ClienteListViewModel(
            getIt<ClientesRepository>(),
            context.read<AuthViewModel>(),
          ),
          update: (context, authVm, previous) =>
              previous ??
              ClienteListViewModel(getIt<ClientesRepository>(), authVm),
        ),

        // 3) ProdutoListViewmodel
        ChangeNotifierProxyProvider<AuthViewModel, ProdutoListViewmodel>(
          create: (context) => ProdutoListViewmodel(
            getIt<ProdutoRepository>(),
            context.read<AuthViewModel>(),
          ),
          update: (context, authVm, previous) =>
              previous ??
              ProdutoListViewmodel(getIt<ProdutoRepository>(), authVm),
        ),

        // 4) EstoqueViewmodel
        ChangeNotifierProxyProvider<AuthViewModel, EstoqueViewmodel>(
          create: (context) => EstoqueViewmodel(
            getIt<EstoqueRepository>(),
            context.read<AuthViewModel>(),
          ),
          update: (context, authVm, previous) =>
              previous ?? EstoqueViewmodel(getIt<EstoqueRepository>(), authVm),
        ),

        // 5) EstoqueDetailViewmodel
        ChangeNotifierProxyProvider<AuthViewModel, EstoqueDetailViewmodel>(
          create: (context) => EstoqueDetailViewmodel(
            getIt<EstoqueRepository>(),
            getIt<ProdutoRepository>(),
            context.read<AuthViewModel>(),
          ),
          update: (context, authVm, previous) =>
              previous ??
              EstoqueDetailViewmodel(
                getIt<EstoqueRepository>(),
                getIt<ProdutoRepository>(),
                authVm,
              ),
        ),

        // 6) ProdutoDetailViewmodel
        ChangeNotifierProxyProvider<AuthViewModel, ProdutoDetailViewmodel>(
          create: (context) => ProdutoDetailViewmodel(
            getIt<ProdutoRepository>(),
            context.read<AuthViewModel>(),
          ),
          update: (context, authVm, previous) =>
              previous ??
              ProdutoDetailViewmodel(getIt<ProdutoRepository>(), authVm),
        ),

        // 7) VendasListViewmodel
        ChangeNotifierProxyProvider<AuthViewModel, VendasListViewmodel>(
          create: (context) => VendasListViewmodel(
            getIt<VendaRepository>(),
            context.read<AuthViewModel>(),
          ),
          update: (context, authVm, previous) =>
              previous ?? VendasListViewmodel(getIt<VendaRepository>(), authVm),
        ),
        // 8) VendaCadastroViewmodel
        ChangeNotifierProxyProvider<AuthViewModel, VendaCadastroViewmodel>(
          create: (context) => VendaCadastroViewmodel(
            getIt<VendaRepository>(),
            context.read<AuthViewModel>(),
          ),
          update: (context, authVm, previous) =>
              previous ??
              VendaCadastroViewmodel(getIt<VendaRepository>(), authVm),
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
