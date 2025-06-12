part of 'sales_history_cubit.dart'; 

abstract class SalesHistoryState extends Equatable {
  const SalesHistoryState();

  @override
  List<Object> get props => [];
}

class SalesHistoryInitial extends SalesHistoryState {}

class SalesHistoryLoading extends SalesHistoryState {}

class SalesHistoryLoaded extends SalesHistoryState {
  // Barcha sotuvlar ro'yxati (har bir element - bitta chek)
  final List<Map<String, dynamic>> sales;

  const SalesHistoryLoaded(this.sales);

  @override
  List<Object> get props => [sales];
}

class SalesHistoryError extends SalesHistoryState {
  final String message;

  const SalesHistoryError(this.message);

  @override
  List<Object> get props => [message];
}