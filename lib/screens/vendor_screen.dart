import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../providers/providers.dart';
import '../models/vendor.dart';
import '../core/utils/app_utils.dart';
import '../widgets/common/common_widgets.dart';

class VendorScreen extends ConsumerWidget {
  const VendorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendors  = ref.watch(filteredVendorProvider);
    final currency = ref.watch(settingsProvider).currency;

    return Scaffold(
      backgroundColor: AurixColors.bgPrimary,
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 14), child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Vendors', style: AurixTypography.display2(AurixColors.textPrimary)),
              _iconBtn(context, Icons.person_add_rounded, () => context.go('/vendors/add')),
            ]),
            const SizedBox(height: 14),
            AurixSearchBar(
              hint: 'Search vendors…',
              onChanged: (v) => ref.read(vendorSearchProvider.notifier).state = v,
            ),
          ])),

        // Summary chips
        Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 14), child:
          Row(children: [
            _summaryChip('Total', '${vendors.length}', AurixColors.info, AurixColors.infoBg),
            const SizedBox(width: 10),
            _summaryChip('In Credit', '${vendors.where((v) => v.hasCredit).length}', AurixColors.credit, AurixColors.creditBg),
            const SizedBox(width: 10),
            _summaryChip('In Debt', '${vendors.where((v) => v.hasDebt).length}', AurixColors.debit, AurixColors.debitBg),
          ])),

        Expanded(child: vendors.isEmpty
            ? EmptyState(
                icon: Icons.people_outline_rounded,
                title: 'No Vendors Yet',
                subtitle: 'Add vendors to track credits & debits',
                actionLabel: 'Add Vendor',
                onAction: () => context.go('/vendors/add'))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                itemCount: vendors.length,
                itemBuilder: (ctx, i) => _VendorTile(
                  vendor: vendors[i], currency: currency, index: i,
                  onTap: () => context.go('/vendors/detail', extra: vendors[i]),
                  onEdit: () => context.go('/vendors/edit', extra: vendors[i]),
                  onDelete: () async {
                    final ok = await showDeleteDialog(ctx, vendors[i].name);
                    if (ok == true) {
                      await ref.read(vendorListProvider.notifier).delete(vendors[i].id);
                      if (ctx.mounted) showSuccessSnack(ctx, 'Vendor deleted');
                    }
                  }))),
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/vendors/add'),
        child: const Icon(Icons.person_add_rounded, size: 26)),
    );
  }

  Widget _iconBtn(BuildContext ctx, IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(width: 40, height: 40,
      decoration: BoxDecoration(color: AurixColors.bgElevated, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AurixColors.borderDivider)),
      child: Icon(icon, color: AurixColors.goldPrimary, size: 20)),
  );

  Widget _summaryChip(String label, String value, Color color, Color bg) =>
    Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(value, style: AurixTypography.label(color)),
        const SizedBox(width: 4),
        Text(label, style: AurixTypography.caption(color.withOpacity(0.8))),
      ]));
}

class _VendorTile extends StatelessWidget {
  final Vendor vendor;
  final String currency;
  final int index;
  final VoidCallback onTap, onEdit, onDelete;

  const _VendorTile({required this.vendor, required this.currency,
    required this.index, required this.onTap, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final balColor = vendor.isSettled ? AurixColors.textMuted : vendor.hasCredit ? AurixColors.credit : AurixColors.debit;
    final balBg    = vendor.isSettled ? AurixColors.bgElevated : vendor.hasCredit ? AurixColors.creditBg : AurixColors.debitBg;

    return Dismissible(
      key: Key(vendor.id),
      background: Container(margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: AurixColors.infoBg, borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.edit_rounded, color: AurixColors.info)),
      secondaryBackground: Container(margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: AurixColors.errorBg, borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: AurixColors.error)),
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.startToEnd) { onEdit(); return false; }
        onDelete(); return false;
      },
      child: GlassCard(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        onTap: onTap,
        child: Row(children: [
          Container(width: 50, height: 50,
            decoration: BoxDecoration(gradient: AurixColors.goldGradient, borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text(vendor.initials,
              style: AurixTypography.headline3(AurixColors.textOnGold)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(vendor.name, style: AurixTypography.headline3(AurixColors.textPrimary)),
            const SizedBox(height: 3),
            Text(vendor.phone, style: AurixTypography.caption(AurixColors.textMuted)),
            const SizedBox(height: 8),
            Row(children: [
              _pill('C: ${AppUtils.formatCurrencyCompact(vendor.totalCredit, symbol: currency)}', AurixColors.credit, AurixColors.creditBg),
              const SizedBox(width: 6),
              _pill('D: ${AppUtils.formatCurrencyCompact(vendor.totalDebit, symbol: currency)}', AurixColors.debit, AurixColors.debitBg),
            ]),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: balBg, borderRadius: BorderRadius.circular(10)),
              child: Text(
                '${vendor.hasDebt ? '-' : ''}${AppUtils.formatCurrencyCompact(vendor.balance.abs(), symbol: currency)}',
                style: AurixTypography.label(balColor))),
            const SizedBox(height: 4),
            Text(vendor.isSettled ? 'Settled' : vendor.hasCredit ? 'To Receive' : 'To Pay',
              style: AurixTypography.caption(balColor)),
          ]),
        ]),
      ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn(duration: 350.ms).slideX(begin: 0.08, end: 0),
    );
  }

  Widget _pill(String label, Color color, Color bg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
    child: Text(label, style: AurixTypography.caption(color)));
}
