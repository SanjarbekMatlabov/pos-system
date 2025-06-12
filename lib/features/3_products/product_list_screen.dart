import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'products_cubit.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mahsulotlar Bazasi")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/products/add'),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductsError) {
            return Center(child: Text(state.message));
          }
          if (state is ProductsLoaded) {
            if (state.products.isEmpty) {
              return const Center(
                child: Text("Mahsulotlar mavjud emas. Qo'shing."),
              );
            }
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${product.price} so'm | Qoldiq: ${product.quantity}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.history, color: Colors.grey),
                          tooltip: 'Harakatlar tarixi',
                          onPressed:
                              () => context.go(
                                '/inventory/history',
                                extra: product,
                              ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed:
                              () =>
                                  context.go('/products/edit', extra: product),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // O'chirishni tasdiqlash dialogini ko'rsatish
                            showDialog(
                              context: context,
                              builder:
                                  (ctx) => AlertDialog(
                                    title: const Text('Tasdiqlash'),
                                    content: Text(
                                      'Haqiqatan ham "${product.name}" mahsulotini o‘chirmoqchimisiz?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(ctx).pop(),
                                        child: const Text('Bekor qilish'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<ProductsCubit>()
                                              .deleteProduct(product.id);
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text(
                                          'O‘chirish',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
