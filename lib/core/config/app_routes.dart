import 'package:flutter/material.dart';
import 'package:store_app/core/widgets/auth_guard.dart';
import 'package:store_app/features/clientes/presentation/views/clientes_add_page.dart';
import 'package:store_app/features/clientes/presentation/views/clientes_list_page.dart';
import 'package:store_app/features/clientes/presentation/views/clientes_update_page.dart';
import 'package:store_app/features/estoques/presentation/views/estoque_list_page.dart';
import 'package:store_app/features/login/presentation/views/login_page.dart';
import 'package:store_app/features/produtos/data/models/produto_entity.dart';
import 'package:store_app/features/produtos/presentation/views/produto_add_page.dart';
import 'package:store_app/features/produtos/presentation/views/produto_update_page.dart';
import 'package:store_app/features/produtos/presentation/views/produtos_list_page.dart';
import 'package:store_app/features/vendas/presentation/views/venda_create_page.dart';
import 'package:store_app/features/vendas/presentation/views/vendas_list_page.dart';
import '../../features/home/presentation/home_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String produtos = '/produtos';
  static const String cadastrarProduto = '/cadastrar-produto';
  static const String editarProduto = '/editar-produto';
  static const String clientes = '/clientes';
  static const String cadastrarCliente = '/cadastrar-cliente';
  static const String editarCliente = '/editar-cliente';
  static const String estoques = '/estoques';
  static const String vendas = '/vendas';
  static const String cadastrarVenda = '/cadastrar-venda';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    home: (_) => const AuthGuard(child: HomePage()),
    produtos: (_) => const AuthGuard(child: ProdutosListPage()),
    cadastrarProduto: (_) => const AuthGuard(child: ProdutoAddPage()),
    clientes: (_) => const AuthGuard(child: ClientesListPage()),
    cadastrarCliente: (_) => const AuthGuard(child: ClientesAddPage()),
    editarCliente: (_) => const AuthGuard(child: ClientesUpdatePage()),
    estoques: (_) => const AuthGuard(child: EstoqueListPage()),
    vendas: (_) => const AuthGuard(child: VendasListPage()),
    cadastrarVenda: (_) => const AuthGuard(child: VendaCadastroPage()),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == editarProduto) {
      final produto = settings.arguments as ProdutoEntity;
      return MaterialPageRoute(
        builder: (_) => AuthGuard(child: ProdutoUpdatePage(produto: produto)),
      );
    }
    return null;
  }
}
