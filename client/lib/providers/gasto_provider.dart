import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import '../config/constants.dart';
import '../models/gasto.dart';
import '../services/gasto_service.dart';

class GastoProvider extends ChangeNotifier {
  final GastoService _service;

  TipoGasto _tipoSeleccionado = TipoGasto.insumo;
  String _descripcion = '';
  String _montoStr = '0';
  bool _loading = false;
  String? _error;
  final List<Gasto> _recientes = [];

  GastoProvider(this._service);

  TipoGasto get tipoSeleccionado => _tipoSeleccionado;
  String get descripcion => _descripcion;
  String get montoStr => _montoStr;
  bool get loading => _loading;
  String? get error => _error;
  List<Gasto> get recientes => _recientes;

  Decimal get monto {
    try {
      return Decimal.parse(_montoStr);
    } catch (_) {
      return Decimal.zero;
    }
  }

  String get montoFormateado {
    final d = monto;
    return d.toStringAsFixed(2);
  }

  void setTipo(TipoGasto tipo) {
    _tipoSeleccionado = tipo;
    notifyListeners();
  }

  void setDescripcion(String desc) {
    _descripcion = desc;
  }

  void numpadInput(String key) {
    if (key == 'backspace') {
      if (_montoStr.length > 1) {
        _montoStr = _montoStr.substring(0, _montoStr.length - 1);
      } else {
        _montoStr = '0';
      }
    } else if (key == '.') {
      if (!_montoStr.contains('.')) {
        _montoStr += '.';
      }
    } else if (key == ',') {
      // comma acts as decimal separator
      if (!_montoStr.contains('.')) {
        _montoStr += '.';
      }
    } else {
      // digit
      if (_montoStr == '0' && key != '0') {
        _montoStr = key;
      } else if (_montoStr != '0') {
        // Limit to 2 decimal places
        if (_montoStr.contains('.')) {
          final parts = _montoStr.split('.');
          if (parts[1].length < 2) {
            _montoStr += key;
          }
        } else {
          _montoStr += key;
        }
      }
    }
    notifyListeners();
  }

  void clearMonto() {
    _montoStr = '0';
    notifyListeners();
  }

  Future<bool> registrarGasto() async {
    if (_descripcion.trim().isEmpty || monto <= Decimal.zero) {
      _error = 'Complete todos los campos';
      notifyListeners();
      return false;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final gasto = await _service.registrarGasto({
        'descripcion': _descripcion.trim(),
        'monto': monto.toString(),
        'tipo_gasto': _tipoSeleccionado.label,
      });
      _recientes.insert(0, gasto);
      _descripcion = '';
      _montoStr = '0';
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
