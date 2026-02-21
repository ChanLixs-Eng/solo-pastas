import 'http_service.dart';

class PagoService {
  final HttpService _http;

  PagoService(this._http);

  Future<void> registrarPago(Map<String, dynamic> body) async {
    await _http.post('/pagos', body);
  }
}
