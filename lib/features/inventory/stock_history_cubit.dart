import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'inventory_repository.dart';

part 'stock_history_state.dart';

class StockHistoryCubit extends Cubit<StockHistoryState> {
  final InventoryRepository _repository;

  StockHistoryCubit(this._repository) : super(const StockHistoryState());

  Future<void> fetchHistory(String productId) async {
    emit(state.copyWith(status: StockHistoryStatus.loading));
    try {
      final history = await _repository.getStockHistoryForProduct(productId);
      emit(state.copyWith(status: StockHistoryStatus.success, history: history));
    } catch (e) {
      emit(state.copyWith(status: StockHistoryStatus.error, errorMessage: "Tarixni yuklab bo'lmadi"));
    }
  }
}