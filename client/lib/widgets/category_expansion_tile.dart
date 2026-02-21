import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/categoria.dart';
import 'product_row.dart';

class CategoryExpansionTile extends StatelessWidget {
  final Categoria categoria;
  final Function(int productId, bool newEstado) onToggleEstado;
  final Function(int productId, String newPrecio) onUpdatePrecio;

  const CategoryExpansionTile({
    super.key,
    required this.categoria,
    required this.onToggleEstado,
    required this.onUpdatePrecio,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: true,
        collapsedBackgroundColor: AppColors.red,
        backgroundColor: Colors.white,
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        title: Text(
          categoria.nombre,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: categoria.productos.map((p) {
          return ProductRow(
            producto: p,
            onToggleEstado: (newEstado) =>
                onToggleEstado(p.idProducto, newEstado),
            onUpdatePrecio: (newPrecio) =>
                onUpdatePrecio(p.idProducto, newPrecio),
          );
        }).toList(),
      ),
    );
  }
}
