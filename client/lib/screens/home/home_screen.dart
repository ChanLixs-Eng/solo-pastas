import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/activity_item.dart';
import '../../providers/dashboard_provider.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int> onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadActivity();
    });
  }

  void _loadActivity() {
    final fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());
    context.read<DashboardProvider>().loadTodayActivity(fecha);
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();
    final now = DateTime.now();
    final dateStr =
        DateFormat("EEEE, d 'de' MMMM 'de' yyyy", 'es').format(now);
    final dateCapitalized = dateStr[0].toUpperCase() + dateStr.substring(1);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Title
            Center(
              child: Text(
                'SOLO PASTAS',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkRed,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Date
            Center(
              child: Text(
                dateCapitalized,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.greyText,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (dashboard.error != null)
              _ErrorBanner(
                message: dashboard.error!,
                onRetry: _loadActivity,
              ),
            // Summary card
            _SummaryCard(
              utilidad: dashboard.utilidadHoy,
              gastos: dashboard.gastosPendientes,
              pagos: dashboard.pagosPendientes,
              hasCierre: dashboard.hasCierre,
            ),
            const SizedBox(height: 24),
            // Quick actions
            const Text(
              'Acciones Rápidas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    label: 'CERRAR\nCAJA',
                    icon: Icons.point_of_sale,
                    color: AppColors.green,
                    onTap: () => widget.onNavigate(3),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionButton(
                    label: 'REGISTRAR\nGASTO',
                    icon: Icons.remove,
                    color: AppColors.orange,
                    onTap: () => widget.onNavigate(1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Recent activity
            const Text(
              'ACTIVIDAD RECIENTE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            _RecentActivityList(items: dashboard.actividadHoy),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// --- Summary Card ---

class _SummaryCard extends StatelessWidget {
  final Decimal utilidad;
  final Decimal gastos;
  final Decimal pagos;
  final bool hasCierre;

  const _SummaryCard({
    required this.utilidad,
    required this.gastos,
    required this.pagos,
    required this.hasCierre,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = utilidad >= Decimal.zero;
    final sign = isPositive ? '+ ' : '- ';
    final utilidadAbs = isPositive ? utilidad : -utilidad;
    final totalEgresos = gastos + pagos;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                // Left: utilidad
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$sign Bs. ${utilidadAbs.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isPositive ? AppColors.green : AppColors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasCierre ? 'Utilidad Hoy' : 'Egresos del Día',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.greyText,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right: total egresos
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '- Bs. ${totalEgresos.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Total Egresos',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (!hasCierre) ...[
              const SizedBox(height: 8),
              Text(
                'Caja abierta — cierra caja para ver utilidad',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.greyText,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// --- Error Banner ---

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Error al cargar datos',
              style: TextStyle(color: AppColors.red, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

// --- Quick Action Button ---

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Recent Activity List ---

class _RecentActivityList extends StatelessWidget {
  final List<ActivityItem> items;

  const _RecentActivityList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        alignment: Alignment.center,
        child: const Text(
          'Sin actividad reciente',
          style: TextStyle(color: AppColors.greyText, fontSize: 14),
        ),
      );
    }

    final visible = items.take(5).toList();

    return Column(
      children: visible.map((item) => _ActivityRow(item: item)).toList(),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final ActivityItem item;

  const _ActivityRow({required this.item});

  IconData _icon() {
    if (item.type == ActivityType.pago) return Icons.person_outline;
    switch (item.subtipo) {
      case 'Insumo':
        return Icons.shopping_basket_outlined;
      case 'Servicio':
        return Icons.build_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  Color _color() {
    return item.type == ActivityType.pago ? AppColors.darkRed : AppColors.orange;
  }

  String _label() {
    if (item.type == ActivityType.pago) {
      return 'Pago - ${item.descripcion}';
    }
    return 'Gasto - ${item.descripcion}';
  }

  String _timeAgo(String? hora) {
    if (hora == null) return '';
    try {
      final parts = hora.split(':');
      final now = DateTime.now();
      final time = DateTime(
        now.year, now.month, now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
        parts.length > 2 ? int.parse(parts[2]) : 0,
      );
      final diff = now.difference(time);
      if (diff.inMinutes < 1) return 'ahora';
      if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
      if (diff.inHours < 24) return 'hace ${diff.inHours} h';
      return hora.substring(0, 5);
    } catch (_) {
      return hora;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_icon(), color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _label(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.hora != null)
                  Text(
                    _timeAgo(item.hora),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.greyText,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '-Bs. ${item.monto.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
