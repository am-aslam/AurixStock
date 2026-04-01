import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../theme.dart';
import '../providers/providers.dart';
import '../widgets/common/common_widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: AurixColors.bgPrimary,
      body: SafeArea(child: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Text('Settings', style: AurixTypography.display2(AurixColors.textPrimary)))),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          sliver: SliverList(delegate: SliverChildListDelegate([

            // ── Shop Info ─────────────────────────────────────
            _Section(title: 'Shop', children: [
              _SettingTile(
                icon: Icons.store_rounded,
                title: 'Shop Name',
                subtitle: settings.shopName,
                onTap: () => _editShopName(context, settings.shopName, notifier)),
              _SettingTile(
                icon: Icons.currency_rupee_rounded,
                title: 'Currency Symbol',
                subtitle: settings.currency,
                onTap: () => _pickCurrency(context, settings.currency, notifier)),
            ]).animate(delay: 100.ms).fadeIn(duration: 300.ms),

            const SizedBox(height: 16),

            // ── Security ──────────────────────────────────────
            _Section(title: 'Security', children: [
              _ToggleTile(
                icon: Icons.lock_rounded,
                title: 'PIN Lock',
                subtitle: 'Protect app with a PIN',
                value: settings.pinEnabled,
                onChanged: (v) => notifier.setPinEnabled(v)),
              _ToggleTile(
                icon: Icons.fingerprint_rounded,
                title: 'Biometric Lock',
                subtitle: 'Use fingerprint / Face ID',
                value: settings.biometricEnabled,
                onChanged: (v) => notifier.setBiometric(v)),
            ]).animate(delay: 200.ms).fadeIn(duration: 300.ms),

            const SizedBox(height: 16),

            // ── Export ────────────────────────────────────────
            _Section(title: 'Data & Export', children: [
              _SettingTile(
                icon: Icons.upload_file_rounded,
                title: 'Export Data',
                subtitle: 'Export stock, vendors, transactions',
                onTap: () => context.go('/settings/export')),
              _SettingTile(
                icon: Icons.backup_rounded,
                title: 'Backup & Restore',
                subtitle: 'Coming soon',
                onTap: () => showSuccessSnack(context, 'Backup feature coming soon!')),
            ]).animate(delay: 300.ms).fadeIn(duration: 300.ms),

            const SizedBox(height: 16),

            // ── About ─────────────────────────────────────────
            _Section(title: 'About', children: [
              _SettingTile(
                icon: Icons.diamond_rounded,
                title: 'AurixStock',
                subtitle: 'v2.0.0 — Premium Gold Stock Manager',
                onTap: () => _showAbout(context)),
              _SettingTile(
                icon: Icons.info_outline_rounded,
                title: 'Licenses',
                subtitle: 'Open source licenses',
                onTap: () => showLicensePage(context: context, applicationName: 'AurixStock')),
            ]).animate(delay: 400.ms).fadeIn(duration: 300.ms),

          ])),
        ),
      ])),
    );
  }

  void _editShopName(BuildContext ctx, String current, SettingsNotifier notifier) {
    final ctrl = TextEditingController(text: current);
    showDialog(context: ctx, builder: (_) => AlertDialog(
      backgroundColor: AurixColors.bgElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Shop Name', style: AurixTypography.headline2(AurixColors.textPrimary)),
      content: TextFormField(controller: ctrl,
        style: AurixTypography.body1(AurixColors.textPrimary),
        decoration: const InputDecoration(hintText: 'Enter shop name')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx),
          child: Text('Cancel', style: AurixTypography.button(AurixColors.textMuted))),
        ElevatedButton(onPressed: () {
          notifier.setShopName(ctrl.text.trim());
          Navigator.pop(ctx);
        }, child: const Text('Save')),
      ],
    ));
  }

  void _pickCurrency(BuildContext ctx, String current, SettingsNotifier notifier) {
    final options = ['₹', '\$', '€', '£', '¥', '₪', 'AED'];
    showModalBottomSheet(context: ctx, builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Currency', style: AurixTypography.headline2(AurixColors.textPrimary)),
        const GoldDivider(),
        ...options.map((c) => ListTile(
          title: Text(c, style: AurixTypography.body1(AurixColors.textPrimary)),
          trailing: c == current ? const Icon(Icons.check_rounded, color: AurixColors.goldPrimary) : null,
          onTap: () { notifier.setCurrency(c); Navigator.pop(ctx); })),
      ])));
  }

  void _showAbout(BuildContext ctx) {
    showDialog(context: ctx, builder: (_) => AlertDialog(
      backgroundColor: AurixColors.bgElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 72, height: 72,
          decoration: BoxDecoration(gradient: AurixColors.goldGradient, borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.diamond_rounded, color: AurixColors.textOnGold, size: 36)),
        const SizedBox(height: 16),
        Text('AurixStock', style: AurixTypography.headline1(AurixColors.textPrimary)),
        Text('v2.0.0', style: AurixTypography.body2(AurixColors.textMuted)),
        const SizedBox(height: 12),
        Text('Premium Gold Stock Manager\nBuilt with Flutter & ❤️',
          style: AurixTypography.body2(AurixColors.textSecondary), textAlign: TextAlign.center),
      ]),
      actions: [
        ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
    ));
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(left: 4, bottom: 10),
        child: Text(title, style: AurixTypography.label(AurixColors.goldPrimary))),
      GlassCard(padding: const EdgeInsets.all(0), child: Column(
        children: children.asMap().entries.map((e) => Column(children: [
          e.value,
          if (e.key < children.length - 1) const Divider(color: AurixColors.borderDivider, height: 1, indent: 56),
        ])).toList())),
    ]);
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback? onTap;
  const _SettingTile({required this.icon, required this.title, required this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: Container(width: 38, height: 38,
        decoration: BoxDecoration(color: AurixColors.goldPrimary.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AurixColors.goldPrimary, size: 18)),
      title: Text(title, style: AurixTypography.headline3(AurixColors.textPrimary)),
      subtitle: Text(subtitle, style: AurixTypography.caption(AurixColors.textMuted)),
      trailing: onTap != null ? const Icon(Icons.chevron_right_rounded, color: AurixColors.textMuted, size: 20) : null,
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleTile({required this.icon, required this.title, required this.subtitle,
    required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: Container(width: 38, height: 38,
        decoration: BoxDecoration(color: AurixColors.goldPrimary.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AurixColors.goldPrimary, size: 18)),
      title: Text(title, style: AurixTypography.headline3(AurixColors.textPrimary)),
      subtitle: Text(subtitle, style: AurixTypography.caption(AurixColors.textMuted)),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}
