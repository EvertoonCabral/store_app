// lib/main.dart
import 'package:flutter/material.dart';
import 'core/config/app_routes.dart';
import 'core/config/app_theme.dart';

void main() {
  runApp(const PerfumeStoreApp());
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
