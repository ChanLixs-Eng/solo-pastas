import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/producto.dart';

class ProductRow extends StatefulWidget {
  final Producto producto;
  final Function(bool) onToggleEstado;
  final Function(String) onUpdatePrecio;

  const ProductRow({
    super.key,
    required this.producto,
    required this.onToggleEstado,
    required this.onUpdatePrecio,
  });

  @override
  State<ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<ProductRow> {
  late TextEditingController _precioController;

  @override
  void initState() {
    super.initState();
    _precioController = TextEditingController(
      text: widget.producto.precioVenta.toStringAsFixed(2),
    );
  }

  @override
  void didUpdateWidget(ProductRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.producto.precioVenta != widget.producto.precioVenta) {
      _precioController.text =
          widget.producto.precioVenta.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              widget.producto.nombre,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: TextField(
              controller: _precioController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                prefixText: 'Bs. ',
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (value) {
                widget.onUpdatePrecio(value);
              },
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Switch(
                value: widget.producto.estado,
                activeTrackColor: AppColors.green,
                onChanged: (value) => widget.onToggleEstado(value),
              ),
              Text(
                widget.producto.estado ? 'Disponible' : 'Agotado',
                style: TextStyle(
                  fontSize: 11,
                  color: widget.producto.estado
                      ? AppColors.green
                      : AppColors.greyText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
