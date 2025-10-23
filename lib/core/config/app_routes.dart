//lib/core/config/app_routes.dart
import 'package:flutter/material.dart';
import 'package:store_app/features/clientes/presentation/views/clientes_list_page.dart';
import 'package:store_app/features/login/presentation/login_page.dart';
import '../../features/home/presentation/home_page.dart';
// import '../../pages/produtos/produtos_list_page.dart';
// import '../../pages/vendas/vendas_list_page.dart';
// import '../../pages/estoque/estoque_list_page.dart';
// import '../../pages/clientes/clientes_list_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/home': (_) => const HomePage(),
    '/login': (_) => const LoginPage(),
    // '/produtos': (_) => const ProdutosListPage(),
    // '/vendas': (_) => const VendasListPage(),
    // '/estoque': (_) => const EstoqueListPage(),
    '/clientes': (_) => const ClientesListPage(),
  };
}
