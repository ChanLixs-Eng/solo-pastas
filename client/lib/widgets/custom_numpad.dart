import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomNumpad extends StatelessWidget {
  final ValueChanged<String> onKey;

  const CustomNumpad({super.key, required this.onKey});

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['1', '2', '3', '÷'],
      ['4', '5', '6', '−'],
      ['7', '8', '9', '⎵'],
      [',', '0', '.', '⌫'],
    ];

    return Column(
      children: keys.map((row) {
        return Row(
          children: row.map((key) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: _NumpadKey(
                  label: key,
                  onTap: () => _handleTap(key),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  void _handleTap(String key) {
    switch (key) {
      case '⌫':
        onKey('backspace');
      case ',':
        onKey(',');
      case '÷':
      case '−':
      case '⎵':
        break; // decorative keys from mockup, no action
      default:
        onKey(key);
    }
  }
}

class _NumpadKey extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NumpadKey({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.greyText.withValues(alpha: 0.3)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
        ),
      ),
    );
  }
}
