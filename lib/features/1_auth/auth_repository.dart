// Bu sinfning vazifasi avtorizatsiya bilan bog'liq ma'lumotlar operatsiyalarini bajarish.
// Masalan, serverga login va parol yuborib, javobini olish.
class AuthRepository {

  // Foydalanuvchi ma'lumotlarini tekshiruvchi funksiya.
  // Kelajakda bu yerda serverga haqiqiy so'rov ketadi.
  Future<String> login({
    required String username,
    required String password,
  }) async {
    // Server javobini kutishni imitatsiya qilamiz (1.5 soniya)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (username.toLowerCase() == 'kassir' && password == '12345') {
      // Agar kassir bo'lsa, uning rolini qaytaramiz
      return 'pos_home'; 
    } else if (username.toLowerCase() == 'admin' && password == 'admin123') {
      // Agar admin bo'lsa, uning rolini qaytaramiz
      return 'admin_home';
    } else {
      // Agar ma'lumotlar noto'g'ri bo'lsa, xatolik qaytaramiz
      throw 'Login yoki parol xato!';
    }
  }
}