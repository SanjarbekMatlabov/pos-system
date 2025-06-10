import 'package:go_router/go_router.dart';
import 'package:salom_pos/features/1_auth/login_screen.dart';
import 'package:salom_pos/features/2_pos_terminal/pos_screen.dart';
import 'package:salom_pos/features/4_reports/reports_dashboard_screen.dart';

// Markazlashgan router obyekti
final router = GoRouter(
  // Ilova birinchi ochilganda qaysi sahifaga o'tish kerakligi
  initialLocation: '/login',

  // Ilovadagi barcha yo'nalishlar (marshrutlar) ro'yxati
  routes: [
    // Kirish ekrani uchun yo'nalish
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),

    // POS Terminal asosiy ekrani uchun yo'nalish

    // Admin Panel asosiy ekrani uchun yo'nalish
    GoRoute(
      path: '/admin_home',
      name: 'admin_home',
      builder: (context, state) => const ReportsDashboardScreen(),
    ),
    GoRoute(
      path: '/pos_home',
      name: 'pos_home',
      // Vaqtinchalik PosHomeScreen o'rniga haqiqiy PosScreen'ni chaqiramiz
      builder: (context, state) => const PosScreen(),
    ),
  ],
);
