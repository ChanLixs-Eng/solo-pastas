import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/dashboard_provider.dart';
import 'providers/menu_provider.dart';
import 'providers/gasto_provider.dart';
import 'providers/personal_provider.dart';
import 'providers/reportes_provider.dart';
import 'services/http_service.dart';
import 'services/producto_service.dart';
import 'services/gasto_service.dart';
import 'services/personal_service.dart';
import 'services/pago_service.dart';
import 'services/cierre_service.dart';

void main() {
  final httpService = HttpService();
  final productoService = ProductoService(httpService);
  final gastoService = GastoService(httpService);
  final personalService = PersonalService(httpService);
  final pagoService = PagoService(httpService);
  final cierreService = CierreService(httpService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider(productoService)),
        ChangeNotifierProvider(create: (_) => GastoProvider(gastoService)),
        ChangeNotifierProvider(
          create: (_) => PersonalProvider(personalService, pagoService),
        ),
        ChangeNotifierProvider(
          create: (_) => ReportesProvider(cierreService),
        ),
      ],
      child: const SoloPastasApp(),
    ),
  );
}
