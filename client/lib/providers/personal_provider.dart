import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import '../models/personal.dart';
import '../models/pago.dart';
import '../services/personal_service.dart';
import '../services/pago_service.dart';

class PersonalProvider extends ChangeNotifier {
  final PersonalService _personalService;
  final PagoService _pagoService;

  List<Personal> _empleados = [];
  bool _loading = false;
  String? _error;

  PersonalProvider(this._personalService, this._pagoService);

  List<Personal> get empleados => _empleados;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadPersonal() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _empleados = await _personalService.getPersonal();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> createEmpleado({
    required String nombre,
    required String cargo,
    required String sueldoBase,
  }) async {
    _error = null;
    try {
      await _personalService.createPersonal({
        'nombre': nombre,
        'cargo': cargo,
        'sueldo_base': sueldoBase,
      });
      await loadPersonal();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEmpleado(int id) async {
    _error = null;
    try {
      await _personalService.deletePersonal(id);
      await loadPersonal();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> registrarPago({
    required int idPersonal,
    required Decimal monto,
    required String concepto,
  }) async {
    _error = null;
    try {
      final pago = Pago(
        idPersonal: idPersonal,
        montoPagado: monto,
        concepto: concepto,
      );
      await _pagoService.registrarPago(pago.toJson());
      await loadPersonal();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
