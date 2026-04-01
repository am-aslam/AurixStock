import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../providers/providers.dart';
import '../core/utils/app_utils.dart';
import '../widgets/common/common_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary  = ref.watch(dashboardSummaryProvider);
    final settings = ref.watch(settingsProvider);
    final currency = settings.currency;

    return Scaffold(
      backgroundColor: AurixColors.bgPrimary,
      body: CustomScrollView(slivers: [
        // ── App Bar ──────────────────────────────────────────
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          stretch: true,
          backgroundColor: AurixColors.bgPrimary,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Container(
              decoration: const BoxDecoration(gradient: AurixColors.heroGradient),
              child: SafeArea(child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Good ${_greeting()}!',
                          style: AurixTypography.body2(AurixColors.textMuted)),
                      Text(settings.shopName,
                          style: AurixTypography.headline1(AurixColors.textPrimary)),
                    ]),
                    Row(children: [
                      _iconBtn(Icons.notifications_outlined, () {}),
                      const SizedBox(width: 8),
                      _iconBtn(Icons.settings_outlined, () => context.go('/settings')),
                    ]),
                  ]),
                  const SizedBox(height: 24),
                  // Hero value card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AurixColors.goldGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: AurixColors.goldPrimary.withOpacity(0.4), blurRadius: 24, offset: const Offset(0,8))],
                    ),
                    child: Row(children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Total Stock Value', style: AurixTypography.label(AurixColors.textOnGold.withOpacity(0.7))),
                        const SizedBox(height: 4),
                        Text(AppUtils.formatCurrencyCompact(summary.totalStockValue, symbol: currency),
                            style: AurixTypography.display2(AurixColors.textOnGold)),
                        const SizedBox(height: 4),
                        Text('${AppUtils.formatWeight(summary.totalWeight)} · ${summary.totalItems} items',
                            style: AurixTypography.body2(AurixColors.textOnGold.withOpacity(0.75))),
                      ]),
                      const Spacer(),
                      const Icon(Icons.diamond_rounded, color: AurixColors.textOnGold, size: 48),
                    ]),
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
                ]),
              )),
            ),
          ),
          title: Text('AurixStock', style: AurixTypography.headline2(AurixColors.textPrimary)),
        ),

        // ── Body ──────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          sliver: SliverList(delegate: SliverChildListDelegate([

            // 4 stat cards
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.5,
              children: [
                StatCard(label: 'Vendors',      value: '${summary.totalVendors}',
                    icon: Icons.people_rounded,         iconColor: AurixColors.info,        iconBg: AurixColors.infoBg,     animIndex: 0),
                StatCard(label: 'Total Credit', value: AppUtils.formatCurrencyCompact(summary.totalCredit, symbol: currency),
                    icon: Icons.arrow_circle_up_rounded, iconColor: AurixColors.credit,     iconBg: AurixColors.creditBg,   animIndex: 1),
                StatCard(label: 'Total Debit',  value: AppUtils.formatCurrencyCompact(summary.totalDebit, symbol: currency),
                    icon: Icons.arrow_circle_down_rounded, iconColor: AurixColors.debit,    iconBg: AurixColors.debitBg,    animIndex: 2),
                StatCard(label: 'Net Balance',  value: AppUtils.formatCurrencyCompact(summary.totalCredit - summary.totalDebit, symbol: currency),
                    icon: Icons.account_balance_wallet_rounded, iconColor: AurixColors.goldPrimary, iconBg: const Color(0x1AE6C068), animIndex: 3),
              ],
            ),

            const SizedBox(height: 28),

            // Quick actions
            SectionHeader(title: 'Quick Actions'),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _quickAction(context, Icons.add_circle_rounded, 'Add Stock', AurixColors.goldPrimary, () => context.go('/stock/add'))),
              const SizedBox(width: 12),
              Expanded(child: _quickAction(context, Icons.swap_horiz_rounded, 'Add Transaction', AurixColors.info, () => context.go('/transactions/add'))),
              const SizedBox(width: 12),
              Expanded(child: _quickAction(context, Icons.person_add_rounded, 'Add Vendor', AurixColors.credit, () => context.go('/vendors/add'))),
            ]).animate(delay: 200.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: 28),

            // Recent Stock
            SectionHeader(title: 'Recent Stock', action: 'See All', onAction: () => context.go('/stock')),
            const SizedBox(height: 14),
            if (summary.recentStock.isEmpty)
              const EmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'No Stock Yet',
                subtitle: 'Add your first gold entry',
              )
            else
              ...summary.recentStock.asMap().entries.map((e) =>
                _RecentStockTile(entry: e.value, currency: currency, index: e.key)),

            const SizedBox(height: 28),

            // Recent Transactions
            SectionHeader(title: 'Recent Ledger', action: 'See All', onAction: () => context.go('/transactions')),
            const SizedBox(height: 14),
            if (summary.recentTxs.isEmpty)
              const EmptyState(
                icon: Icons.swap_horiz_outlined,
                title: 'No Transactions Yet',
                subtitle: 'Record credits and debits',
              )
            else
              ...summary.recentTxs.asMap().entries.map((e) =>
                _RecentTxTile(tx: e.value, currency: currency, index: e.key)),
          ])),
        ),
      ]),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: AurixColors.bgGlass, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AurixColors.borderSubtle)),
        child: Icon(icon, color: AurixColors.textSecondary, size: 20),
      ),
    );
  }

  Widget _quickAction(BuildContext ctx, IconData icon, String label, Color color, VoidCallback onTap) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      onTap: onTap,
      child: Column(children: [
        Container(width: 44, height: 44,
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: color, size: 22)),
        const SizedBox(height: 8),
        Text(label, style: AurixTypography.caption(AurixColors.textSecondary), textAlign: TextAlign.center),
      ]),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Morning';
    if (h < 17) return 'Afternoon';
    return 'Evening';
  }
}

class _RecentStockTile extends StatelessWidget {
  final dynamic entry;
  final String currency;
  final int index;
  const _RecentStockTile({required this.entry, required this.currency, required this.index});

  @override
  Widget build(BuildContext context) {
    final isIn = entry.transactionType == 'in';
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(width: 42, height: 42,
          decoration: BoxDecoration(
            color: isIn ? AurixColors.creditBg : AurixColors.debitBg,
            borderRadius: BorderRadius.circular(12)),
          child: Icon(isIn ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
            color: isIn ? AurixColors.credit : AurixColors.debit, size: 20)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(entry.name, style: AurixTypography.headline3(AurixColors.textPrimary)),
          Text('${entry.category} · ${entry.karat} · ${entry.vendorName}',
              style: AurixTypography.caption(AurixColors.textMuted)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(AppUtils.formatCurrencyCompact(entry.totalValue, symbol: currency),
              style: AurixTypography.amountSmall(isIn ? AurixColors.credit : AurixColors.debit).copyWith(fontSize: 14)),
          Text(AppUtils.timeAgo(entry.createdAt), style: AurixTypography.caption(AurixColors.textMuted)),
        ]),
      ]),
    ).animate(delay: Duration(milliseconds: 60 * index)).fadeIn(duration: 350.ms).slideX(begin: 0.1, end: 0);
  }
}

class _RecentTxTile extends StatelessWidget {
  final dynamic tx;
  final String currency;
  final int index;
  const _RecentTxTile({required this.tx, required this.currency, required this.index});

  @override
  Widget build(BuildContext context) {
    final isCredit = tx.isCredit;
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(width: 42, height: 42,
          decoration: BoxDecoration(
            color: isCredit ? AurixColors.creditBg : AurixColors.debitBg,
            borderRadius: BorderRadius.circular(12)),
          child: Icon(isCredit ? Icons.add_rounded : Icons.remove_rounded,
            color: isCredit ? AurixColors.credit : AurixColors.debit, size: 22)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tx.vendorName, style: AurixTypography.headline3(AurixColors.textPrimary)),
          Text('${tx.paymentMode} · ${AppUtils.timeAgo(tx.date)}',
              style: AurixTypography.caption(AurixColors.textMuted)),
        ])),
        Text(
          '${isCredit ? '+' : '-'}${AppUtils.formatCurrencyCompact(tx.amount, symbol: currency)}',
          style: AurixTypography.amountSmall(isCredit ? AurixColors.credit : AurixColors.debit).copyWith(fontSize: 15),
        ),
      ]),
    ).animate(delay: Duration(milliseconds: 60 * index)).fadeIn(duration: 350.ms).slideX(begin: 0.1, end: 0);
  }
}
