part of 'pos_cubit.dart';

enum PosStatus { initial, loading, success, error, productNotFound }

class PosState extends Equatable {
  final List<Product> cart;
  final double total;
  final PosStatus status;

  const PosState({
    this.cart = const [],
    this.total = 0.0,
    this.status = PosStatus.initial,
  });

  PosState copyWith({List<Product>? cart, double? total, PosStatus? status}) {
    return PosState(
      cart: cart ?? this.cart,
      total: total ?? this.total,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [cart, total, status];
}