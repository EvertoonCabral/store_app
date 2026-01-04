import 'package:flutter/material.dart';
import 'package:store_app/features/clientes/presentation/views/clientes_add_page.dart';
import 'package:store_app/features/clientes/presentation/views/clientes_list_page.dart';
import 'package:store_app/features/clientes/presentation/views/clientes_update_page.dart';
import 'package:store_app/features/login/presentation/view/login_page.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/presentation/views/produto_add_page.dart';
import 'package:store_app/features/produtos/presentation/views/produto_update_page.dart';
import 'package:store_app/features/produtos/presentation/views/produtos_list_page.dart';
import '../../features/home/presentation/home_page.dart';

class AppRoutes {
  // Constantes para as rotas
  static const String home = '/home';
  static const String login = '/login';
  static const String produtos = '/produtos';
  static const String cadastrarProduto = '/cadastrar-produto';
  static const String editarProduto = '/editar-produto';
  static const String clientes = '/clientes';
  static const String cadastrarCliente = '/cadastrar-cliente';
  static const String editarCliente = '/editar-cliente';

  static Map<String, WidgetBuilder> routes = {
    home: (_) => const HomePage(),
    login: (_) => const LoginPage(),
    produtos: (_) => const ProdutosListPage(),
    cadastrarProduto: (_) => const ProdutoAddPage(),
    clientes: (_) => const ClientesListPage(),
    cadastrarCliente: (_) => const ClientesAddPage(),
    editarCliente: (_) => const ClientesUpdatePage(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == editarProduto) {
      final produto = settings.arguments as ProdutoEntity;
      return MaterialPageRoute(
        builder: (_) => ProdutoUpdatePage(produto: produto),
      );
    }
    return null;
  }
}
