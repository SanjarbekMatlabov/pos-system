import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salom_pos/features/2_pos_terminal/pos_cubit.dart';
import 'package:salom_pos/features/3_products/product_model.dart';

// Soxta ma'lumotlar bazasi (test uchun)
const List<Product> fakeProducts = [
  Product(id: '1', name: 'Coca-Cola 1.5L', price: 12000, barcode: '86001'),
  Product(id: '2', name: 'Fanta 1.5L', price: 12000, barcode: '86002'),
  Product(id: '3', name: 'Non (buxanka)', price: 2800, barcode: '86003'),
  Product(id: '4', name: 'Nestle Suv 1L', price: 3000, barcode: '86004'),
];

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PosCubit(),
      child: const PosView(),
    );
  }
}

class PosView extends StatelessWidget {
  const PosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sotuv Terminali'),
        actions: [
          // Test uchun "Scan" tugmasi
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              // Tasodifiy mahsulotni savatga qo'shamiz (skanerlash imitatsiyasi)
              final product = fakeProducts[(DateTime.now().second % fakeProducts.length)];
              context.read<PosCubit>().addProduct(product);
            },
            tooltip: 'Mahsulot Skanerlash',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              context.read<PosCubit>().clearCart();
            },
            tooltip: 'Savatni tozalash',
          ),
        ],
      ),
      body: BlocBuilder<PosCubit, PosState>(
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CHAP PANEL: Savat ro'yxati
              Expanded(
                flex: 7,
                child: state.cartItems.isEmpty
                    ? const Center(child: Text('Savat bo\'sh. Skanerlang...', style: TextStyle(fontSize: 20)))
                    : ListView.builder(
                        itemCount: state.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = state.cartItems[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: ListTile(
                              title: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('${item.product.price} so\'m x ${item.quantity}'),
                              trailing: SizedBox(
                                width: 150,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('${item.totalPrice} so\'m', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(width: 10),
                                    IconButton(onPressed: () => context.read<PosCubit>().decrementQuantity(item), icon: const Icon(Icons.remove_circle)),
                                    IconButton(onPressed: () => context.read<PosCubit>().incrementQuantity(item), icon: const Icon(Icons.add_circle)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              // O'NG PANEL: Jami hisob va to'lov
              Expanded(
                flex: 3,
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Umumiy Hisob', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const Divider(height: 30),
                        _buildSummaryRow('Oraliq Jami:', '${state.subtotal} so\'m'),
                        const SizedBox(height: 10),
                        _buildSummaryRow('Chegirma:', '0 so\'m'),
                        const Divider(height: 30),
                        _buildSummaryRow('JAMI:', '${state.total} so\'m', isTotal: true),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: state.cartItems.isEmpty ? null : () { /* To'lov logikasi keyin qo'shiladi */ },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(20),
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),
                          child: const Text("To'lovga o'tish", style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    final style = TextStyle(
      fontSize: isTotal ? 20 : 16,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(title, style: style), Text(value, style: style)],
    );
  }
}