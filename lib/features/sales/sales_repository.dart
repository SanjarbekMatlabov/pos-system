import '../../app/data/database_helper.dart';

class SalesRepository {
  final dbHelper = DatabaseHelper.instance;

  // Barcha sotuvlar (cheklar) ro'yxatini olish
  Future<List<Map<String, dynamic>>> getAllSales() async {
    final db = await dbHelper.database;
    return await db.query('sales', orderBy: 'date DESC');
  }

  // Bitta sotuvning tarkibini (mahsulotlarini) olish
  Future<List<Map<String, dynamic>>> getSaleItems(int saleId) async {
    final db = await dbHelper.database;
    // Jadvallarni JOIN qilib, mahsulot nomini ham olamiz
    return await db.rawQuery('''
      SELECT si.*, p.name as product_name 
      FROM sale_items si
      JOIN products p ON si.product_id = p.id
      WHERE si.sale_id = ?
    ''', [saleId]);
  }
}