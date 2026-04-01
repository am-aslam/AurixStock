import '../models/vendor.dart';
import '../models/transaction.dart';
import '../services/hive_service.dart';

class VendorRepository {
  List<Vendor> getAll() =>
      HiveService.vendorBox.values
          .where((v) => v.isActive)
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));

  Vendor? getById(String id) =>
      HiveService.vendorBox.values.where((v) => v.id == id).firstOrNull;

  Future<void> add(Vendor vendor) =>
      HiveService.vendorBox.put(vendor.id, vendor);

  Future<void> update(Vendor vendor) =>
      HiveService.vendorBox.put(vendor.id, vendor);

  Future<void> softDelete(String id) async {
    final v = getById(id);
    if (v != null) { v.isActive = false; await v.save(); }
  }

  List<Vendor> search(String q) {
    final lq = q.toLowerCase();
    return getAll().where((v) =>
      v.name.toLowerCase().contains(lq) ||
      v.phone.contains(lq) ||
      (v.email?.toLowerCase().contains(lq) ?? false)
    ).toList();
  }

  Future<void> updateBalance(String vendorId, String type, double amount) async {
    final v = getById(vendorId);
    if (v == null) return;
    if (type == 'credit') {
      v.totalCredit += amount;
    } else {
      v.totalDebit += amount;
    }
    await v.save();
  }

  List<Transaction> getVendorTransactions(String vendorId) =>
      HiveService.transactionBox.values
          .where((t) => t.vendorId == vendorId)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  double getTotalOutstanding() =>
      getAll().fold(0.0, (s, v) => s + v.balance.abs());

  int get total        => getAll().length;
  int get inDebt       => getAll().where((v) => v.hasDebt).length;
  int get withCredit   => getAll().where((v) => v.hasCredit).length;
}
