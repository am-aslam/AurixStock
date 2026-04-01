import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';
import '../providers/providers.dart';
import '../services/export_service.dart';
import '../widgets/common/common_widgets.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});
  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  bool _loading = false;
  String? _lastExport;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AurixColors.bgPrimary,
      appBar: AppBar(title: Text('Export Data', style: AurixTypography.headline2(AurixColors.textPrimary))),
      body: ListView(padding: const EdgeInsets.all(20), children: [

        GlassCard(padding: const EdgeInsets.all(20), child: Column(children: [
          const Icon(Icons.upload_file_rounded, color: AurixColors.goldPrimary, size: 48),
          const SizedBox(height: 12),
          Text('Export Your Data', style: AurixTypography.headline2(AurixColors.textPrimary)),
          Text('Choose format and data to export', style: AurixTypography.body2(AurixColors.textMuted)),
        ])).animate().fadeIn(duration: 400.ms),

        const SizedBox(height: 24),

        _ExportOption(
          icon: Icons.inventory_2_rounded, title: 'Stock Entries',
          subtitle: 'All stock in/out entries', animIndex: 1,
          onCsv: () => _doExport(() async {
            final entries = ref.read(stockRepoProvider).getAll();
            return ref.read(exportServiceProvider).exportStockToCsv(entries);
          }),
          onPdf: () => _doExport(() async {
            final entries  = ref.read(stockRepoProvider).getAll();
            final shopName = ref.read(settingsProvider).shopName;
            return ref.read(exportServiceProvider).exportStockToPdf(entries, shopName);
          }),
        ),

        const SizedBox(height: 14),

        _ExportOption(
          icon: Icons.swap_horiz_rounded, title: 'Transactions',
          subtitle: 'All credit & debit entries', animIndex: 2,
          onCsv: () => _doExport(() async {
            final txs = ref.read(transactionRepoProvider).getAll();
            return ref.read(exportServiceProvider).exportTransactionsToCsv(txs);
          }),
          onPdf: () => _doExport(() async {
            final txs      = ref.read(transactionRepoProvider).getAll();
            final shopName = ref.read(settingsProvider).shopName;
            return ref.read(exportServiceProvider).exportTransactionsToPdf(txs, shopName);
          }),
        ),

        const SizedBox(height: 14),

        _ExportOption(
          icon: Icons.people_rounded, title: 'Vendors',
          subtitle: 'Vendor list with balances', animIndex: 3,
          onCsv: () => _doExport(() async {
            final vendors = ref.read(vendorRepoProvider).getAll();
            return ref.read(exportServiceProvider).exportVendorsToCsv(vendors);
          }),
          onPdf: null,
        ),

        if (_loading) ...[
          const SizedBox(height: 32),
          const Center(child: CircularProgressIndicator(color: AurixColors.goldPrimary)),
        ],

        if (_lastExport != null) ...[
          const SizedBox(height: 24),
          GlassCard(borderColor: AurixColors.success, padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(children: [
                const Icon(Icons.check_circle_rounded, color: AurixColors.success, size: 20),
                const SizedBox(width: 10),
                Text('Export Successful!', style: AurixTypography.headline3(AurixColors.success)),
              ]),
              const SizedBox(height: 8),
              Text(_lastExport!, style: AurixTypography.caption(AurixColors.textMuted)),
            ])).animate().fadeIn(duration: 400.ms),
        ],
      ]),
    );
  }

  Future<void> _doExport(Future<String> Function() fn) async {
    setState(() { _loading = true; _lastExport = null; });
    try {
      final path = await fn();
      await ref.read(exportServiceProvider).shareFile(path);
      setState(() => _lastExport = path);
    } catch (e) {
      if (mounted) showErrorSnack(context, 'Export failed: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _ExportOption extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback? onCsv, onPdf;
  final int animIndex;

  const _ExportOption({required this.icon, required this.title, required this.subtitle,
    this.onCsv, this.onPdf, required this.animIndex});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 42, height: 42,
            decoration: BoxDecoration(color: AurixColors.goldPrimary.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AurixColors.goldPrimary, size: 22)),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AurixTypography.headline3(AurixColors.textPrimary)),
            Text(subtitle, style: AurixTypography.caption(AurixColors.textMuted)),
          ]),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          if (onCsv != null) Expanded(child: GoldButton(label: 'CSV', icon: Icons.table_chart_rounded, onTap: onCsv, height: 42)),
          if (onCsv != null && onPdf != null) const SizedBox(width: 10),
          if (onPdf != null) Expanded(child: GoldOutlinedButton(label: 'PDF', icon: Icons.picture_as_pdf_rounded, onTap: onPdf, height: 42)),
        ]),
      ]),
    ).animate(delay: Duration(milliseconds: 100 * animIndex)).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
