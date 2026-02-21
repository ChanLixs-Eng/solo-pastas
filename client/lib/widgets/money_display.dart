import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class MoneyDisplay extends StatelessWidget {
  final Decimal amount;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;

  const MoneyDisplay({
    super.key,
    required this.amount,
    this.fontSize = 24,
    this.color,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Bs. ${amount.toStringAsFixed(2)}',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
