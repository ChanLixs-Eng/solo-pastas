import 'package:decimal/decimal.dart';

class Gasto {
  final int? idGasto;
  final String descripcion;
  final Decimal monto;
  final String tipoGasto;
  final String? fecha;
  final String? hora;

  Gasto({
    this.idGasto,
    required this.descripcion,
    required this.monto,
    required this.tipoGasto,
    this.fecha,
    this.hora,
  });

  factory Gasto.fromJson(Map<String, dynamic> json) {
    return Gasto(
      idGasto: json['id_gasto'] as int?,
      descripcion: json['descripcion'] as String,
      monto: Decimal.parse(json['monto'].toString()),
      tipoGasto: json['tipo_gasto'] as String,
      fecha: json['fecha'] as String?,
      hora: json['hora'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'descripcion': descripcion,
        'monto': monto.toString(),
        'tipo_gasto': tipoGasto,
      };
}
