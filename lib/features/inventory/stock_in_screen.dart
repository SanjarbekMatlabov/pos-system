import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../3_products/product_model.dart';
import '../3_products/products_repository.dart';
import 'inventory_cubit.dart';
import 'inventory_repository.dart';

class StockInScreen extends StatelessWidget {
  const StockInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryCubit(InventoryRepository(), ProductsRepository())..loadProductsForSelection(),
      child: const StockInView(),
    );
  }
}

class StockInView extends StatefulWidget {
  const StockInView({super.key});
  @override
  State<StockInView> createState() => _StockInViewState();
}

class _StockInViewState extends State<StockInView> {
  Product? _selectedProduct;
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      context.read<InventoryCubit>().registerStockIn(
        productId: _selectedProduct!.id,
        quantity: double.parse(_quantityController.text),
        reason: _reasonController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Omborga Kirim Qilish")),
      body: BlocListener<InventoryCubit, InventoryState>(
        listener: (context, state) {
          if (state.status == InventoryStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Muvaffaqiyatli kirim qilindi!"), backgroundColor: Colors.green));
            context.pop();
          } else if (state.status == InventoryStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red));
          }
        },
        child: BlocBuilder<InventoryCubit, InventoryState>(
          builder: (context, state) {
            if (state.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  DropdownButtonFormField<Product>(
                    value: _selectedProduct,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Mahsulotni tanlang'),
                    items: state.products.map((Product product) {
                      return DropdownMenuItem<Product>(
                        value: product,
                        child: Text(product.name),
                      );
                    }).toList(),
                    onChanged: (Product? newValue) {
                      setState(() {
                        _selectedProduct = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'Mahsulot tanlanishi shart' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Miqdori'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                    validator: (value) => (value == null || value.isEmpty) ? 'Miqdorni kiriting' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _reasonController,
                    decoration: const InputDecoration(labelText: 'Sabab (masalan, "Omborga qabul")'),
                    validator: (value) => (value == null || value.isEmpty) ? 'Sababni kiriting' : null,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: state.status == InventoryStatus.loading ? null : _onSave,
                    child: const Text('Kirim Qilish'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}