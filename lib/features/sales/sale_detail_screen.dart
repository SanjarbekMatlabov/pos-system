import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sales_detail_cubit.dart';
import 'sales_repository.dart';
import 'package:printing/printing.dart'; 
import '../../app/services/pdf_service.dart';

class SaleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> sale;
  const SaleDetailScreen({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaleDetailCubit(SalesRepository())..fetchSaleDetails(sale['id']),
      child: Scaffold(
        appBar: AppBar(title: Text("Chek №${sale['id']} Tafsilotlari"),
        actions: [
            BlocBuilder<SaleDetailCubit, SaleDetailState>(
              builder: (context, state) {
                if (state is SaleDetailLoaded) {
                  return IconButton(
                    icon: const Icon(Icons.print),
                    onPressed: () async {
                      // PDF yaratib, chop etish oynasiga yuboramiz
                      final Uint8List pdfBytes = await PdfCheckService.generateCheck(sale, state.items);
                      await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
                    },
                  );
                }
                return const SizedBox.shrink(); // Agar yuklanayotgan bo'lsa tugma ko'rinmaydi
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Jami: ${sale['total_amount']} so'm", style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
      ),
    );
  }
}