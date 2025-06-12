import '../../app/data/database_helper.dart';
import '../3_products/product_model.dart';

class PosRepository {
  final dbHelper = DatabaseHelper.instance;

  // Shtrix-kod bo'yicha mahsulotni bazadan topish
  Future<Product?> findProductByBarcode(String barcode) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'barcode = ?',
      whereArgs: [barcode],
    );
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  // Sotuvni amalga oshirish (eng muhim funksiya)
  Future<void> createSale(List<Product> cartProducts, double totalAmount, String paymentType) async {
    final db = await dbHelper.database;

    // Tranzaksiya: barcha amallar yoki birga bajariladi, yoki hech biri bajarilmaydi
    await db.transaction((txn) async {
      // 1. Yangi sotuvni 'sales' jadvaliga yozamiz
      final saleId = await txn.insert('sales', {
        'date': DateTime.now().toIso8601String(),
        'total_amount': totalAmount,
        'payment_type': paymentType,
      });

      // 2. Savatdagi har bir mahsulotni 'sale_items' ga yozamiz va ombordan kamaytiramiz
      for (var product in cartProducts) {
        // Sotuv qismlarini yozish
        await txn.insert('sale_items', {
          'sale_id': saleId,
          'product_id': product.id,
          'quantity': 1, // Hozircha har bir skanerlashni 1 dona deb hisoblaymiz
          'unit_price': product.price,
        });

        // Mahsulot qoldig'ini kamaytirish
        await txn.rawUpdate(
          'UPDATE products SET quantity = quantity - 1 WHERE id = ?',
          [product.id],
        );
        
        // Ombor harakati (chiqim)ni yozish
        await txn.insert('stock_entries', {
            'product_id': product.id,
            'quantity': -1, // Chiqim uchun manfiy
            'type': 'OUT',
            'reason': 'Sotuv #${saleId}',
            'date': DateTime.now().toIso8601String(),
        });
      }
    });
  }
}