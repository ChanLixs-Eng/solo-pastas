import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/gasto_provider.dart';
import '../../widgets/expense_type_selector.dart';
import '../../widgets/custom_numpad.dart';

class GastosScreen extends StatefulWidget {
  const GastosScreen({super.key});

  @override
  State<GastosScreen> createState() => _GastosScreenState();
}

class _GastosScreenState extends State<GastosScreen> {
  final _descripcionController = TextEditingController();

  @override
  void dispose() {
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gasto = context.watch<GastoProvider>();

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
                'Registro de Gastos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tipo de Gasto',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            ExpenseTypeSelector(
              selected: gasto.tipoSeleccionado,
              onChanged: gasto.setTipo,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descripcionController,
              onChanged: gasto.setDescripcion,
              decoration: const InputDecoration(
                hintText: 'Concepto (Ej. 5kg de Harina)',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Monto',
                  style: TextStyle(fontSize: 15),
                ),
                const Spacer(),
                Text(
                  'Bs. ${gasto.montoFormateado}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CustomNumpad(onKey: gasto.numpadInput),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: gasto.loading
                    ? null
                    : () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final dashboard = context.read<DashboardProvider>();
                        final ok = await gasto.registrarGasto();
                        if (ok && mounted) {
                          final fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());
                          dashboard.loadTodayActivity(fecha);
                          _descripcionController.clear();
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Gasto registrado'),
                              backgroundColor: AppColors.green,
                            ),
                          );
                        } else if (gasto.error != null && mounted) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(gasto.error!),
                              backgroundColor: AppColors.red,
                            ),
                          );
                        }
                      },
                child: gasto.loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Registrar Gasto'),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Historial Reciente (Últimas 24h)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (gasto.recientes.isEmpty)
              Text(
                'No hay gastos registrados aún',
                style: TextStyle(color: AppColors.greyText),
              )
            else
              ...gasto.recientes.map((g) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(_iconForTipo(g.tipoGasto),
                            size: 20, color: AppColors.darkRed),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${g.descripcion} - Bs. ${g.monto.toStringAsFixed(2)}${g.hora != null ? ' - ${g.hora}' : ''}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  IconData _iconForTipo(String tipo) {
    switch (tipo) {
      case 'Insumo':
        return Icons.shopping_basket;
      case 'Servicio':
        return Icons.build;
      default:
        return Icons.receipt;
    }
  }
}
