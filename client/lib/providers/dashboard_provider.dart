import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import '../models/activity_item.dart';
import '../models/cierre.dart';
import '../services/cierre_service.dart';
import '../services/gasto_service.dart';
import '../services/pago_service.dart';

class DashboardProvider extends ChangeNotifier {
  final GastoService _gastoService;
  final PagoService _pagoService;
  final CierreService _cierreService;

  Decimal _utilidadHoy = Decimal.zero;
  Decimal _gastosPendientes = Decimal.zero;
  List<ActivityItem> _actividadHoy = [];
  List<Cierre> _cierresHoy = [];
  bool _loading = false;
  String? _error;

  DashboardProvider(this._gastoService, this._pagoService, this._cierreService);

  Decimal get utilidadHoy => _utilidadHoy;
  Decimal get gastosPendientes => _gastosPendientes;
  List<ActivityItem> get actividadHoy => _actividadHoy;
  List<Cierre> get cierresHoy => _cierresHoy;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadTodayActivity(String fecha) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final gastosFuture = _gastoService.getGastosHoy(fecha);
      final pagosFuture = _pagoService.getPagosHoy(fecha);
      final cierresFuture = _cierreService.getCierresHoy(fecha);

      final gastosData = await gastosFuture;
      final pagosData = await pagosFuture;
      final cierresData = await cierresFuture;

      final gastos = gastosData
          .map((j) => ActivityItem.fromGasto(j))
          .toList();
      final pagos = pagosData
          .map((j) => ActivityItem.fromPago(j))
          .toList();

      _actividadHoy = [...gastos, ...pagos];

      // Compute gastos total from real data
      _gastosPendientes = Decimal.zero;
      for (final item in _actividadHoy) {
        _gastosPendientes += item.monto;
      }

      // Compute utilidad from today's cierres
      _cierresHoy = cierresData.map((j) => Cierre.fromJson(j)).toList();
      _utilidadHoy = Decimal.zero;
      for (final cierre in _cierresHoy) {
        _utilidadHoy += cierre.utilidadNeta;
      }
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }
}
