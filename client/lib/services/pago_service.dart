import 'http_service.dart';

class PagoService {
  final HttpService _http;

  PagoService(this._http);

  Future<void> registrarPago(Map<String, dynamic> body) async {
    await _http.post('/pagos', body);
  }

  Future<List<Map<String, dynamic>>> getPagosHoy(String fecha) async {
    final data = await _http.get('/pagos?fecha=$fecha');
    return (data as List).cast<Map<String, dynamic>>();
  }
}
