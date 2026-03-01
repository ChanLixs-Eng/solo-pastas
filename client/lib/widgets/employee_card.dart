import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/personal.dart';

class EmployeeCard extends StatelessWidget {
  final Personal empleado;
  final VoidCallback onPagar;
  final VoidCallback? onDelete;

  const EmployeeCard({
    super.key,
    required this.empleado,
    required this.onPagar,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.darkRed,
              child: Text(
                empleado.iniciales,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    empleado.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    empleado.cargo,
                    style: TextStyle(
                      color: AppColors.greyText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sueldo pendiente: Bs. ${empleado.sueldoPendiente.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (empleado.ultimoPago != null)
                    Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.green, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Último pago: ${empleado.ultimoPago}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.greyText,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: onPagar,
                  child: const Text('Pagar'),
                ),
                if (onDelete != null) ...[
                  const SizedBox(height: 4),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: AppColors.red,
                    onPressed: onDelete,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
