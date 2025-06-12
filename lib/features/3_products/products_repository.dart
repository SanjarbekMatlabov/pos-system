import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart'; // `flutter pub add uuid` buyrug'i bilan o'rnatib oling
import '../../app/data/database_helper.dart';
import 'product_model.dart';

class ProductsRepository {
  final dbHelper = DatabaseHelper.instance;
  final _uuid = const Uuid();

  // Barcha mahsulotlarni o'qish (Read)
  Future<List<Product>> getAllProducts() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Yangi mahsulot qo'shish (Create)
  Future<void> addProduct(Product product) async {
    final db = await dbHelper.database;
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Mahsulotni tahrirlash (Update)
  Future<void> updateProduct(Product product) async {
    final db = await dbHelper.database;
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Mahsulotni o'chirish (Delete)
  Future<void> deleteProduct(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}