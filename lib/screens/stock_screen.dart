import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../providers/providers.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/app_utils.dart';
import '../models/stock_entry.dart';
import '../widgets/common/common_widgets.dart';

class StockScreen extends ConsumerStatefulWidget {
  const StockScreen({super.key});
  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final entries  = ref.watch(filteredStockProvider);
    final catFilter= ref.watch(stockCategoryFilterProvider);
    final typeFilter=ref.watch(stockTypeFilterProvider);
    final currency = ref.watch(settingsProvider).currency;

    return Scaffold(
      backgroundColor: AurixColors.bgPrimary,
      body: SafeArea(child: Column(children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Stock', style: AurixTypography.display2(AurixColors.textPrimary)),
              _iconBtn(Icons.tune_rounded, _showFilterSheet),
            ]),
            const SizedBox(height: 14),
            AurixSearchBar(
              controller: _searchCtrl,
              hint: 'Search by name, category, vendor…',
              onChanged: (v) => ref.read(stockSearchQueryProvider.notifier).state = v,
            ),
            const SizedBox(height: 12),
            // Category chips
            SizedBox(height: 36,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                _chip('All', catFilter == null, () => ref.read(stockCategoryFilterProvider.notifier).state = null),
                ...AppConstants.goldCategories.map((c) =>
                  _chip(c, catFilter == c, () => ref.read(stockCategoryFilterProvider.notifier).state = catFilter == c ? null : c)),
              ])),
            // Type chips
            const SizedBox(height: 8),
            Row(children: [
              _typeChip('In',  'in',  typeFilter),
              const SizedBox(width: 8),
              _typeChip('Out', 'out', typeFilter),
            ]),
            const SizedBox(height: 14),
          ]),
        ),

        // List
        Expanded(child: entries.isEmpty
            ? EmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'No Stock Entries',
                subtitle: 'Tap + to add your first gold entry',
                actionLabel: 'Add Stock',
                onAction: () => context.go('/stock/add'))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                itemCount: entries.length,
                itemBuilder: (ctx, i) => _StockTile(
                  entry: entries[i], currency: currency, index: i,
                  onEdit: () => context.go('/stock/edit', extra: entries[i]),
                  onDelete: () => _delete(entries[i]),
                ))),
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/stock/add'),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(width: 40, height: 40,
      decoration: BoxDecoration(color: AurixColors.bgElevated, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AurixColors.borderDivider)),
      child: Icon(icon, color: AurixColors.textSecondary, size: 20)),
  );

  Widget _chip(String label, bool selected, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AurixColors.goldPrimary : AurixColors.bgElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: selected ? AurixColors.goldPrimary : AurixColors.borderDivider)),
      child: Text(label, style: AurixTypography.label(selected ? AurixColors.textOnGold : AurixColors.textSecondary)),
    ),
  );

  Widget _typeChip(String label, String val, String? current) => GestureDetector(
    onTap: () => ref.read(stockTypeFilterProvider.notifier).state = current == val ? null : val,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: current == val ? (val == 'in' ? AurixColors.creditBg : AurixColors.debitBg) : AurixColors.bgElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: current == val ? (val == 'in' ? AurixColors.credit : AurixColors.debit) : AurixColors.borderDivider)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(val == 'in' ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
          color: current == val ? (val == 'in' ? AurixColors.credit : AurixColors.debit) : AurixColors.textMuted, size: 14),
        const SizedBox(width: 4),
        Text(label, style: AurixTypography.label(current == val ? (val == 'in' ? AurixColors.credit : AurixColors.debit) : AurixColors.textMuted)),
      ]),
    ),
  );

  void _showFilterSheet() {
    showModalBottomSheet(context: context, builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Filters', style: AurixTypography.headline2(AurixColors.textPrimary)),
        const GoldDivider(),
        GoldOutlinedButton(label: 'Clear All Filters', onTap: () {
          ref.read(stockCategoryFilterProvider.notifier).state = null;
          ref.read(stockTypeFilterProvider.notifier).state = null;
          ref.read(stockSearchQueryProvider.notifier).state = '';
          _searchCtrl.clear();
          Navigator.pop(context);
        }),
      ]),
    ));
  }

  Future<void> _delete(StockEntry entry) async {
    final ok = await showDeleteDialog(context, entry.name);
    if (ok == true && mounted) {
      await ref.read(stockListProvider.notifier).delete(entry.id);
      if (mounted) showSuccessSnack(context, 'Deleted "${entry.name}"');
    }
  }
}

class _StockTile extends StatelessWidget {
  final StockEntry entry;
  final String currency;
  final int index;
  final VoidCallback onEdit, onDelete;
  const _StockTile({required this.entry, required this.currency, required this.index, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isIn = entry.transactionType == 'in';
    return Dismissible(
      key: Key(entry.id),
      background: _swipeAction(Icons.edit_rounded, AurixColors.info, AurixColors.infoBg, Alignment.centerLeft),
      secondaryBackground: _swipeAction(Icons.delete_rounded, AurixColors.error, AurixColors.errorBg, Alignment.centerRight),
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.startToEnd) { onEdit(); return false; }
        final ok = await showDeleteDialog(context, entry.name);
        if (ok == true) onDelete();
        return false;
      },
      child: GlassCard(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        onTap: onEdit,
        child: Row(children: [
          Container(width: 48, height: 48,
            decoration: BoxDecoration(
              color: isIn ? AurixColors.creditBg : AurixColors.debitBg,
              borderRadius: BorderRadius.circular(14)),
            child: Center(child: Text(entry.category.substring(0,1),
              style: AurixTypography.headline2(isIn ? AurixColors.credit : AurixColors.debit)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(entry.name, style: AurixTypography.headline3(AurixColors.textPrimary))),
              StatusBadge(label: entry.karat,
                color: AurixColors.goldPrimary, bgColor: const Color(0x1AE6C068)),
            ]),
            const SizedBox(height: 4),
            Text('${entry.category} · ${entry.vendorName}',
              style: AurixTypography.caption(AurixColors.textMuted)),
            const SizedBox(height: 8),
            Row(children: [
              _pill(Icons.scale_rounded, '${entry.weightGrams}g × ${entry.quantity}'),
              const SizedBox(width: 8),
              _pill(Icons.calendar_today_rounded, AppUtils.formatDateShort(entry.createdAt)),
              const Spacer(),
              Text(AppUtils.formatCurrencyCompact(entry.totalValue, symbol: currency),
                style: AurixTypography.amountSmall(isIn ? AurixColors.credit : AurixColors.debit).copyWith(fontSize: 14)),
            ]),
          ])),
        ]),
      ).animate(delay: Duration(milliseconds: 50 * index))
          .fadeIn(duration: 350.ms).slideX(begin: 0.08, end: 0),
    );
  }

  Widget _pill(IconData icon, String label) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 11, color: AurixColors.textMuted),
    const SizedBox(width: 3),
    Text(label, style: AurixTypography.caption(AurixColors.textMuted)),
  ]);

  Widget _swipeAction(IconData icon, Color color, Color bg, Alignment align) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Align(alignment: align, child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(icon, color: color, size: 26))));
}
