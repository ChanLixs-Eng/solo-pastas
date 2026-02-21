import 'package:decimal/decimal.dart';

class Producto {
  final int idProducto;
  final String nombre;
  Decimal precioVenta;
  bool estado;
  final String nombreCategoria;

  Producto({
    required this.idProducto,
    required this.nombre,
    required this.precioVenta,
    required this.estado,
    required this.nombreCategoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['id_producto'] as int,
      nombre: json['nombre'] as String,
      precioVenta: Decimal.parse(json['precio_venta'].toString()),
      estado: json['estado'] as bool,
      nombreCategoria: json['nombre_categoria'] as String? ?? 'Sin categoría',
    );
  }

  Map<String, dynamic> toJson() => {
        'precio_venta': precioVenta.toString(),
        'estado': estado,
      };
}
