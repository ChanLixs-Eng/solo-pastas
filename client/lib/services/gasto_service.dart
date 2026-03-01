import '../models/gasto.dart';
import 'http_service.dart';

class GastoService {
  final HttpService _http;

  GastoService(this._http);

  Future<Gasto> registrarGasto(Map<String, dynamic> body) async {
    final data = await _http.post('/gastos', body);
    return Gasto.fromJson(data);
  }

  Future<List<Map<String, dynamic>>> getGastosHoy(String fecha) async {
    final data = await _http.get('/gastos?fecha=$fecha');
    return (data as List).cast<Map<String, dynamic>>();
  }
}
