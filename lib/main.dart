import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'theme.dart';
import 'core/router/app_router.dart';
import 'services/hive_service.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF12141C),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  await HiveService.initialize();

  runApp(const ProviderScope(child: AurixStockApp()));
}

class AurixStockApp extends ConsumerWidget {
  const AurixStockApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'AurixStock',
      debugShowCheckedModeBanner: false,
      theme: AurixTheme.dark,
      darkTheme: AurixTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
