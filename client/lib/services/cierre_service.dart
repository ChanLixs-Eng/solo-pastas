import '../models/cierre.dart';
import 'http_service.dart';

class CierreService {
  final HttpService _http;

  CierreService(this._http);

  Future<Cierre> crearCierre(Map<String, dynamic> body) async {
    final data = await _http.post('/cierres', body);
    return Cierre.fromJson(data);
  }
}
