import 'package:flutter/material.dart';
import 'package:salom_pos/app/config/app_routes.dart';
import 'package:salom_pos/app/config/app_theme.dart'; // Dizayn temasini import qilamiz

void main() {
  // POS Terminal ilovasini ishga tushiramiz
  runApp(const PosApp());
}

class PosApp extends StatelessWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart POS Terminal',
      theme: AppTheme.lightTheme, // Belgilangan dizayn temasini qo'llaymiz
      debugShowCheckedModeBanner: false, // O'ng yuqoridagi "Debug" yozuvini olib tashlaydi
      routerConfig: router, // Ilovaning boshlang'ich ekrani
    );
  }
}

// Vaqtinchalik boshlang'ich ekran (keyinchalik o'zgaradi)
class PosHomeScreen extends StatelessWidget {
  const PosHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POS Terminal'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'POS Terminal Asosiy Ekrani',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}