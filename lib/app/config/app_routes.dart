import 'package:flutter_bloc/flutter_bloc.dart'; // BlocProvider uchun import
import 'package:go_router/go_router.dart';
import 'package:salom_pos/features/1_auth/login_screen.dart';
import 'package:salom_pos/features/2_pos_terminal/pos_screen.dart';
import 'package:salom_pos/features/3_products/product_edit_screen.dart';
import 'package:salom_pos/features/3_products/product_list_screen.dart';
import 'package:salom_pos/features/3_products/product_model.dart';
import 'package:salom_pos/features/3_products/products_cubit.dart';     // Cubit'ni import qilamiz
import 'package:salom_pos/features/3_products/products_repository.dart'; // Repository'ni import qilamiz
import 'package:salom_pos/features/4_reports/reports_dashboard_screen.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    // ... boshqa yo'nalishlar (login, pos_home, admin_home) ...
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/pos_home',
      name: 'pos_home',
      builder: (context, state) => const PosScreen(),
    ),
    GoRoute(
      path: '/admin_home',
      name: 'admin_home',
      builder: (context, state) => const ReportsDashboardScreen(),
    ),
    
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) {
        // Cubit'ni shu yerda, marshrutning o'zida yaratamiz
        return BlocProvider(
          create: (context) => ProductsCubit(ProductsRepository())..loadProducts(),
          child: const ProductListScreen(), // Endi ListScreen'ni chaqiramiz
        );
      },
      // Ichki yo'nalish (sub-route)
      routes: [
        GoRoute(
          path: 'edit', // To'liq path avtomatik /products/edit bo'ladi
          name: 'product_edit',
          builder: (context, state) {
            final product = state.extra as Product?;
            return ProductEditScreen(product: product);
          },
        ),
      ],
    ),
  ],
);