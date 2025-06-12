import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'product_model.dart';
import 'products_cubit.dart';

class ProductEditScreen extends StatefulWidget {
  final Product? product; // Tahrirlash uchun kelgan mahsulot
  const ProductEditScreen({super.key, this.product});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _id;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _costPriceController;
  late TextEditingController _quantityController;
  late TextEditingController _barcodeController;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _id = widget.product?.id ?? const Uuid().v4();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _costPriceController = TextEditingController(text: widget.product?.costPrice.toString() ?? '');
    _quantityController = TextEditingController(text: widget.product?.quantity.toString() ?? '');
    _barcodeController = TextEditingController(text: widget.product?.barcode ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _costPriceController.dispose();
    _quantityController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: _id,
        name: _nameController.text,
        price: double.parse(_priceController.text),
        costPrice: double.parse(_costPriceController.text),
        quantity: double.parse(_quantityController.text),
        barcode: _barcodeController.text,
      );
      if (_isEditing) {
        context.read<ProductsCubit>().updateProduct(product);
      } else {
        context.read<ProductsCubit>().addProduct(product);
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Mahsulotni Tahrirlash' : 'Yangi Mahsulot')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nomi')),
            TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: 'Sotish narxi')),
            TextFormField(controller: _costPriceController, decoration: const InputDecoration(labelText: 'Kelgan narxi')),
            TextFormField(controller: _quantityController, decoration: const InputDecoration(labelText: 'Miqdori (qoldiq)')),
            TextFormField(controller: _barcodeController, decoration: const InputDecoration(labelText: 'Shtrix-kod')),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _onSave, child: const Text('Saqlash')),
          ],
        ),
      ),
    );
  }
}