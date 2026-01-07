import 'package:flutter/material.dart';

class EstoqueListPage extends StatefulWidget {
  const EstoqueListPage({super.key});

  @override
  State<EstoqueListPage> createState() => _EstoqueListPageState();
}

class _EstoqueListPageState extends State<EstoqueListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estoques'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            icon: Icon(Icons.arrow_back_ios_outlined),
          )
        ],
      ),
      body: Text('Teste'),
    );
  }
}
