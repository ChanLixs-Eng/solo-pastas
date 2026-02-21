import 'package:decimal/decimal.dart';

class Cierre {
  final int? idCierre;
  final Decimal ingresosVentas;
  final Decimal totalGastos;
  final Decimal totalPagos;
  final Decimal utilidadNeta;
  final String fecha;

  Cierre({
    this.idCierre,
    required this.ingresosVentas,
    required this.totalGastos,
    required this.totalPagos,
    required this.utilidadNeta,
    required this.fecha,
  });

  factory Cierre.fromJson(Map<String, dynamic> json) {
    return Cierre(
      idCierre: json['id_cierre'] as int?,
      ingresosVentas: Decimal.parse(json['ingresos_ventas'].toString()),
      totalGastos: Decimal.parse(json['total_gastos'].toString()),
      totalPagos: Decimal.parse(json['total_pagos'].toString()),
      utilidadNeta: Decimal.parse(json['utilidad_neta'].toString()),
      fecha: json['fecha'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'ingresos_ventas': ingresosVentas.toString(),
        'fecha': fecha,
      };
}
