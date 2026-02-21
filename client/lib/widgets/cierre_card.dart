import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/cierre.dart';

class CierreCard extends StatelessWidget {
  final Cierre cierre;

  const CierreCard({super.key, required this.cierre});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cierre.fecha,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Bs. ${cierre.utilidadNeta.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: cierre.utilidadNeta >= Decimal.zero
                        ? AppColors.green
                        : AppColors.red,
                  ),
                ),
              ],
            ),
            const Divider(),
            _detailRow('Ventas', cierre.ingresosVentas.toStringAsFixed(2)),
            _detailRow('Gastos', '-${cierre.totalGastos.toStringAsFixed(2)}'),
            _detailRow('Pagos', '-${cierre.totalPagos.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.greyText)),
          Text('Bs. $value', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
