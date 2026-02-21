import 'package:decimal/decimal.dart';

class Personal {
  final int idPersonal;
  final String nombre;
  final String cargo;
  final Decimal sueldoPendiente;
  final String? ultimoPago;

  Personal({
    required this.idPersonal,
    required this.nombre,
    required this.cargo,
    required this.sueldoPendiente,
    this.ultimoPago,
  });

  factory Personal.fromJson(Map<String, dynamic> json) {
    return Personal(
      idPersonal: json['id_personal'] as int,
      nombre: json['nombre'] as String,
      cargo: json['cargo'] as String,
      sueldoPendiente: Decimal.parse(json['sueldo_pendiente'].toString()),
      ultimoPago: json['ultimo_pago'] as String?,
    );
  }

  String get iniciales {
    final parts = nombre.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return nombre.substring(0, 2).toUpperCase();
  }
}
