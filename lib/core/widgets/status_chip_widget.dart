import 'package:flutter/material.dart';

class StatusChipWidget extends StatelessWidget {
  final bool isAtivo;
  final String? labelAtivo; // Opcional: caso queira mudar o texto futuramente
  final String? labelInativo; // Opcional

  const StatusChipWidget({
    super.key,
    required this.isAtivo,
    this.labelAtivo,
    this.labelInativo,
  });

  @override
  Widget build(BuildContext context) {
    final color = isAtivo ? Colors.green : Colors.red;
    final text =
        isAtivo ? (labelAtivo ?? 'Ativo') : (labelInativo ?? 'Inativo');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
