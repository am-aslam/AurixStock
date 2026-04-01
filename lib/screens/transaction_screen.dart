import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../providers/providers.dart';
import '../models/transaction.dart';
import '../core/utils/app_utils.dart';
import '../widgets/common/common_widgets.dart';

class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs      = ref.watch(filteredTransactionProvider);
    final typeF    = ref.watch(txTypeFilterProvider);
    final allTxs   = ref.watch(transactionListProvider).valueOrNull ?? [];
    final currency = ref.watch(settingsProvider).currency;
    final totalC   = allTxs.where((t) => t.isCredit).fold(0.0, (s, t) => s + t.amount);
    final totalD   = allTxs.where((t) => t.isDebit).fold(0.0, (s, t) => s + t.amount);

    return Scaffold(
      backgroundColor: AurixColors.bgPrimary,
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Ledger', style: AurixTypography.display2(AurixColors.textPrimary)),
            const SizedBox(height: 14),

            // Summary strip
            Row(children: [
              Expanded(child: _summaryTile('Total Credit',
                AppUtils.formatCurrencyCompact(totalC, symbol: currency),
                AurixColors.credit, AurixColors.creditBg, Icons.arrow_circle_up_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _summaryTile('Total Debit',
                AppUtils.formatCurrencyCompact(totalD, symbol: currency),
                AurixColors.debit, AurixColors.debitBg, Icons.arrow_circle_down_rounded)),
            ]),
            const SizedBox(height: 14),

            AurixSearchBar(
              hint: 'Search transactions…',
              onChanged: (v) => ref.read(txSearchProvider.notifier).state = v,
            ),
            const SizedBox(height: 12),

            Row(children: [
              _filterChip('All', typeF == null, () => ref.read(txTypeFilterProvider.notifier).state = null, AurixColors.textMuted, AurixColors.bgElevated),
              const SizedBox(width: 8),
              _filterChip('Credit', typeF == 'credit', () => ref.read(txTypeFilterProvider.notifier).state = typeF == 'credit' ? null : 'credit', AurixColors.credit, AurixColors.creditBg),
              const SizedBox(width: 8),
              _filterChip('Debit', typeF == 'debit', () => ref.read(txTypeFilterProvider.notifier).state = typeF == 'debit' ? null : 'debit', AurixColors.debit, AurixColors.debitBg),
            ]),
            const SizedBox(height: 14),
          ])),

        Expanded(child: txs.isEmpty
            ? EmptyState(
                icon: Icons.swap_horiz_outlined,
                title: 'No Transactions',
                subtitle: 'Record credits and debits here',
                actionLabel: 'Add Transaction',
                onAction: () => context.go('/transactions/add'))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                itemCount: txs.length,
                itemBuilder: (ctx, i) => _TxTile(
                  tx: txs[i], currency: currency, index: i,
                  onDelete: () async {
                    final ok = await showDeleteDialog(ctx, 'this transaction');
                    if (ok == true) {
                      await ref.read(transactionListProvider.notifier).delete(txs[i].id);
                      if (ctx.mounted) showSuccessSnack(ctx, 'Transaction deleted');
                    }
                  }))),
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/transactions/add'),
        child: const Icon(Icons.add_rounded, size: 28)),
    );
  }

  Widget _summaryTile(String label, String value, Color color, Color bg, IconData icon) =>
    Container(padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: AurixTypography.amountSmall(color).copyWith(fontSize: 16)),
          Text(label, style: AurixTypography.caption(color.withOpacity(0.8))),
        ]),
      ]));

  Widget _filterChip(String label, bool active, VoidCallback onTap, Color color, Color bg) =>
    GestureDetector(onTap: onTap, child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? bg : AurixColors.bgElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: active ? color : AurixColors.borderDivider)),
      child: Text(label, style: AurixTypography.label(active ? color : AurixColors.textMuted))));
}

class _TxTile extends StatelessWidget {
  final Transaction tx;
  final String currency;
  final int index;
  final VoidCallback onDelete;
  const _TxTile({required this.tx, required this.currency, required this.index, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(tx.id),
      direction: DismissDirection.endToStart,
      background: Container(margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: AurixColors.errorBg, borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: AurixColors.error)),
      confirmDismiss: (_) async { onDelete(); return false; },
      child: GlassCard(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(width: 44, height: 44,
            decoration: BoxDecoration(
              color: tx.isCredit ? AurixColors.creditBg : AurixColors.debitBg,
              borderRadius: BorderRadius.circular(14)),
            child: Icon(tx.isCredit ? Icons.add_rounded : Icons.remove_rounded,
              color: tx.isCredit ? AurixColors.credit : AurixColors.debit, size: 22)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tx.vendorName, style: AurixTypography.headline3(AurixColors.textPrimary)),
            const SizedBox(height: 3),
            if (tx.description != null && tx.description!.isNotEmpty)
              Text(tx.description!, style: AurixTypography.caption(AurixColors.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text('${tx.paymentMode} · ${AppUtils.formatDate(tx.date)}',
              style: AurixTypography.caption(AurixColors.textMuted)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${tx.isCredit ? '+' : '-'}${AppUtils.formatCurrencyCompact(tx.amount, symbol: currency)}',
              style: AurixTypography.amountSmall(tx.isCredit ? AurixColors.credit : AurixColors.debit).copyWith(fontSize: 15)),
            const SizedBox(height: 4),
            StatusBadge(
              label: tx.type.toUpperCase(),
              color: tx.isCredit ? AurixColors.credit : AurixColors.debit,
              bgColor: tx.isCredit ? AurixColors.creditBg : AurixColors.debitBg),
          ]),
        ]),
      ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn(duration: 300.ms).slideX(begin: 0.05, end: 0),
    );
  }
}
