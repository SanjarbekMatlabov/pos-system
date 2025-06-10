import 'package:salom_pos/features/3_products/product_model.dart';

// Bu sinf mahsulotlar ma'lumotlar bazasi (yoki server) bilan aloqa uchun mas'ul.
class ProductsRepository {
  // Haqiqiy bazani imitatsiya qiluvchi soxta ma'lumotlar ro'yxati
  final List<Product> _products = [
    const Product(id: '1', name: 'Coca-Cola 1.5L', price: 12000, barcode: '86001'),
    const Product(id: '2', name: 'Fanta 1.5L', price: 12000, barcode: '86002'),
    const Product(id: '3', name: 'Non (buxanka)', price: 2800, barcode: '86003'),
    const Product(id: '4', name: 'Nestle Suv 1L', price: 3000, barcode: '86004'),
    const Product(id: '5', name: 'Oltin Don Un 2kg', price: 18000, barcode: '86005'),
    const Product(id: '6', name: 'Moy 1L', price: 22000, barcode: '86006'),
  ];

  // Barcha mahsulotlarni olib keluvchi funksiya
  Future<List<Product>> getProducts() async {
    // Serverdan javob kelishini kutishni imitatsiya qilamiz
    await Future.delayed(const Duration(milliseconds: 800));
    return _products;
  }
  
  // Bu yerga kelajakda addProduct, updateProduct, deleteProduct funksiyalari qo'shiladi.
}