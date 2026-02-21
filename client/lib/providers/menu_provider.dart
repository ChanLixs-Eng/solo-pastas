import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import '../models/producto.dart';
import '../models/categoria.dart';
import '../services/producto_service.dart';

class MenuProvider extends ChangeNotifier {
  final ProductoService _service;

  List<Producto> _productos = [];
  String _searchQuery = '';
  bool _loading = false;
  String? _error;

  MenuProvider(this._service);

  List<Categoria> get categorias {
    final filtered = _searchQuery.isEmpty
        ? _productos
        : _productos
            .where((p) =>
                p.nombre.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    final Map<String, List<Producto>> grouped = {};
    for (final p in filtered) {
      grouped.putIfAbsent(p.nombreCategoria, () => []).add(p);
    }
    return grouped.entries
        .map((e) => Categoria(nombre: e.key, productos: e.value))
        .toList();
  }

  bool get loading => _loading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  Future<void> loadProductos() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _productos = await _service.getProductos();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> toggleEstado(Producto producto) async {
    final newEstado = !producto.estado;
    try {
      await _service.updateProducto(producto.idProducto, {
        'estado': newEstado,
        'precio_venta': producto.precioVenta.toString(),
      });
      producto.estado = newEstado;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updatePrecio(Producto producto, Decimal nuevoPrecio) async {
    try {
      await _service.updateProducto(producto.idProducto, {
        'precio_venta': nuevoPrecio.toString(),
        'estado': producto.estado,
      });
      producto.precioVenta = nuevoPrecio;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
