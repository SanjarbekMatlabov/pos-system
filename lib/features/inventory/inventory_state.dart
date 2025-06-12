part of 'inventory_cubit.dart';

enum InventoryStatus { initial, loading, success, error, loaded }

class InventoryState extends Equatable {
  final InventoryStatus status;
  final List<Product> products; 
  final String? errorMessage;

  const InventoryState({
    this.status = InventoryStatus.initial,
    this.products = const [],
    this.errorMessage,
  });
  
  InventoryState copyWith({
    InventoryStatus? status,
    List<Product>? products,
    String? errorMessage,
  }) {
    return InventoryState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}