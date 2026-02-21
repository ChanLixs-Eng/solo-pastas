import '../models/personal.dart';
import 'http_service.dart';

class PersonalService {
  final HttpService _http;

  PersonalService(this._http);

  Future<List<Personal>> getPersonal() async {
    final data = await _http.get('/personal');
    return (data as List).map((j) => Personal.fromJson(j)).toList();
  }
}
