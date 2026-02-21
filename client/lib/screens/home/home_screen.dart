import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/action_circle_button.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();
    final now = DateTime.now();
    final dateStr =
        DateFormat("EEEE, d MMM yyyy", 'es').format(now);
    // Capitalize first letter
    final dateCapitalized =
        dateStr[0].toUpperCase() + dateStr.substring(1);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Solo Pastas',
              style: GoogleFonts.playfairDisplay(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.darkRed,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateCapitalized,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                SummaryCard(
                  title: 'Utilidad\nHoy',
                  amount: dashboard.utilidadHoy,
                  color: AppColors.green,
                ),
                const SizedBox(width: 16),
                SummaryCard(
                  title: 'Gastos\nPendientes',
                  amount: dashboard.gastosPendientes,
                  color: AppColors.orange,
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionCircleButton(
                  label: 'Registrar\nVenta',
                  color: AppColors.green,
                  onTap: () => onNavigate(4), // Reportes tab for cierre
                ),
                ActionCircleButton(
                  label: 'Registrar\nGasto',
                  color: AppColors.orange,
                  onTap: () => onNavigate(2), // Gastos tab
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
