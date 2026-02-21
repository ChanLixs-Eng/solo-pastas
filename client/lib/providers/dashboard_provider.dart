import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';

class DashboardProvider extends ChangeNotifier {
  Decimal _utilidadHoy = Decimal.zero;
  Decimal _gastosPendientes = Decimal.zero;
  bool _loading = false;
  String? _error;

  Decimal get utilidadHoy => _utilidadHoy;
  Decimal get gastosPendientes => _gastosPendientes;
  bool get loading => _loading;
  String? get error => _error;

  void updateSummary({
    required Decimal utilidad,
    required Decimal gastos,
  }) {
    _utilidadHoy = utilidad;
    _gastosPendientes = gastos;
    notifyListeners();
  }

  void setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void setError(String? e) {
    _error = e;
    notifyListeners();
  }
}
