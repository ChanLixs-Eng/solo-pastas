import '../models/producto.dart';
import 'http_service.dart';

class ProductoService {
  final HttpService _http;

  ProductoService(this._http);

  Future<List<Producto>> getProductos() async {
    final data = await _http.get('/productos');
    return (data as List).map((j) => Producto.fromJson(j)).toList();
  }

  Future<Producto> updateProducto(int id, Map<String, dynamic> body) async {
    final data = await _http.put('/productos/$id', body);
    return Producto.fromJson(data);
  }
}
