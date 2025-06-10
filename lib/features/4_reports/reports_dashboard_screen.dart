import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salom_pos/app/config/app_theme.dart';
import 'package:salom_pos/features/4_reports/reports_cubit.dart';

class ReportsDashboardScreen extends StatelessWidget {
  const ReportsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportsCubit()..fetchDashboardData(),
      child: const ReportsDashboardView(),
    );
  }
}

class ReportsDashboardView extends StatelessWidget {
  const ReportsDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boshqaruv Paneli')),
      body: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          if (state.status == ReportStatus.loading || state.status == ReportStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ReportStatus.error) {
            return const Center(child: Text('Ma\'lumot yuklashda xatolik!'));
          }

          return RefreshIndicator(
            onRefresh: () => context.read<ReportsCubit>().fetchDashboardData(),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // KPI Kartochkalari
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _buildKpiCard('Bugungi Savdo', '${state.todaySales.toStringAsFixed(0)} so\'m', Icons.trending_up),
                    _buildKpiCard('Cheklar Soni', '${state.todayCheckCount}', Icons.receipt_long),
                    _buildKpiCard('O\'rtacha Chek', '${state.averageCheck.toStringAsFixed(0)} so\'m', Icons.bar_chart),
                    _buildKpiCard('Ombor Qoldig\'i', '125.8 mln so\'m', Icons.inventory_2),
                  ],
                ),
                const SizedBox(height: 24),

                // Haftalik Savdo Grafigi
                _buildSectionTitle('Haftalik Savdo Grafigi'),
                Container(
                  height: 200,
                  padding: const EdgeInsets.only(top: 24, right: 12),
                  child: BarChart(_buildWeeklyChartData(context, state.weeklySalesData)),
                ),
                const SizedBox(height: 24),
                
                // Ro'yxatlar
                _buildSectionTitle('Eng Ko\'p Sotilganlar'),
                ...state.topSellingProducts.map((p) => Card(child: ListTile(title: Text(p.name)))),
                const SizedBox(height: 16),
                _buildSectionTitle('Tugab Borayotganlar'),
                 ...state.lowStockProducts.map((p) => Card(child: ListTile(title: Text(p.name), trailing: const Text('5 dona qoldi', style: TextStyle(color: Colors.orange))))),

              ],
            ),
          );
        },
      ),
    );
  }

  // Yordamchi vidjetlar
  Widget _buildKpiCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 28, color: AppTheme.primaryColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  BarChartData _buildWeeklyChartData(BuildContext context, List<double> data) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      barTouchData: BarTouchData(enabled: false),
      titlesData: const FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: _bottomTitles)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: data.asMap().entries.map((e) {
        return BarChartGroupData(
          x: e.key,
          barRods: [BarChartRodData(toY: e.value, color: AppTheme.primaryColor, width: 16, borderRadius: BorderRadius.circular(4))],
        );
      }).toList(),
    );
  }
  
  static Widget _bottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: Colors.grey,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'Du';
      break;
    case 1:
      text = 'Se';
      break;
    case 2:
      text = 'Ch';
      break;
    case 3:
      text = 'Pa';
      break;
    case 4:
      text = 'Ju';
      break;
    case 5:
      text = 'Sh';
      break;
    case 6:
      text = 'Ya';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    space: 4,
    meta: meta,
    child: Text(
      text,
      style: style,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
  );
}
}