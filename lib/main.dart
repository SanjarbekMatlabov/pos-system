import 'package:flutter/material.dart';
import 'package:salom_pos/features/1_auth/auth_repository.dart';
import 'app/config/app_routes.dart';

void main() async {
  // main funksiyasini async qilishimiz kerak
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ilovani ishga tushurishdan oldin bazaga foydalanuvchilarni qo'shamiz
  // Bu faqat birinchi marta, baza bo'sh bo'lganda ishlaydi
  await AuthRepository().addInitialUsers();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart POS',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      // theme: AppTheme.lightTheme, // Mavzuni keyinroq qo'shamiz
    );
  }
}