import '../../app/data/database_helper.dart';

class ReportsRepository {
  final dbHelper = DatabaseHelper.instance;

  // Bugungi umumiy savdo summasini olish
  Future<double> getTodaySalesTotal() async {
    final db = await dbHelper.database;
    // 'localtime' - qurilmaning mahalliy vaqtini hisobga oladi
    final result = await db.rawQuery('''
      SELECT SUM(total_amount) as total 
      FROM sales 
      WHERE DATE(date) = DATE('now', 'localtime')
    ''');
    return (result.first['total'] as double?) ?? 0.0;
  }

  // Bugungi cheklar sonini olish
  Future<int> getTodayCheckCount() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('''
      SELECT COUNT(id) as count 
      FROM sales 
      WHERE DATE(date) = DATE('now', 'localtime')
    ''');
    return (result.first['count'] as int?) ?? 0;
  }

  // Oxirgi 7 kunlik savdo ma'lumotlarini olish (grafik uchun)
  Future<List<Map<String, dynamic>>> getWeeklySales() async {
    final db = await dbHelper.database;
    // Oxirgi 6 kun va bugun - jami 7 kun
    return await db.rawQuery('''
      SELECT 
        strftime('%Y-%m-%d', date) as sale_day, 
        SUM(total_amount) as daily_total 
      FROM sales 
      WHERE date >= DATE('now', '-6 days', 'localtime') 
      GROUP BY sale_day 
      ORDER BY sale_day ASC
    ''');
  }

  // Eng ko'p sotilgan mahsulotlarni olish
  Future<List<Map<String, dynamic>>> getTopSellingProducts({
    int limit = 5,
  }) async {
    final db = await dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT 
        p.name, 
        SUM(si.quantity) as total_sold 
      FROM sale_items si
      JOIN products p ON si.product_id = p.id 
      GROUP BY p.name 
      ORDER BY total_sold DESC 
      LIMIT ?
    ''',
      [limit],
    );
  }

  Future<List<Map<String, dynamic>>> getLowStockProducts({
    int limit = 5,
    double threshold = 10,
  }) async {
    final db = await dbHelper.database;
    return await db.rawQuery(
      '''
    SELECT name, quantity 
    FROM products 
    WHERE quantity < ? AND quantity > 0
    ORDER BY quantity ASC
    LIMIT ?
  ''',
      [threshold, limit],
    );
  }
}
