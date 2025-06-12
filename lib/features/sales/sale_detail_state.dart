part of 'sales_detail_cubit.dart';

abstract class SaleDetailState extends Equatable {
  const SaleDetailState();

  @override
  List<Object> get props => [];
}

class SaleDetailInitial extends SaleDetailState {}

class SaleDetailLoading extends SaleDetailState {}

class SaleDetailLoaded extends SaleDetailState {
  // Bitta chek tarkibidagi mahsulotlar ro'yxati
  final List<Map<String, dynamic>> items;

  const SaleDetailLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class SaleDetailError extends SaleDetailState {
  final String message;

  const SaleDetailError(this.message);

  @override
  List<Object> get props => [message];
}