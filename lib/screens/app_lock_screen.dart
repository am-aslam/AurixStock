import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../providers/providers.dart';

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});
  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  String _entered = '';
  bool _error = false;

  void _tap(String d) {
    if (_entered.length >= 4) return;
    setState(() { _entered += d; _error = false; });
    if (_entered.length == 4) _verify();
  }

  void _backspace() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  void _verify() {
    final stored = ref.read(settingsProvider).toString();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) context.go('/dashboard');
    });
  }

  Widget _dot(bool filled) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    width: 14, height: 14,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: filled ? AurixColors.goldPrimary : Colors.transparent,
      border: Border.all(color: _error ? AurixColors.error : AurixColors.goldPrimary, width: 2),
    ),
  );

  Widget _key(String label, {String? sub, VoidCallback? onTap, Widget? child}) {
    return GestureDetector(
      onTap: onTap ?? (label.isNotEmpty ? () => _tap(label) : null),
      child: Container(
        width: 72, height: 72,
        decoration: BoxDecoration(shape: BoxShape.circle,
          color: AurixColors.bgElevated,
          border: Border.all(color: AurixColors.borderDivider)),
        child: child ?? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(label, style: AurixTypography.headline2(AurixColors.textPrimary)),
          if (sub != null) Text(sub, style: AurixTypography.caption(AurixColors.textMuted)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AurixColors.bgPrimary,
      body: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.lock_rounded, color: AurixColors.goldPrimary, size: 48),
        const SizedBox(height: 16),
        Text('Enter PIN', style: AurixTypography.headline1(AurixColors.textPrimary)),
        const SizedBox(height: 40),
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _dot(i < _entered.length)))),
        const SizedBox(height: 48),
        for (var row in [['1','2','3'],['4','5','6'],['7','8','9'],['','0','⌫']])
          Padding(padding: const EdgeInsets.only(bottom: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((k) => Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                child: k == '⌫'
                    ? _key('', onTap: _backspace, child: const Icon(Icons.backspace_outlined, color: AurixColors.textMuted))
                    : k.isEmpty ? const SizedBox(width: 72, height: 72) : _key(k))).toList())),
      ]))),
    );
  }
}
