import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salom_pos/features/3_products/product_model.dart';

// --- STATE ---

// Holat statusi
enum ReportStatus { initial, loading, success, error }

class ReportsState extends Equatable {
  final ReportStatus status;
  // KPI'lar uchun ma'lumotlar
  final double todaySales;
  final int todayCheckCount;
  final double averageCheck;
  // Grafik uchun ma'lumotlar (haftaning 7 kuni)
  final List<double> weeklySalesData;
  // Ro'yxatlar uchun ma'lumotlar
  final List<Product> topSellingProducts;
  final List<Product> lowStockProducts;

  const ReportsState({
    this.status = ReportStatus.initial,
    this.todaySales = 0.0,
    this.todayCheckCount = 0,
    this.averageCheck = 0.0,
    this.weeklySalesData = const [],
    this.topSellingProducts = const [],
    this.lowStockProducts = const [],
  });
  
  ReportsState copyWith({
    ReportStatus? status,
    double? todaySales,
    int? todayCheckCount,
    double? averageCheck,
    List<double>? weeklySalesData,
    List<Product>? topSellingProducts,
    List<Product>? lowStockProducts,
  }) {
    return ReportsState(
      status: status ?? this.status,
      todaySales: todaySales ?? this.todaySales,
      todayCheckCount: todayCheckCount ?? this.todayCheckCount,
      averageCheck: averageCheck ?? this.averageCheck,
      weeklySalesData: weeklySalesData ?? this.weeklySalesData,
      topSellingProducts: topSellingProducts ?? this.topSellingProducts,
      lowStockProducts: lowStockProducts ?? this.lowStockProducts,
    );
  }

  @override
  List<Object?> get props => [status, todaySales, todayCheckCount, averageCheck, weeklySalesData, topSellingProducts, lowStockProducts];
}

// --- CUBIT ---

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(const ReportsState());

  Future<void> fetchDashboardData() async {
    emit(state.copyWith(status: ReportStatus.loading));
    
    // Serverdan ma'lumot kelishini imitatsiya qilamiz
    await Future.delayed(const Duration(seconds: 1));

    // Soxta ma'lumotlarni yaratamiz
    emit(state.copyWith(
      status: ReportStatus.success,
      todaySales: 5430000.50,
      todayCheckCount: 128,
      averageCheck: 42425.78,
      weeklySalesData: [3.4, 5.1, 4.0, 6.8, 5.5, 7.2, 5.4], // million so'mda
      topSellingProducts: [
        const Product(id: '1', name: 'Coca-Cola 1.5L', price: 12000, barcode: '86001'),
        const Product(id: '3', name: 'Non (buxanka)', price: 2800, barcode: '86003'),
      ],
      lowStockProducts: [
        const Product(id: '2', name: 'Fanta 1.5L', price: 12000, barcode: '86002'),
        const Product(id: '4', name: 'Nestle Suv 1L', price: 3000, barcode: '86004'),
      ],
    ));
  }
}