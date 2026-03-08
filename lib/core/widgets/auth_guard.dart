import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/app_routes.dart';
import 'package:store_app/features/login/presentation/viewmodel/auth_viewmodel.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.select<AuthViewModel, bool>(
      (vm) => vm.isAuthenticated,
    );

    if (!isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return child;
  }
}
