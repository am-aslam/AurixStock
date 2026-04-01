import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class ShellScreen extends StatelessWidget {
  final Widget child;
  const ShellScreen({super.key, required this.child});

  static const _tabs = [
    (icon: Icons.dashboard_rounded,     label: 'Dashboard',    path: '/dashboard'),
    (icon: Icons.inventory_2_rounded,   label: 'Stock',        path: '/stock'),
    (icon: Icons.people_rounded,        label: 'Vendors',      path: '/vendors'),
    (icon: Icons.swap_horiz_rounded,    label: 'Ledger',       path: '/transactions'),
    (icon: Icons.bar_chart_rounded,     label: 'Analytics',    path: '/analytics'),
  ];

  int _index(BuildContext ctx) {
    final loc = GoRouterState.of(ctx).uri.toString();
    for (int i = 0; i < _tabs.length; i++) {
      if (loc.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _index(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AurixColors.bgSecondary,
          border: const Border(top: BorderSide(color: AurixColors.borderDivider, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: idx,
          onDestinationSelected: (i) => context.go(_tabs[i].path),
          destinations: _tabs.map((t) => NavigationDestination(
            icon: Icon(t.icon),
            label: t.label,
          )).toList(),
        ),
      ),
    );
  }
}
