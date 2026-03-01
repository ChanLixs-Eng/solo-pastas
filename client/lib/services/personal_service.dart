import '../models/personal.dart';
import 'http_service.dart';

class PersonalService {
  final HttpService _http;

  PersonalService(this._http);

  Future<List<Personal>> getPersonal() async {
    final data = await _http.get('/personal');
    return (data as List).map((j) => Personal.fromJson(j)).toList();
  }

  Future<Personal> createPersonal(Map<String, dynamic> body) async {
    final data = await _http.post('/personal', body);
    return Personal.fromJson(data);
  }

  Future<void> deletePersonal(int id) async {
    await _http.delete('/personal/$id');
  }
}
