import 'package:decimal/decimal.dart';

enum ActivityType { gasto, pago }

class ActivityItem {
  final ActivityType type;
  final String descripcion;
  final Decimal monto;
  final String? hora;
  final String? subtipo; // tipo_gasto or concepto

  ActivityItem({
    required this.type,
    required this.descripcion,
    required this.monto,
    this.hora,
    this.subtipo,
  });

  factory ActivityItem.fromGasto(Map<String, dynamic> json) {
    return ActivityItem(
      type: ActivityType.gasto,
      descripcion: json['descripcion'] as String,
      monto: Decimal.parse(json['monto'].toString()),
      hora: json['hora'] as String?,
      subtipo: json['tipo_gasto'] as String?,
    );
  }

  factory ActivityItem.fromPago(Map<String, dynamic> json) {
    return ActivityItem(
      type: ActivityType.pago,
      descripcion: json['nombre_empleado'] as String,
      monto: Decimal.parse(json['monto_pagado'].toString()),
      hora: json['hora'] as String?,
      subtipo: json['concepto'] as String?,
    );
  }
}
