import 'package:flutter/material.dart';
import 'package:salom_pos/app/config/app_theme.dart'; // Dizayn temasini import qilamiz
import 'package:salom_pos/app/config/app_routes.dart';
void main() {
  // Admin Panel ilovasini ishga tushiramiz
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart POS Admin',
      theme: AppTheme.lightTheme, // Xuddi o'sha dizayn temasini bu yerda ham qo'llaymiz
      debugShowCheckedModeBanner: false,
      routerConfig: router, // Ilovaning boshlang'ich ekrani
    );
  }
}

// Vaqtinchalik boshlang'ich ekran (keyinchalik o'zgaradi)
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Admin Panel Asosiy Ekrani',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}