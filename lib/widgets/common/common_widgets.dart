import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? borderColor;
  final VoidCallback? onTap;
  final Gradient? gradient;

  const GlassCard({super.key, required this.child, this.padding, this.margin,
    this.borderRadius = 20, this.borderColor, this.onTap, this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? AurixColors.bgCard : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor ?? AurixColors.borderDivider, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 16, offset: const Offset(0,6))],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AurixColors.goldPrimary.withOpacity(0.08),
          child: Padding(padding: padding ?? const EdgeInsets.all(18), child: child),
        ),
      ),
    );
  }
}

class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;

  const GoldButton({super.key, required this.label, this.onTap, this.icon,
    this.isLoading = false, this.width, this.height = 52});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onTap == null
              ? const LinearGradient(colors: [Color(0xFF6C5A2A), Color(0xFF4A3E1C)])
              : AurixColors.goldGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: onTap == null ? [] : [BoxShadow(color: AurixColors.goldPrimary.withOpacity(0.35), blurRadius: 16, offset: const Offset(0,6))],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Center(child: isLoading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: AurixColors.textOnGold, strokeWidth: 2.5))
                : Row(mainAxisSize: MainAxisSize.min, children: [
                    if (icon != null) ...[Icon(icon, color: AurixColors.textOnGold, size: 18), const SizedBox(width: 8)],
                    Text(label, style: AurixTypography.button(AurixColors.textOnGold)),
                  ])),
          ),
        ),
      ),
    );
  }
}

class GoldOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final double? width;
  final double height;

  const GoldOutlinedButton({super.key, required this.label, this.onTap, this.icon,
    this.width, this.height = 52});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AurixColors.goldPrimary, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            splashColor: AurixColors.goldPrimary.withOpacity(0.1),
            child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (icon != null) ...[Icon(icon, color: AurixColors.goldPrimary, size: 18), const SizedBox(width: 8)],
              Text(label, style: AurixTypography.button(AurixColors.goldPrimary)),
            ])),
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color iconColor, iconBg;
  final int animIndex;

  const StatCard({super.key, required this.label, required this.value,
    required this.icon, required this.iconColor, required this.iconBg, this.animIndex = 0});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 40, height: 40,
          decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: iconColor, size: 20)),
        const SizedBox(height: 12),
        Text(value, style: AurixTypography.headline2(AurixColors.textPrimary)),
        const SizedBox(height: 4),
        Text(label, style: AurixTypography.caption(AurixColors.textMuted)),
      ]),
    ).animate(delay: Duration(milliseconds: 100 * animIndex))
        .fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0, duration: 400.ms);
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: AurixTypography.headline3(AurixColors.textPrimary)),
      if (action != null)
        GestureDetector(onTap: onAction,
          child: Text(action!, style: AurixTypography.label(AurixColors.goldPrimary))),
    ]);
  }
}

class AurixSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  const AurixSearchBar({super.key, required this.hint, required this.onChanged, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AurixColors.bgElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AurixColors.borderDivider),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AurixTypography.body1(AurixColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AurixTypography.body1(AurixColors.textMuted),
          prefixIcon: const Icon(Icons.search_rounded, color: AurixColors.textMuted),
          border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({super.key, required this.icon, required this.title,
    required this.subtitle, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(padding: const EdgeInsets.all(40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 90, height: 90,
            decoration: BoxDecoration(color: AurixColors.goldPrimary.withOpacity(0.08), shape: BoxShape.circle),
            child: Icon(icon, color: AurixColors.goldPrimary.withOpacity(0.6), size: 40)),
          const SizedBox(height: 24),
          Text(title, style: AurixTypography.headline2(AurixColors.textPrimary), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(subtitle, style: AurixTypography.body2(AurixColors.textMuted), textAlign: TextAlign.center),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 28),
            GoldButton(label: actionLabel!, onTap: onAction, width: 180, height: 46),
          ],
        ]),
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1,1));
  }
}

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color, bgColor;
  const StatusBadge({super.key, required this.label, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: AurixTypography.caption(color).copyWith(fontWeight: FontWeight.w600)),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final double height;
  const ShimmerCard({super.key, this.height = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height, margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: AurixColors.bgCard, borderRadius: BorderRadius.circular(16)),
    ).animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 1200.ms, color: AurixColors.goldPrimary.withOpacity(0.08));
  }
}

class GoldDivider extends StatelessWidget {
  const GoldDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [
        Colors.transparent, AurixColors.goldPrimary.withOpacity(0.3), Colors.transparent])));
  }
}

Future<bool?> showDeleteDialog(BuildContext context, String itemName) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AurixColors.bgElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(children: [
        Container(width: 40, height: 40,
          decoration: BoxDecoration(color: AurixColors.errorBg, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.delete_outline_rounded, color: AurixColors.error)),
        const SizedBox(width: 14),
        Text('Delete', style: AurixTypography.headline2(AurixColors.textPrimary)),
      ]),
      content: Text('Are you sure you want to delete "$itemName"? This cannot be undone.',
          style: AurixTypography.body1(AurixColors.textSecondary)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false),
          child: Text('Cancel', style: AurixTypography.button(AurixColors.textMuted))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AurixColors.error, foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete')),
        const SizedBox(width: 4),
      ],
    ),
  );
}

void showSuccessSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(children: [
      const Icon(Icons.check_circle_rounded, color: AurixColors.success, size: 20),
      const SizedBox(width: 10),
      Text(msg, style: AurixTypography.body2(AurixColors.textPrimary)),
    ]),
    duration: const Duration(seconds: 2),
  ));
}

void showErrorSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(children: [
      const Icon(Icons.error_outline_rounded, color: AurixColors.error, size: 20),
      const SizedBox(width: 10),
      Expanded(child: Text(msg, style: AurixTypography.body2(AurixColors.textPrimary))),
    ]),
    duration: const Duration(seconds: 3),
  ));
}
