import '../models/cierre.dart';
import 'http_service.dart';

class CierreService {
  final HttpService _http;

  CierreService(this._http);

  Future<Cierre> crearCierre(Map<String, dynamic> body) async {
    final data = await _http.post('/cierres', body);
    return Cierre.fromJson(data);
  }

  Future<List<Map<String, dynamic>>> getCierresHoy(String fecha) async {
    final data = await _http.get('/cierres?fecha=$fecha');
    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getResumenDia(String fecha) async {
    final data = await _http.get('/cierres/resumen-dia?fecha=$fecha');
    return data as Map<String, dynamic>;
  }
}
