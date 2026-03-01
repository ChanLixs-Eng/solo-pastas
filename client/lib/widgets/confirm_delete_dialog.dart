import 'package:flutter/material.dart';
import '../config/theme.dart';

Future<bool?> showConfirmDeleteDialog(BuildContext context, String itemName) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirmar eliminación'),
      content: Text('¿Eliminar "$itemName"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: AppColors.red),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
}
