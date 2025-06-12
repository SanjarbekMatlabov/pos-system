import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Sana formatlash uchun. `flutter pub add intl`
import '../3_products/product_model.dart';
import 'inventory_repository.dart';
import 'stock_history_cubit.dart';

class StockHistoryScreen extends StatelessWidget {
  final Product product;
  const StockHistoryScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StockHistoryCubit(InventoryRepository())..fetchHistory(product.id),
      child: StockHistoryView(product: product),
    );
  }
}

class StockHistoryView extends StatelessWidget {
  final Product product;
  const StockHistoryView({super.key, required this.product});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${product.name} Harakatlar Tarixi"),
      ),
      body: BlocBuilder<StockHistoryCubit, StockHistoryState>(
        builder: (context, state) {
          if (state.status == StockHistoryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == StockHistoryStatus.error) {
            return Center(child: Text(state.errorMessage ?? "Xatolik"));
          }
          if (state.history.isEmpty) {
            return const Center(child: Text("Bu mahsulot uchun harakatlar mavjud emas."));
          }

          return ListView.builder(
            itemCount: state.history.length,
            itemBuilder: (context, index) {
              final entry = state.history[index];
              final isIncome = entry['type'] == 'IN';
              final quantity = entry['quantity'];
              final date = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(entry['date']));
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    "${isIncome ? '+' : ''}$quantity dona",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                  subtitle: Text(entry['reason'] ?? 'Sotuv'),
                  trailing: Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}