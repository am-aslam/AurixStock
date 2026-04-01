import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../screens/shell_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/stock_screen.dart';
import '../../screens/add_edit_stock_screen.dart';
import '../../screens/vendor_screen.dart';
import '../../screens/add_edit_vendor_screen.dart';
import '../../screens/vendor_detail_screen.dart';
import '../../screens/transaction_screen.dart';
import '../../screens/add_transaction_screen.dart';
import '../../screens/analytics_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/export_screen.dart';
import '../../screens/app_lock_screen.dart';
import '../../screens/splash_screen.dart';
import '../../models/stock_entry.dart';
import '../../models/vendor.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (ctx, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/lock',
        builder: (ctx, state) => const AppLockScreen(),
      ),
      ShellRoute(
        builder: (ctx, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (ctx, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/stock',
            builder: (ctx, state) => const StockScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (ctx, state) => const AddEditStockScreen(),
              ),
              GoRoute(
                path: 'edit',
                builder: (ctx, state) {
                  final entry = state.extra as StockEntry?;
                  return AddEditStockScreen(entry: entry);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/vendors',
            builder: (ctx, state) => const VendorScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (ctx, state) => const AddEditVendorScreen(),
              ),
              GoRoute(
                path: 'edit',
                builder: (ctx, state) {
                  final vendor = state.extra as Vendor?;
                  return AddEditVendorScreen(vendor: vendor);
                },
              ),
              GoRoute(
                path: 'detail',
                builder: (ctx, state) {
                  final vendor = state.extra as Vendor;
                  return VendorDetailScreen(vendor: vendor);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/transactions',
            builder: (ctx, state) => const TransactionScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (ctx, state) => const AddTransactionScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/analytics',
            builder: (ctx, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (ctx, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'export',
                builder: (ctx, state) => const ExportScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
