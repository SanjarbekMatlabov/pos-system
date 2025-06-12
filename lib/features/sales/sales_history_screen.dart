import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'sales_history_cubit.dart';
import 'sales_repository.dart';

class SalesHistoryScreen extends StatelessWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalesHistoryCubit(SalesRepository())..fetchSalesHistory(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Sotuvlar Tarixi")),
        body: BlocBuilder<SalesHistoryCubit, SalesHistoryState>(
          builder: (context, state) {
            if (state is SalesHistoryLoading) return const Center(child: CircularProgressIndicator());
            if (state is SalesHistoryError) return Center(child: Text(state.message));
            if (state is SalesHistoryLoaded) {
              return ListView.builder(
                itemCount: state.sales.length,
                itemBuilder: (context, index) {
                  final sale = state.sales[index];
                  final date = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(sale['date']));
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${sale['id']}')),
                      title: Text("${sale['total_amount']} so'm"),
                      subtitle: Text(date),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/sales/detail', extra: sale),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}