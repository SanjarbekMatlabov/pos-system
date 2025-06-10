import 'package:salom_pos/features/3_products/product_model.dart';
import 'package:uuid/uuid.dart';

class ProductsRepository {
  final List<Product> _products = [
    // ... avvalgi ro'yxat
    const Product(id: '1', name: 'Coca-Cola 1.5L', price: 12000, barcode: '86001'),
    const Product(id: '2', name: 'Fanta 1.5L', price: 12000, barcode: '86002'),
    const Product(id: '3', name: 'Non (buxanka)', price: 2800, barcode: '86003'),
    const Product(id: '4', name: 'Nestle Suv 1L', price: 3000, barcode: '86004'),
    const Product(id: '5', name: 'Oltin Don Un 2kg', price: 18000, barcode: '86005'),
    const Product(id: '6', name: 'Moy 1L', price: 22000, barcode: '86006'),
  ];
  final _uuid = const Uuid();

  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _products;
  }

  // YANGI FUNKSIYA: Mahsulot qo'shish
  Future<void> addProduct({required String name, required double price, required String barcode}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newProduct = Product(
      id: _uuid.v4(), // Yangi unikal ID yaratish
      name: name,
      price: price,
      barcode: barcode,
    );
    _products.add(newProduct);
  }

  // YANGI FUNKSIYA: Mahsulotni yangilash
  Future<void> updateProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }
}