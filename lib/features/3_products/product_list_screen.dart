import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:salom_pos/features/3_products/products_cubit.dart';
import 'package:salom_pos/features/3_products/products_repository.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Bu ekran uchun ProductsRepository va ProductsCubit'ni yaratib,
      // darhol mahsulotlarni yuklashni boshlaymiz
      create: (context) => ProductsCubit(ProductsRepository())..loadProducts(),
      child: const ProductListView(),
    );
  }
}
class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mahsulotlar')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Yangi mahsulot qo'shish ekraniga o'tamiz (hech qanday ma'lumot uzatmaymiz)
          context.goNamed('product_edit');
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          // ... loading va error holatlari ...
          if (state.status == ProductStatus.loading || state.status == ProductStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${product.price} so\'m'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_note),
                    onPressed: () {
                      // Tahrirlash ekraniga o'tamiz va shu mahsulotni `extra` orqali uzatamiz
                      context.goNamed('product_edit', extra: product);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}