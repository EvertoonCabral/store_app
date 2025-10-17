//lib/core/config/app_routes.dart
import 'package:flutter/material.dart';
import '../../pages/home/home_page.dart';
// import '../../pages/produtos/produtos_list_page.dart';
// import '../../pages/vendas/vendas_list_page.dart';
// import '../../pages/estoque/estoque_list_page.dart';
// import '../../pages/clientes/clientes_list_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (_) => const HomePage(),
    // '/produtos': (_) => const ProdutosListPage(),
    // '/vendas': (_) => const VendasListPage(),
    // '/estoque': (_) => const EstoqueListPage(),
    // '/clientes': (_) => const ClientesListPage(),
  };
}
