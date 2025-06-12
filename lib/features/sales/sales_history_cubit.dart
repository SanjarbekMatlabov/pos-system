import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'sales_repository.dart';

part 'sales_history_state.dart';

class SalesHistoryCubit extends Cubit<SalesHistoryState> {
  final SalesRepository _repository;
  SalesHistoryCubit(this._repository) : super(SalesHistoryInitial());

  Future<void> fetchSalesHistory() async {
    emit(SalesHistoryLoading());
    try {
      final sales = await _repository.getAllSales();
      emit(SalesHistoryLoaded(sales));
    } catch (_) {
      emit(const SalesHistoryError("Sotuvlar tarixini yuklashda xatolik!"));
    }
  }
}