import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:salom_pos/features/3_products/product_model.dart';
import 'package:salom_pos/features/3_products/products_cubit.dart';

class ProductEditScreen extends StatefulWidget {
  // Bu ekranga tahrirlash uchun mahsulot berib yuborilishi mumkin (agar null bo'lsa, demak yangi mahsulot qo'shilyapti)
  final Product? product;
  const ProductEditScreen({super.key, this.product});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _barcodeController;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _barcodeController = TextEditingController(text: widget.product?.barcode ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final barcode = _barcodeController.text;

      if (_isEditing) {
        // Tahrirlash
        final updatedProduct = Product(
          id: widget.product!.id,
          name: name,
          price: price,
          barcode: barcode,
        );
        context.read<ProductsCubit>().updateProduct(updatedProduct);
      } else {
        // Qo'shish
        context.read<ProductsCubit>().addProduct(name: name, price: price, barcode: barcode);
      }
      // Barcha amallar tugagach, orqaga qaytamiz
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Mahsulotni Tahrirlash' : 'Yangi Mahsulot'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Mahsulot Nomi'),
                validator: (value) => value!.isEmpty ? 'Nomini kiriting' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Narxi (so\'mda)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Narxini kiriting' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _barcodeController,
                decoration: const InputDecoration(labelText: 'Shtrix-kod'),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProduct,
                child: const Text('Saqlash'),
              )
            ],
          ),
        ),
      ),
    );
  }
}