import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../providers/providers.dart';
import '../models/vendor.dart';
import '../models/transaction.dart';
import '../core/utils/app_utils.dart';
import '../widgets/common/common_widgets.dart';
import '../services/vendor_repository.dart';

class VendorDetailScreen extends ConsumerWidget {
  final Vendor vendor;
  const VendorDetailScreen({super.key, required this.vendor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(settingsProvider).currency;
    final repo = ref.read(vendorRepoProvider);
    final txs  = repo.getVendorTransactions(vendor.id);
    final balColor = vendor.isSettled ? AurixColors.textMuted
        : vendor.hasCredit ? AurixColors.credit : AurixColors.debit;

    return Scaffold(
      backgroundColor: AurixColors.bgPrimary,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 240,
          pinned: true,
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
          actions: [
            IconButton(icon: const Icon(Icons.edit_rounded),
              onPressed: () => context.go('/vendors/edit', extra: vendor)),
          ],
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Container(
              decoration: const BoxDecoration(gradient: AurixColors.heroGradient),
              child: SafeArea(child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(width: 72, height: 72,
                    decoration: BoxDecoration(gradient: AurixColors.goldGradient, shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AurixColors.goldPrimary.withOpacity(0.5), blurRadius: 24)]),
                    child: Center(child: Text(vendor.initials,
                      style: AurixTypography.headline1(AurixColors.textOnGold)))),
                  const SizedBox(height: 12),
                  Text(vendor.name, style: AurixTypography.headline1(AurixColors.textPrimary)),
                  Text(vendor.phone, style: AurixTypography.body2(AurixColors.textMuted)),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    _summaryItem('Credit', AppUtils.formatCurrencyCompact(vendor.totalCredit, symbol: currency), AurixColors.credit),
                    Container(width: 1, height: 36, color: AurixColors.borderDivider, margin: const EdgeInsets.symmetric(horizontal: 20)),
                    _summaryItem('Debit', AppUtils.formatCurrencyCompact(vendor.totalDebit, symbol: currency), AurixColors.debit),
                    Container(width: 1, height: 36, color: AurixColors.borderDivider, margin: const EdgeInsets.symmetric(horizontal: 20)),
                    _summaryItem('Balance', AppUtils.formatCurrencyCompact(vendor.balance.abs(), symbol: currency), balColor),
                  ]),
                ]),
              )),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          sliver: SliverList(delegate: SliverChildListDelegate([

            if (vendor.email != null) ...[
              _infoRow(Icons.email_rounded, vendor.email!),
              const SizedBox(height: 8),
            ],
            if (vendor.address != null) ...[
              _infoRow(Icons.location_on_rounded, vendor.address!),
              const SizedBox(height: 8),
            ],
            if (vendor.gstNumber != null) ...[
              _infoRow(Icons.receipt_long_rounded, 'GST: ${vendor.gstNumber}'),
              const SizedBox(height: 8),
            ],

            const GoldDivider(),

            SectionHeader(title: 'Transaction History'),
            const SizedBox(height: 14),

            if (txs.isEmpty)
              const EmptyState(icon: Icons.swap_horiz_outlined,
                title: 'No Transactions', subtitle: 'No ledger entries yet')
            else
              ...txs.asMap().entries.map((e) => _TxTile(tx: e.value, currency: currency, index: e.key)),
          ])),
        ),
      ]),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/transactions/add'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Transaction'),
        backgroundColor: AurixColors.goldPrimary,
        foregroundColor: AurixColors.textOnGold,
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color color) =>
    Column(children: [
      Text(value, style: AurixTypography.amountSmall(color).copyWith(fontSize: 16)),
      const SizedBox(height: 2),
      Text(label, style: AurixTypography.caption(AurixColors.textMuted)),
    ]);

  Widget _infoRow(IconData icon, String text) =>
    Row(children: [
      Icon(icon, size: 16, color: AurixColors.textMuted),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: AurixTypography.body2(AurixColors.textSecondary))),
    ]);
}

class _TxTile extends StatelessWidget {
  final Transaction tx;
  final String currency;
  final int index;
  const _TxTile({required this.tx, required this.currency, required this.index});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(width: 42, height: 42,
          decoration: BoxDecoration(
            color: tx.isCredit ? AurixColors.creditBg : AurixColors.debitBg,
            borderRadius: BorderRadius.circular(12)),
          child: Icon(tx.isCredit ? Icons.add_rounded : Icons.remove_rounded,
            color: tx.isCredit ? AurixColors.credit : AurixColors.debit, size: 22)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tx.type.toUpperCase(),
            style: AurixTypography.label(tx.isCredit ? AurixColors.credit : AurixColors.debit)),
          if (tx.description != null && tx.description!.isNotEmpty)
            Text(tx.description!, style: AurixTypography.caption(AurixColors.textMuted)),
          Text('${tx.paymentMode} · ${AppUtils.formatDate(tx.date)}',
            style: AurixTypography.caption(AurixColors.textMuted)),
        ])),
        Text('${tx.isCredit ? '+' : '-'}${AppUtils.formatCurrencyCompact(tx.amount, symbol: currency)}',
          style: AurixTypography.amountSmall(tx.isCredit ? AurixColors.credit : AurixColors.debit).copyWith(fontSize: 15)),
      ]),
    ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn(duration: 300.ms);
  }
}
