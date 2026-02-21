import 'package:decimal/decimal.dart';

class DashboardSummary {
  final Decimal utilidadHoy;
  final Decimal gastosPendientes;

  DashboardSummary({
    required this.utilidadHoy,
    required this.gastosPendientes,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      utilidadHoy: Decimal.parse(json['utilidad_hoy'].toString()),
      gastosPendientes: Decimal.parse(json['gastos_pendientes'].toString()),
    );
  }
}
