import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'reports_repository.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepository _repository;

  ReportsCubit(this._repository) : super(ReportsInitial());

  Future<void> fetchDashboardData() async {
    emit(ReportsLoading());
    try {
      // Barcha so'rovlarni parallel ravishda yuboramiz
      final results = await Future.wait([
        _repository.getTodaySalesTotal(),
        _repository.getTodayCheckCount(),
        _repository.getWeeklySales(),
        _repository.getTopSellingProducts(),
        _repository.getLowStockProducts(),
      ]);
      
      final todaySales = results[0] as double;
      final todayCheckCount = results[1] as int;
      final weeklySalesRaw = results[2] as List<Map<String, dynamic>>;
      final topProductsRaw = results[3] as List<Map<String, dynamic>>;
      final lowStockProductsRaw = results[4] as List<Map<String, dynamic>>;

      // Grafik uchun ma'lumotni tayyorlash
      final weeklySalesData = List.generate(7, (index) {
          final day = DateTime.now().subtract(Duration(days: 6 - index));
          final dayString = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
          final sale = weeklySalesRaw.firstWhere((e) => e['sale_day'] == dayString, orElse: () => {'daily_total': 0.0});
          return sale['daily_total'] as double;
      });

      emit(ReportsLoaded(
        todaySales: todaySales,
        todayCheckCount: todayCheckCount,
        averageCheck: todayCheckCount > 0 ? todaySales / todayCheckCount : 0.0,
        weeklySalesData: weeklySalesData,
        topSellingProducts: topProductsRaw,
        lowStockProducts: lowStockProductsRaw,
      ));

    } catch (e) {
      emit(ReportsError("Hisobotlarni yuklashda xatolik: $e"));
    }
  }
}