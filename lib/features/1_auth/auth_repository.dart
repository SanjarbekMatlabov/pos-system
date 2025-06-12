import 'package:sqflite/sqflite.dart';
import '../../app/data/database_helper.dart';
import 'user_model.dart';

class AuthRepository {
  final dbHelper = DatabaseHelper.instance;

  // Foydalanuvchini login va parol bo'yicha tekshirish
  Future<User?> login(String username, String password) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password_hash = ?',
      whereArgs: [username, password], // Haqiqiy loyihada bu yerda hash solishtiriladi
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Ilova birinchi ishga tushganda boshlang'ich foydalanuvchilarni qo'shish
  Future<void> addInitialUsers() async {
    final db = await dbHelper.database;
    // Admin foydalanuvchisi
    await db.insert(
      'users',
      User(username: 'admin', passwordHash: 'admin123', role: 'admin').toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore, // Agar mavjud bo'lsa, xatolik bermaydi
    );
    // Kassir foydalanuvchisi
    await db.insert(
      'users',
      User(username: 'kassir', passwordHash: '12345', role: 'kassir').toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
  Future<List<User>> getAllUsers() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  // Yangi foydalanuvchi qo'shish
  Future<void> addUser(User user) async {
    final db = await dbHelper.database;
    await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail); // Takrorlanmasligi uchun
  }

  // Foydalanuvchi ma'lumotlarini yangilash
  Future<void> updateUser(User user) async {
    final db = await dbHelper.database;
    await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  // Foydalanuvchini o'chirish
  Future<void> deleteUser(int id) async {
    final db = await dbHelper.database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}