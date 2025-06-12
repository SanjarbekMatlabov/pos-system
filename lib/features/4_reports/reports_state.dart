part of 'reports_cubit.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();
  @override
  List<Object> get props => [];
}

class ReportsInitial extends ReportsState {}
class ReportsLoading extends ReportsState {}
class ReportsLoaded extends ReportsState {
  final double todaySales;
  final int todayCheckCount;
  final double averageCheck;
  final List<double> weeklySalesData;
  final List<Map<String, dynamic>> topSellingProducts;
  final List<Map<String, dynamic>> lowStockProducts;

  const ReportsLoaded({
    required this.todaySales,
    required this.todayCheckCount,
    required this.averageCheck,
    required this.weeklySalesData,
    required this.topSellingProducts,
    required this.lowStockProducts,
  });
  
  @override
  List<Object> get props => [todaySales, todayCheckCount, averageCheck, weeklySalesData, topSellingProducts,lowStockProducts];
}
class ReportsError extends ReportsState {
  final String message;
  const ReportsError(this.message);
  @override
  List<Object> get props => [message];
}