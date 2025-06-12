import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../3_products/product_model.dart';
import 'pos_repository.dart';

part 'pos_state.dart';

class PosCubit extends Cubit<PosState> {
  final PosRepository _repository;
  PosCubit(this._repository) : super(const PosState());

  Future<void> addProductByBarcode(String barcode) async {
    final product = await _repository.findProductByBarcode(barcode);
    if (product != null) {
      if (product.quantity > 0) {
        final newCart = List<Product>.from(state.cart)..add(product);
        final newTotal = state.total + product.price;
        emit(state.copyWith(cart: newCart, total: newTotal, status: PosStatus.initial));
      } else {
        emit(state.copyWith(status: PosStatus.error)); // Qoldiqda yo'q
      }
    } else {
      emit(state.copyWith(status: PosStatus.productNotFound)); // Mahsulot topilmadi
    }
  }

  Future<void> completeSale(String paymentType) async {
    emit(state.copyWith(status: PosStatus.loading));
    try {
      await _repository.createSale(state.cart, state.total, paymentType);
      emit(const PosState(status: PosStatus.success)); // Savatni tozalab, boshlang'ich holatga qaytaramiz
    } catch (e) {
      emit(state.copyWith(status: PosStatus.error));
    }
  }

  void clearCart() {
    emit(const PosState());
  }
}