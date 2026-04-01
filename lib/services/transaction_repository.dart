import '../models/transaction.dart';
import '../services/hive_service.dart';

class TransactionRepository {
  List<Transaction> getAll() =>
      HiveService.transactionBox.values
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  Transaction? getById(String id) =>
      HiveService.transactionBox.values.where((t) => t.id == id).firstOrNull;

  Future<void> add(Transaction tx) =>
      HiveService.transactionBox.put(tx.id, tx);

  Future<void> delete(String id) =>
      HiveService.transactionBox.delete(id);

  List<Transaction> getByVendor(String vendorId) =>
      getAll().where((t) => t.vendorId == vendorId).toList();

  List<Transaction> filterByType(String type) =>
      getAll().where((t) => t.type == type).toList();

  List<Transaction> filterByDateRange(DateTime start, DateTime end) =>
      getAll().where((t) =>
        t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
        t.date.isBefore(end.add(const Duration(days: 1)))
      ).toList();

  List<Transaction> search(String q) {
    final lq = q.toLowerCase();
    return getAll().where((t) =>
      t.vendorName.toLowerCase().contains(lq) ||
      (t.description?.toLowerCase().contains(lq) ?? false) ||
      t.paymentMode.toLowerCase().contains(lq)
    ).toList();
  }

  double getTotalCredit() =>
      getAll().where((t) => t.isCredit).fold(0.0, (s, t) => s + t.amount);

  double getTotalDebit() =>
      getAll().where((t) => t.isDebit).fold(0.0, (s, t) => s + t.amount);

  List<Map<String, dynamic>> getMonthlyFlow({int months = 6}) {
    final now = DateTime.now();
    return List.generate(months, (i) {
      final month = DateTime(now.year, now.month - (months - 1 - i), 1);
      final txs = getAll().where((t) =>
        t.date.year == month.year && t.date.month == month.month
      ).toList();
      return {
        'month': month,
        'credit': txs.where((t) => t.isCredit).fold(0.0, (s, t) => s + t.amount),
        'debit':  txs.where((t) => t.isDebit).fold(0.0, (s, t) => s + t.amount),
      };
    });
  }

  List<Transaction> getRecent({int limit = 10}) =>
      getAll().take(limit).toList();
}
