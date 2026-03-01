import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import '../models/cierre.dart';
import '../services/cierre_service.dart';

class ReportesProvider extends ChangeNotifier {
  final CierreService _service;

  String _ingresosStr = '';
  Decimal? _totalGastos;
  Decimal? _totalPagos;
  Decimal? _utilidadNeta;
  final List<Cierre> _historial = [];
  bool _loading = false;
  String? _error;

  ReportesProvider(this._service);

  String get ingresosStr => _ingresosStr;
  Decimal? get totalGastos => _totalGastos;
  Decimal? get totalPagos => _totalPagos;
  Decimal? get utilidadNeta => _utilidadNeta;
  List<Cierre> get historial => _historial;
  bool get loading => _loading;
  String? get error => _error;

  Decimal get ingresos {
    try {
      return Decimal.parse(_ingresosStr);
    } catch (_) {
      return Decimal.zero;
    }
  }

  void setIngresos(String value) {
    _ingresosStr = value;
    _calcularUtilidad();
    notifyListeners();
  }

  Future<void> loadResumenDia(String fecha) async {
    try {
      final data = await _service.getResumenDia(fecha);
      _totalGastos = Decimal.parse(data['total_gastos'].toString());
      _totalPagos = Decimal.parse(data['total_pagos'].toString());
      _calcularUtilidad();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _calcularUtilidad() {
    final g = _totalGastos ?? Decimal.zero;
    final p = _totalPagos ?? Decimal.zero;
    _utilidadNeta = ingresos - g - p;
  }

  Future<bool> cerrarCaja(String fecha) async {
    if (ingresos <= Decimal.zero) {
      _error = 'Ingrese el total de ventas';
      notifyListeners();
      return false;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final cierre = await _service.crearCierre({
        'ingresos_ventas': ingresos.toString(),
        'fecha': fecha,
      });
      _historial.insert(0, cierre);
      _ingresosStr = '';
      _totalGastos = null;
      _totalPagos = null;
      _utilidadNeta = null;
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}
