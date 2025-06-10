import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Bu fayl `flutter pub run build_runner build` buyrug'i bilan generatsiya qilinadi
part 'local_database.g.dart';

// --- JADVALLARNI E'LON QILISH ---

// 1. Foydalanuvchilar jadvali
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().unique()();
  TextColumn get password => text()();
  TextColumn get role => text()(); // 'admin' yoki 'pos'
}

// 2. Mahsulotlar jadvali
class Products extends Table {
  TextColumn get id => text()(); // uuid ishlatganimiz uchun Text
  TextColumn get name => text()();
  RealColumn get price => real()(); // RealColumn o'nlik sonlar uchun
  TextColumn get barcode => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}


// --- MA'LUMOTLAR BAZASI KLASSI ---

@DriftDatabase(tables: [Users, Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // --- FOYDALANUVCHILAR UCHUN SO'ROVLAR ---
  Future<User?> getUser(String username, String password) {
    return (select(users)
          ..where((u) => u.username.equals(username))
          ..where((u) => u.password.equals(password)))
        .getSingleOrNull();
  }
  
  // --- MAHSULOTLAR UCHUN SO'ROVLAR ---
  Stream<List<Product>> watchAllProducts() => select(products).watch();
  Future<void> insertProduct(Product product) => into(products).insert(product);
  Future<void> updateProduct(Product product) => update(products).replace(product);
  Future<Product?> findProductByBarcode(String barcode) {
    return (select(products)..where((p) => p.barcode.equals(barcode))).getSingleOrNull();
  }
}

// Ma'lumotlar bazasi faylini ochish uchun yordamchi funksiya
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}