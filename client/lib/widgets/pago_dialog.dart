import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../config/theme.dart';
import '../models/personal.dart';

class PagoDialog extends StatefulWidget {
  final Personal empleado;

  const PagoDialog({super.key, required this.empleado});

  @override
  State<PagoDialog> createState() => _PagoDialogState();
}

class _PagoDialogState extends State<PagoDialog> {
  final _montoController = TextEditingController();
  ConceptoPago _concepto = ConceptoPago.sueldo;

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pagar a ${widget.empleado.nombre}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkRed,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pendiente: Bs. ${widget.empleado.sueldoPendiente.toStringAsFixed(2)}',
            style: TextStyle(color: AppColors.greyText),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _montoController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Monto a pagar',
              prefixText: 'Bs. ',
            ),
          ),
          const SizedBox(height: 16),
          const Text('Concepto:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SegmentedButton<ConceptoPago>(
            segments: ConceptoPago.values.map((c) {
              return ButtonSegment(value: c, label: Text(c.label));
            }).toList(),
            selected: {_concepto},
            onSelectionChanged: (s) => setState(() => _concepto = s.first),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final monto = _montoController.text.trim();
                if (monto.isEmpty) return;
                try {
                  final amount = Decimal.parse(monto);
                  if (amount <= Decimal.zero) return;
                  Navigator.of(context).pop({
                    'monto': amount,
                    'concepto': _concepto.label,
                  });
                } catch (_) {
                  // invalid input
                }
              },
              child: const Text('Confirmar Pago'),
            ),
          ),
        ],
      ),
    );
  }
}
