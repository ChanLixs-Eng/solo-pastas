import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../config/theme.dart';

class ExpenseTypeSelector extends StatelessWidget {
  final TipoGasto selected;
  final ValueChanged<TipoGasto> onChanged;

  const ExpenseTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: TipoGasto.values.map((tipo) {
        final isSelected = tipo == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(tipo),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.red : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppColors.red : AppColors.greyText,
                ),
              ),
              child: Text(
                tipo.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.darkText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
