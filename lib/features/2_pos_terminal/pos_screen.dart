import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pos_cubit.dart';
import 'pos_repository.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PosCubit(PosRepository()),
      child: const PosView(),
    );
  }
}

class PosView extends StatefulWidget {
  const PosView({super.key});
  @override
  State<PosView> createState() => _PosViewState();
}

class _PosViewState extends State<PosView> {
  final _barcodeController = TextEditingController();
  final _barcodeFocusNode = FocusNode();

  @override
  void dispose() {
    _barcodeController.dispose();
    _barcodeFocusNode.dispose();
    super.dispose();
  }

  void _onBarcodeScanned(String barcode) {
    if (barcode.isNotEmpty) {
      context.read<PosCubit>().addProductByBarcode(barcode);
    }
    _barcodeController.clear();
    _barcodeFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 250, height: 40,
          child: TextField(
            controller: _barcodeController,
            focusNode: _barcodeFocusNode,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Skanerlang...'),
            onSubmitted: _onBarcodeScanned,
          ),
        ),
      ),
      body: BlocListener<PosCubit, PosState>(
        listener: (context, state) {
          if (state.status == PosStatus.productNotFound) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mahsulot topilmadi!"), backgroundColor: Colors.orange));
          } else if (state.status == PosStatus.error) {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Xatolik yoki mahsulot qolmagan!"), backgroundColor: Colors.red));
          } else if (state.status == PosStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sotuv muvaffaqiyatli amalga oshirildi!"), backgroundColor: Colors.green));
          }
        },
        child: BlocBuilder<PosCubit, PosState>(
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  flex: 7,
                  child: ListView.builder(
                    itemCount: state.cart.length,
                    itemBuilder: (context, index) {
                      final product = state.cart[index];
                      return ListTile(title: Text(product.name), trailing: Text("${product.price} so'm"));
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Jami: ${state.total} so'm", style: Theme.of(context).textTheme.headlineSmall),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: state.cart.isEmpty ? null : () => context.read<PosCubit>().completeSale('Naqd'),
                            child: const Text("To'lov (Naqd)"),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => context.read<PosCubit>().clearCart(),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text("Bekor qilish"),
                          ),
                        ],
                      ),
                    ),
                  )
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}