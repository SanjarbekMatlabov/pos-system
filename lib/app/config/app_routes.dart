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
import 'package:salom_pos/features/inventory/stock_history_screen.dart';
import 'package:salom_pos/features/inventory/stock_in_screen.dart';
import 'package:salom_pos/features/sales/sale_detail_screen.dart';
import 'package:salom_pos/features/sales/sales_history_screen.dart';

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
      path: '/pos_terminal',
      builder: (context, state) => const PosScreen(),
    ),
    GoRoute(
      path: '/reports',
      builder: (context, state) => const ReportsDashboardScreen(),
    ),
    GoRoute(
      path: '/inventory_stock_in',
      builder: (context, state) => const StockInScreen(),
    ),
    GoRoute(
      path: '/inventory/history',
      builder: (context, state) {
        // Ro'yxatdan Product obyekti keladi
        final product = state.extra as Product;
        return StockHistoryScreen(product: product);
      },
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => BlocProvider(
        create: (context) => ProductsCubit(ProductsRepository())..fetchProducts(),
        child: const ProductListScreen(),
      ),
      routes: [
        GoRoute(
          path: 'add', // /products/add
          builder: (context, state) => const ProductEditScreen(),
        ),
        GoRoute(
          path: 'edit', // /products/edit
          builder: (context, state) {
            final product = state.extra as Product;
            return ProductEditScreen(product: product);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/sales',
      builder: (context, state) => const SalesHistoryScreen(),
      routes: [
        GoRoute(
          path: 'detail', // /sales/detail
          builder: (context, state) {
            final sale = state.extra as Map<String, dynamic>;
            return SaleDetailScreen(sale: sale);
          },
        ),
      ]
    ),
  ],
);