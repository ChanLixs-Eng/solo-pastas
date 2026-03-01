import 'package:flutter/material.dart';
import '../config/theme.dart';

class PersonalDialog extends StatefulWidget {
  const PersonalDialog({super.key});

  @override
  State<PersonalDialog> createState() => _PersonalDialogState();
}

class _PersonalDialogState extends State<PersonalDialog> {
  final _nombreController = TextEditingController();
  final _cargoController = TextEditingController();
  final _sueldoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nombreController.dispose();
    _cargoController.dispose();
    _sueldoController.dispose();
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Nuevo Empleado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cargoController,
              decoration: const InputDecoration(
                labelText: 'Cargo',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El cargo es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sueldoController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Sueldo base',
                prefixText: 'Bs. ',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El sueldo es requerido';
                }
                final parsed = double.tryParse(value);
                if (parsed == null || parsed <= 0) {
                  return 'Ingrese un sueldo válido mayor a 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, {
      'nombre': _nombreController.text.trim(),
      'cargo': _cargoController.text.trim(),
      'sueldo_base': _sueldoController.text.trim(),
    });
  }
}
