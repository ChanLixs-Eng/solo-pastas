import 'package:decimal/decimal.dart';

class Pago {
  final int idPersonal;
  final Decimal montoPagado;
  final String concepto;

  Pago({
    required this.idPersonal,
    required this.montoPagado,
    required this.concepto,
  });

  Map<String, dynamic> toJson() => {
        'id_personal': idPersonal,
        'monto_pagado': montoPagado.toString(),
        'concepto': concepto,
      };
}
