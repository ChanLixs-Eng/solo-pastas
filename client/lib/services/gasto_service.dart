import '../models/gasto.dart';
import 'http_service.dart';

class GastoService {
  final HttpService _http;

  GastoService(this._http);

  Future<Gasto> registrarGasto(Map<String, dynamic> body) async {
    final data = await _http.post('/gastos', body);
    return Gasto.fromJson(data);
  }
}
