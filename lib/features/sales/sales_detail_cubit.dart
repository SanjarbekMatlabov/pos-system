import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'sales_repository.dart';

part 'sale_detail_state.dart';

class SaleDetailCubit extends Cubit<SaleDetailState> {
  final SalesRepository _repository;
  SaleDetailCubit(this._repository) : super(SaleDetailInitial());

  Future<void> fetchSaleDetails(int saleId) async {
    emit(SaleDetailLoading());
    try {
      final items = await _repository.getSaleItems(saleId);
      emit(SaleDetailLoaded(items));
    } catch (_) {
      emit(const SaleDetailError("Chek ma'lumotlarini yuklashda xatolik!"));
    }
  }
}