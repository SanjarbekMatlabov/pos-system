import '../../app/data/database_helper.dart';

class InventoryRepository {
  final dbHelper = DatabaseHelper.instance;

  // Omboga mahsulot kirim qilish funksiyasi
  Future<void> addStockEntry({
    required String productId,
    required double quantity,
    required String reason,
  }) async {
    final db = await dbHelper.database;

    // Tranzaksiya ichida ishlaymiz
    await db.transaction((txn) async {
      // 1. Mahsulot qoldig'ini 'products' jadvalida oshiramiz
      await txn.rawUpdate(
        'UPDATE products SET quantity = quantity + ? WHERE id = ?',
        [quantity, productId],
      );

      // 2. Ombor harakatini 'stock_entries' jadvaliga yozamiz
      await txn.insert('stock_entries', {
        'product_id': productId,
        'quantity': quantity, // Kirim uchun musbat
        'type': 'IN', // Kirim turi
        'reason': reason,
        'date': DateTime.now().toIso8601String(),
      });
    });
  }

  Future<List<Map<String, dynamic>>> getStockHistoryForProduct(
    String productId,
  ) async {
    final db = await dbHelper.database;
    // Sanasi bo'yicha kamayish tartibida olamiz (eng yangilari birinchi)
    return await db.query(
      'stock_entries',
      where: 'product_id = ?',
      whereArgs: [productId],
      orderBy: 'date DESC',
    );
  }
}
