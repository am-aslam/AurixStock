import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) context.go('/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AurixColors.bgPrimary,
      body: Container(
        decoration: const BoxDecoration(gradient: AurixColors.heroGradient),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 110, height: 110,
              decoration: BoxDecoration(
                gradient: AurixColors.goldGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: AurixColors.goldPrimary.withOpacity(0.5), blurRadius: 40, offset: const Offset(0,12))],
              ),
              child: const Icon(Icons.diamond_rounded, color: AurixColors.textOnGold, size: 54),
            ).animate().scale(begin: const Offset(0.4,0.4), end: const Offset(1,1), duration: 700.ms, curve: Curves.elasticOut).fadeIn(duration: 400.ms),
            const SizedBox(height: 32),
            Text('AurixStock', style: AurixTypography.display1(AurixColors.textPrimary))
                .animate(delay: 300.ms).fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0),
            const SizedBox(height: 8),
            Text('Premium Gold Stock Manager', style: AurixTypography.body1(AurixColors.textMuted))
                .animate(delay: 500.ms).fadeIn(duration: 500.ms),
            const SizedBox(height: 80),
            SizedBox(width: 140,
              child: ClipRRect(borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  backgroundColor: AurixColors.bgCard,
                  valueColor: AlwaysStoppedAnimation(AurixColors.goldPrimary),
                  minHeight: 3))).animate(delay: 700.ms).fadeIn(duration: 400.ms),
          ]),
        ),
      ),
    );
  }
}
