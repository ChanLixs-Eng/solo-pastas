import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/reportes_provider.dart';
import '../../widgets/cierre_card.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportes = context.watch<ReportesProvider>();
    final fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'SOLO PASTAS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkRed,
                ),
              ),
            ),
            const Center(
              child: Text(
                'Cierre de Caja',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: AppColors.darkText,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Total Ingresado en el Día\n(Efectivo + Transferencias)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: reportes.setIngresos,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                prefixText: 'Bs. ',
                hintText: '0.00',
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyText.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cálculo Automático',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _calcRow(
                    '(-) Gastos de Insumos registrados:',
                    reportes.totalGastos ?? Decimal.zero,
                  ),
                  const SizedBox(height: 8),
                  _calcRow(
                    '(-) Pagos a personal realizados:',
                    reportes.totalPagos ?? Decimal.zero,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Resultado Final:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkRed,
                    ),
                  ),
                  const Text(
                    'Ganancia Neta del Día:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkRed,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bs. ${(reportes.utilidadNeta ?? Decimal.zero).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: (reportes.utilidadNeta ?? Decimal.zero) >=
                              Decimal.zero
                          ? AppColors.green
                          : AppColors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.lock),
                label: const Text('[ Cerrar Caja y Guardar ]'),
                onPressed: reportes.loading
                    ? null
                    : () async {
                        final ok = await reportes.cerrarCaja(fecha);
                        if (ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cierre guardado'),
                              backgroundColor: AppColors.green,
                            ),
                          );
                        } else if (reportes.error != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(reportes.error!),
                              backgroundColor: AppColors.red,
                            ),
                          );
                        }
                      },
              ),
            ),
            const SizedBox(height: 32),
            if (reportes.historial.isNotEmpty) ...[
              const Text(
                'Historial de Cierres',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              ...reportes.historial.map((c) => CierreCard(cierre: c)),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _calcRow(String label, Decimal value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Text(
          'Bs. ${value.toStringAsFixed(2)}',
          style: const TextStyle(
            color: AppColors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
