import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/app_routes.dart';
import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 28, child: Icon(Icons.store)),
                  SizedBox(height: 12),
                  Text('Perfume Store',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Gestão de Vendas e Estoque'),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.home),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Produtos'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.produtos),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Vendas'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.vendas),
            ),
            ListTile(
              leading: const Icon(Icons.warehouse),
              title: const Text('Estoque'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.estoques),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Clientes'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.clientes),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: () {
                context.read<AuthViewModel>().logout();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
