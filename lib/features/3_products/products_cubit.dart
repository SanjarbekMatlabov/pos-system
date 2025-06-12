import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'products_repository.dart';
import 'product_model.dart';

// State klasslari (o'zgarishsiz qoladi)
part 'products_state.dart'; // State'larni alohida faylga chiqaramiz

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository _repository;

  ProductsCubit(this._repository) : super(ProductsInitial());

  // Barcha mahsulotlarni yuklash
  Future<void> fetchProducts() async {
    emit(ProductsLoading());
    try {
      final products = await _repository.getAllProducts();
      emit(ProductsLoaded(products));
    } catch (_) {
      emit(ProductsError("Mahsulotlarni yuklashda xatolik!"));
    }
  }

  // Mahsulot qo'shish
  Future<void> addProduct(Product product) async {
    try {
      await _repository.addProduct(product);
      fetchProducts(); // Ro'yxatni yangilash
    } catch (_) {
      emit(ProductsError("Mahsulot qo'shishda xatolik!"));
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _repository.updateProduct(product);
      fetchProducts(); // Ro'yxatni yangilash
    } catch (_) {
      emit(ProductsError("Mahsulotni tahrirlashda xatolik!"));
    }
  }

  // Mahsulotni o'chirish
  Future<void> deleteProduct(String id) async {
    try {
      await _repository.deleteProduct(id);
      fetchProducts(); // Ro'yxatni yangilash
    } catch (_) {
      emit(ProductsError("Mahsulotni o'chirishda xatolik!"));
    }
  }
}
