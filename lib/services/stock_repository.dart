import '../models/stock_entry.dart';
import '../services/hive_service.dart';

class StockRepository {
  List<StockEntry> getAll() =>
      HiveService.stockBox.values
          .where((e) => e.isActive)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  StockEntry? getById(String id) =>
      HiveService.stockBox.values.where((e) => e.id == id).firstOrNull;

  Future<void> add(StockEntry entry) =>
      HiveService.stockBox.put(entry.id, entry);

  Future<void> update(StockEntry entry) =>
      HiveService.stockBox.put(entry.id, entry);

  Future<void> softDelete(String id) async {
    final e = getById(id);
    if (e != null) { e.isActive = false; await e.save(); }
  }

  // ── Search & Filter ──────────────────────────────────────
  List<StockEntry> search(String q) {
    final lq = q.toLowerCase();
    return getAll().where((e) =>
      e.name.toLowerCase().contains(lq) ||
      e.category.toLowerCase().contains(lq) ||
      e.vendorName.toLowerCase().contains(lq) ||
      e.karat.toLowerCase().contains(lq)
    ).toList();
  }

  List<StockEntry> filterByCategory(String cat) =>
      getAll().where((e) => e.category == cat).toList();

  List<StockEntry> filterByType(String type) =>
      getAll().where((e) => e.transactionType == type).toList();

  List<StockEntry> filterByVendor(String vendorId) =>
      getAll().where((e) => e.vendorId == vendorId).toList();

  List<StockEntry> filterByDateRange(DateTime start, DateTime end) =>
      getAll().where((e) =>
        e.createdAt.isAfter(start.subtract(const Duration(seconds: 1))) &&
        e.createdAt.isBefore(end.add(const Duration(days: 1)))
      ).toList();

  // ── Analytics ────────────────────────────────────────────
  double getTotalValue() =>
      getAll().where((e) => e.transactionType == 'in')
          .fold(0.0, (s, e) => s + e.totalValue);

  double getTotalWeight() =>
      getAll().where((e) => e.transactionType == 'in')
          .fold(0.0, (s, e) => s + e.totalWeight);

  int getTotalItems() =>
      getAll().where((e) => e.transactionType == 'in')
          .fold(0, (s, e) => s + e.quantity);

  Map<String, double> valueByCategory() {
    final map = <String, double>{};
    for (final e in getAll().where((e) => e.transactionType == 'in')) {
      map[e.category] = (map[e.category] ?? 0) + e.totalValue;
    }
    return map;
  }

  Map<String, double> weightByKarat() {
    final map = <String, double>{};
    for (final e in getAll().where((e) => e.transactionType == 'in')) {
      map[e.karat] = (map[e.karat] ?? 0) + e.totalWeight;
    }
    return map;
  }

  List<Map<String, dynamic>> getMonthlyData({int months = 6}) {
    final now = DateTime.now();
    return List.generate(months, (i) {
      final month = DateTime(now.year, now.month - (months - 1 - i), 1);
      final entries = getAll().where((e) =>
        e.createdAt.year == month.year && e.createdAt.month == month.month
      ).toList();
      return {
        'month': month,
        'count': entries.length,
        'value': entries.fold(0.0, (s, e) => s + e.totalValue),
        'weight': entries.fold(0.0, (s, e) => s + e.totalWeight),
      };
    });
  }

  Map<String, List<StockEntry>> groupByDate() {
    final map = <String, List<StockEntry>>{};
    for (final e in getAll()) {
      final k =
          '${e.createdAt.year}-${e.createdAt.month.toString().padLeft(2,'0')}-${e.createdAt.day.toString().padLeft(2,'0')}';
      (map[k] ??= []).add(e);
    }
    return map;
  }

  List<StockEntry> getRecent({int limit = 10}) =>
      getAll().take(limit).toList();
}
