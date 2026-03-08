import 'package:flutter/material.dart';

/// Exibe um diálogo de confirmação genérico e retorna `true` se o usuário
/// confirmar, ou `false`/`null` se cancelar.
///
/// Exemplo de uso:
/// ```dart
/// final confirmed = await showConfirmDialog(
///   context,
///   title: 'Excluir produto',
///   content: 'Deseja realmente excluir "Produto X"?',
///   confirmLabel: 'Excluir',
/// );
/// if (confirmed && mounted) { /* executa ação */ }
/// ```
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
  String confirmLabel = 'Confirmar',
  String cancelLabel = 'Cancelar',
  Color confirmColor = Colors.red,
  IconData? icon,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: confirmColor, size: 20),
            const SizedBox(width: 8),
          ],
          Text(title),
        ],
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          style: TextButton.styleFrom(foregroundColor: confirmColor),
          child: Text(
            confirmLabel,
            style: TextStyle(fontWeight: FontWeight.bold, color: confirmColor),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}
