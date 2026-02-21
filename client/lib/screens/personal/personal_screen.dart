import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/personal_provider.dart';
import '../../widgets/employee_card.dart';
import '../../widgets/pago_dialog.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<PersonalProvider>().loadPersonal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final personal = context.watch<PersonalProvider>();

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 12),
          const Text(
            'SOLO PASTAS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.darkRed,
            ),
          ),
          const Text(
            'Personal y Pagos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _buildBody(personal),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(PersonalProvider personal) {
    if (personal.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (personal.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(personal.error!, style: TextStyle(color: AppColors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: personal.loadPersonal,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (personal.empleados.isEmpty) {
      return const Center(child: Text('No hay empleados registrados'));
    }

    return RefreshIndicator(
      onRefresh: personal.loadPersonal,
      child: ListView.builder(
        itemCount: personal.empleados.length,
        padding: const EdgeInsets.only(bottom: 24),
        itemBuilder: (context, index) {
          final emp = personal.empleados[index];
          return EmployeeCard(
            empleado: emp,
            onPagar: () async {
              final messenger = ScaffoldMessenger.of(context);
              final result = await showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => PagoDialog(empleado: emp),
              );
              if (result != null && mounted) {
                final ok = await personal.registrarPago(
                  idPersonal: emp.idPersonal,
                  monto: result['monto'] as Decimal,
                  concepto: result['concepto'] as String,
                );
                if (ok && mounted) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Pago registrado'),
                      backgroundColor: AppColors.green,
                    ),
                  );
                } else if (personal.error != null && mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(personal.error!),
                      backgroundColor: AppColors.red,
                    ),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}
