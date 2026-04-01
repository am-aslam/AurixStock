import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import '../providers/providers.dart';
import '../services/stock_repository.dart';
import '../services/transaction_repository.dart';
import '../core/utils/app_utils.dart';
import '../widgets/common/common_widgets.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockRepo = ref.read(stockRepoProvider);
    final txRepo    = ref.read(transactionRepoProvider);
    final currency  = ref.watch(settingsProvider).currency;

    final monthly     = stockRepo.getMonthlyData();
    final txMonthly   = txRepo.getMonthlyFlow();
    final byCategory  = stockRepo.valueByCategory();
    final byKarat     = stockRepo.weightByKarat();

    return Scaffold(
      backgroundColor: AurixColors.bgPrimary,
      body: SafeArea(child: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Text('Analytics', style: AurixTypography.display2(AurixColors.textPrimary)))),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          sliver: SliverList(delegate: SliverChildListDelegate([

            // ── Monthly Stock Bar Chart ──────────────────────
            _ChartCard(
              title: 'Monthly Stock Value',
              subtitle: 'Last 6 months',
              child: SizedBox(height: 200,
                child: monthly.every((m) => (m['value'] as double) == 0)
                    ? Center(child: Text('No data yet', style: AurixTypography.body2(AurixColors.textMuted)))
                    : BarChart(BarChartData(
                        backgroundColor: Colors.transparent,
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(sideTitles: SideTitles(
                            showTitles: true, reservedSize: 28,
                            getTitlesWidget: (v, _) {
                              final i = v.toInt();
                              if (i < 0 || i >= monthly.length) return const SizedBox();
                              final d = monthly[i]['month'] as DateTime;
                              return Text(DateFormat('MMM').format(d),
                                style: AurixTypography.caption(AurixColors.textMuted));
                            }))),
                        barGroups: monthly.asMap().entries.map((e) {
                          final val = (e.value['value'] as double) / 1000;
                          return BarChartGroupData(x: e.key, barRods: [
                            BarChartRodData(toY: val, width: 22,
                              gradient: AurixColors.goldGradient,
                              borderRadius: BorderRadius.circular(6))]);
                        }).toList(),
                      ))),
            ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 20),

            // ── Credit vs Debit Line Chart ───────────────────
            _ChartCard(
              title: 'Credit vs Debit Flow',
              subtitle: 'Last 6 months',
              child: SizedBox(height: 200,
                child: txMonthly.every((m) => (m['credit'] as double) == 0 && (m['debit'] as double) == 0)
                    ? Center(child: Text('No transactions yet', style: AurixTypography.body2(AurixColors.textMuted)))
                    : LineChart(LineChartData(
                        backgroundColor: Colors.transparent,
                        gridData: FlGridData(show: true,
                          getDrawingHorizontalLine: (_) => FlLine(color: AurixColors.borderDivider, strokeWidth: 1),
                          getDrawingVerticalLine: (_) => const FlLine(color: Colors.transparent)),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(sideTitles: SideTitles(
                            showTitles: true, reservedSize: 28,
                            getTitlesWidget: (v, _) {
                              final i = v.toInt();
                              if (i < 0 || i >= txMonthly.length) return const SizedBox();
                              final d = txMonthly[i]['month'] as DateTime;
                              return Text(DateFormat('MMM').format(d),
                                style: AurixTypography.caption(AurixColors.textMuted));
                            }))),
                        lineBarsData: [
                          _lineBar(txMonthly.asMap().entries.map((e) =>
                            FlSpot(e.key.toDouble(), (e.value['credit'] as double) / 1000)).toList(),
                            AurixColors.credit),
                          _lineBar(txMonthly.asMap().entries.map((e) =>
                            FlSpot(e.key.toDouble(), (e.value['debit'] as double) / 1000)).toList(),
                            AurixColors.debit),
                        ],
                      ))),
            ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 20),

            // ── Pie Chart: Value by Category ─────────────────
            if (byCategory.isNotEmpty) ...[
              _ChartCard(
                title: 'Stock by Category',
                subtitle: 'Value distribution',
                child: SizedBox(height: 200, child: Row(children: [
                  Expanded(child: PieChart(PieChartData(
                    sectionsSpace: 2, centerSpaceRadius: 50,
                    sections: _pieSlices(byCategory),
                  ))),
                  const SizedBox(width: 16),
                  Column(mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: byCategory.entries.toList().take(5).toList().asMap().entries.map((e) =>
                      Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
                        Container(width: 10, height: 10, decoration: BoxDecoration(
                          color: _pieColor(e.key), borderRadius: BorderRadius.circular(2))),
                        const SizedBox(width: 6),
                        Text(e.value.key, style: AurixTypography.caption(AurixColors.textSecondary)),
                      ]))).toList()),
                ])),
              ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: 20),
            ],

            // ── Karat weight breakdown ───────────────────────
            if (byKarat.isNotEmpty) ...[
              _ChartCard(
                title: 'Weight by Karat',
                subtitle: 'Total gold weight distribution',
                child: Column(children: byKarat.entries.map((e) {
                  final total = byKarat.values.fold(0.0, (s, v) => s + v);
                  final pct   = total > 0 ? e.value / total : 0.0;
                  return Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(e.key, style: AurixTypography.label(AurixColors.textSecondary)),
                        Text(AppUtils.formatWeight(e.value), style: AurixTypography.label(AurixColors.goldPrimary)),
                      ]),
                      const SizedBox(height: 6),
                      ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(
                        value: pct, minHeight: 8,
                        backgroundColor: AurixColors.bgElevated,
                        valueColor: const AlwaysStoppedAnimation(AurixColors.goldPrimary))),
                    ]));
                }).toList()),
              ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: 20),
            ],

            // Legend
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _legend(AurixColors.credit, 'Credit'),
              const SizedBox(width: 20),
              _legend(AurixColors.debit, 'Debit'),
              const SizedBox(width: 20),
              _legend(AurixColors.goldPrimary, 'Stock'),
            ]),
          ])),
        ),
      ])),
    );
  }

  LineChartBarData _lineBar(List<FlSpot> spots, Color color) => LineChartBarData(
    spots: spots, isCurved: true, color: color, barWidth: 2.5,
    belowBarData: BarAreaData(show: true, color: color.withOpacity(0.1)),
    dotData: FlDotData(show: false));

  List<PieChartSectionData> _pieSlices(Map<String, double> data) {
    final total = data.values.fold(0.0, (s, v) => s + v);
    return data.entries.toList().asMap().entries.map((e) {
      final pct = total > 0 ? e.value.value / total * 100 : 0.0;
      return PieChartSectionData(
        value: e.value.value, color: _pieColor(e.key),
        title: '${pct.toStringAsFixed(0)}%',
        titleStyle: AurixTypography.caption(Colors.white).copyWith(fontSize: 10),
        radius: 60);
    }).toList();
  }

  Color _pieColor(int i) {
    const colors = [AurixColors.goldPrimary, AurixColors.credit, AurixColors.info,
      AurixColors.debit, AurixColors.warning, AurixColors.goldDark, AurixColors.goldSoft];
    return colors[i % colors.length];
  }

  Widget _legend(Color color, String label) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
    const SizedBox(width: 6),
    Text(label, style: AurixTypography.caption(AurixColors.textMuted)),
  ]);
}

class _ChartCard extends StatelessWidget {
  final String title, subtitle;
  final Widget child;
  const _ChartCard({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AurixTypography.headline3(AurixColors.textPrimary)),
        Text(subtitle, style: AurixTypography.caption(AurixColors.textMuted)),
        const SizedBox(height: 20),
        child,
      ]));
  }
}
