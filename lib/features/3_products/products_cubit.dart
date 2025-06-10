import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salom_pos/features/3_products/product_model.dart';
import 'package:salom_pos/features/3_products/products_repository.dart';

// --- STATE ---
enum ProductStatus { initial, loading, success, error }

class ProductsState extends Equatable {
  final ProductStatus status;
  final List<Product> products;

  const ProductsState({
    this.status = ProductStatus.initial,
    this.products = const [],
  });

  ProductsState copyWith({
    ProductStatus? status,
    List<Product>? products,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [status, products];
}

// --- CUBIT ---
class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository _productsRepository;

  ProductsCubit(this._productsRepository) : super(const ProductsState());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final products = await _productsRepository.getProducts();
      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error));
    }
  }
}