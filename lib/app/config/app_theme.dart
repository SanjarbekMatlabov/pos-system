import 'package:flutter/material.dart';

// Bu fayl butun ilovaning dizayn tizimini o'zida jamlaydi.
// Ranglar, shriftlar, tugma va boshqa elementlarning uslublari shu yerda belgilanadi.

class AppTheme {
  AppTheme._(); // Bu klassdan obyekt olishni taqiqlaydi.

  // --- RANGlAR ---
  static const Color primaryColor = Color(0xFF0D47A1); // To'q ko'k
  static const Color accentColor = Color(0xFF2E7D32);  // Yashil
  static const Color errorColor = Color(0xFFD32F2F);   // Qizil
  static const Color lightBackgroundColor = Color(0xFFF5F5F5); // Och kulrang fon
  static const Color surfaceColor = Colors.white; // Oq kartochkalar

  /// Ilovaning OCH REJIM uchun bo'lgan mavzusi (ThemeData)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter', // Butun ilova uchun standart shrift
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackgroundColor,

      // Ranglar sxemasi
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
        background: lightBackgroundColor,
        surface: surfaceColor,
      ),

      // Matnlar uslubi
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
        headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // Tugmalar uchun
      ),
      
      // Tugmalar uslubi
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Kiritish maydonlari uslubi
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.grey, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: primaryColor, width: 2.0),
        ),
      ),
      
      // Kartochkalar uslubi
      cardTheme: CardTheme(
        elevation: 2,
        color: surfaceColor,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}