import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../3_products/product_model.dart';
import '../3_products/products_repository.dart';
import 'inventory_repository.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final InventoryRepository _inventoryRepository;
  final ProductsRepository _productsRepository;

  InventoryCubit(this._inventoryRepository, this._productsRepository) : super(const InventoryState());

  // Sahifa ochilganda tanlash uchun barcha mahsulotlarni yuklash
  Future<void> loadProductsForSelection() async {
    try {
      final products = await _productsRepository.getAllProducts();
      emit(state.copyWith(status: InventoryStatus.loaded, products: products));
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.error, errorMessage: "Mahsulotlarni yuklab bo'lmadi"));
    }
  }

  // Kirimni ro'yxatdan o'tkazish
  Future<void> registerStockIn({
    required String productId,
    required double quantity,
    required String reason,
  }) async {
    emit(state.copyWith(status: InventoryStatus.loading));
    try {
      await _inventoryRepository.addStockEntry(
        productId: productId,
        quantity: quantity,
        reason: reason,
      );
      emit(state.copyWith(status: InventoryStatus.success));
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.error, errorMessage: "Kirim qilishda xatolik!"));
    }
  }
}