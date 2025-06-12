part of 'stock_history_cubit.dart';

enum StockHistoryStatus { initial, loading, success, error }

class StockHistoryState extends Equatable {
  final StockHistoryStatus status;
  final List<Map<String, dynamic>> history;
  final String? errorMessage;

  const StockHistoryState({
    this.status = StockHistoryStatus.initial,
    this.history = const [],
    this.errorMessage,
  });

  StockHistoryState copyWith({
    StockHistoryStatus? status,
    List<Map<String, dynamic>>? history,
    String? errorMessage,
  }) {
    return StockHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, history, errorMessage];
}