import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/stock_entry.dart';
import '../models/vendor.dart';
import '../models/transaction.dart';
import '../services/stock_repository.dart';
import '../services/vendor_repository.dart';
import '../services/transaction_repository.dart';
import '../services/export_service.dart';
import '../services/hive_service.dart';
import '../core/constants/app_constants.dart';

// ════════════════════════════════════════════════════════════════
//  REPOSITORIES
// ════════════════════════════════════════════════════════════════
final stockRepoProvider       = Provider((_) => StockRepository());
final vendorRepoProvider      = Provider((_) => VendorRepository());
final transactionRepoProvider = Provider((_) => TransactionRepository());
final exportServiceProvider   = Provider((_) => ExportService());
const _uuid = Uuid();

// ════════════════════════════════════════════════════════════════
//  SETTINGS
// ════════════════════════════════════════════════════════════════
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);

class SettingsState {
  final String shopName;
  final String currency;
  final String weightUnit;
  final bool pinEnabled;
  final bool biometricEnabled;
  final ThemeMode themeMode;

  const SettingsState({
    this.shopName = AppConstants.defaultShopName,
    this.currency = AppConstants.defaultCurrency,
    this.weightUnit = AppConstants.defaultWeightUnit,
    this.pinEnabled = false,
    this.biometricEnabled = false,
    this.themeMode = ThemeMode.dark,
  });

  SettingsState copyWith({
    String? shopName, String? currency, String? weightUnit,
    bool? pinEnabled, bool? biometricEnabled, ThemeMode? themeMode,
  }) =>
      SettingsState(
        shopName: shopName ?? this.shopName,
        currency: currency ?? this.currency,
        weightUnit: weightUnit ?? this.weightUnit,
        pinEnabled: pinEnabled ?? this.pinEnabled,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        themeMode: themeMode ?? this.themeMode,
      );
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _load();
  }

  void _load() {
    final box = HiveService.settingsBox;
    state = state.copyWith(
      shopName: box.get(AppConstants.keyShopName, defaultValue: AppConstants.defaultShopName) as String,
      currency: box.get(AppConstants.keyCurrency, defaultValue: AppConstants.defaultCurrency) as String,
      weightUnit: box.get(AppConstants.keyWeightUnit, defaultValue: AppConstants.defaultWeightUnit) as String,
      pinEnabled: box.get(AppConstants.keyPinEnabled, defaultValue: false) as bool,
      biometricEnabled: box.get(AppConstants.keyBiometric, defaultValue: false) as bool,
    );
  }

  Future<void> setShopName(String v) async {
    await HiveService.settingsBox.put(AppConstants.keyShopName, v);
    state = state.copyWith(shopName: v);
  }

  Future<void> setCurrency(String v) async {
    await HiveService.settingsBox.put(AppConstants.keyCurrency, v);
    state = state.copyWith(currency: v);
  }

  Future<void> setPinEnabled(bool v) async {
    await HiveService.settingsBox.put(AppConstants.keyPinEnabled, v);
    state = state.copyWith(pinEnabled: v);
  }

  Future<void> setBiometric(bool v) async {
    await HiveService.settingsBox.put(AppConstants.keyBiometric, v);
    state = state.copyWith(biometricEnabled: v);
  }
}

// ════════════════════════════════════════════════════════════════
//  STOCK
// ════════════════════════════════════════════════════════════════
final stockListProvider =
    StateNotifierProvider<StockNotifier, AsyncValue<List<StockEntry>>>(
  (ref) => StockNotifier(ref.read(stockRepoProvider)),
);

class StockNotifier extends StateNotifier<AsyncValue<List<StockEntry>>> {
  final StockRepository _repo;
  StockNotifier(this._repo) : super(const AsyncValue.loading()) { load(); }

  void load() {
    try { state = AsyncValue.data(_repo.getAll()); }
    catch (e, s) { state = AsyncValue.error(e, s); }
  }

  Future<void> add(StockEntry entry) async {
    await _repo.add(entry); load();
  }

  Future<void> update(StockEntry entry) async {
    await _repo.update(entry); load();
  }

  Future<void> delete(String id) async {
    await _repo.softDelete(id); load();
  }
}

final stockSearchQueryProvider = StateProvider<String>((_) => '');
final stockCategoryFilterProvider = StateProvider<String?>((_) => null);
final stockTypeFilterProvider = StateProvider<String?>((_) => null);

final filteredStockProvider = Provider<List<StockEntry>>((ref) {
  final all    = ref.watch(stockListProvider).valueOrNull ?? [];
  final query  = ref.watch(stockSearchQueryProvider);
  final cat    = ref.watch(stockCategoryFilterProvider);
  final type   = ref.watch(stockTypeFilterProvider);

  var result = all;
  if (query.isNotEmpty) {
    final q = query.toLowerCase();
    result = result.where((e) =>
      e.name.toLowerCase().contains(q) ||
      e.category.toLowerCase().contains(q) ||
      e.vendorName.toLowerCase().contains(q)
    ).toList();
  }
  if (cat != null)  result = result.where((e) => e.category == cat).toList();
  if (type != null) result = result.where((e) => e.transactionType == type).toList();
  return result;
});

// ════════════════════════════════════════════════════════════════
//  VENDORS
// ════════════════════════════════════════════════════════════════
final vendorListProvider =
    StateNotifierProvider<VendorNotifier, AsyncValue<List<Vendor>>>(
  (ref) => VendorNotifier(ref.read(vendorRepoProvider)),
);

class VendorNotifier extends StateNotifier<AsyncValue<List<Vendor>>> {
  final VendorRepository _repo;
  VendorNotifier(this._repo) : super(const AsyncValue.loading()) { load(); }

  void load() {
    try { state = AsyncValue.data(_repo.getAll()); }
    catch (e, s) { state = AsyncValue.error(e, s); }
  }

  Future<void> add(Vendor vendor) async { await _repo.add(vendor); load(); }
  Future<void> update(Vendor vendor) async { await _repo.update(vendor); load(); }
  Future<void> delete(String id) async { await _repo.softDelete(id); load(); }
  Future<void> updateBalance(String id, String type, double amount) async {
    await _repo.updateBalance(id, type, amount); load();
  }
}

final vendorSearchProvider = StateProvider<String>((_) => '');

final filteredVendorProvider = Provider<List<Vendor>>((ref) {
  final all   = ref.watch(vendorListProvider).valueOrNull ?? [];
  final query = ref.watch(vendorSearchProvider);
  if (query.isEmpty) return all;
  final q = query.toLowerCase();
  return all.where((v) =>
    v.name.toLowerCase().contains(q) || v.phone.contains(q)
  ).toList();
});

// ════════════════════════════════════════════════════════════════
//  TRANSACTIONS
// ════════════════════════════════════════════════════════════════
final transactionListProvider =
    StateNotifierProvider<TransactionNotifier, AsyncValue<List<Transaction>>>(
  (ref) => TransactionNotifier(ref.read(transactionRepoProvider)),
);

class TransactionNotifier extends StateNotifier<AsyncValue<List<Transaction>>> {
  final TransactionRepository _repo;
  TransactionNotifier(this._repo) : super(const AsyncValue.loading()) { load(); }

  void load() {
    try { state = AsyncValue.data(_repo.getAll()); }
    catch (e, s) { state = AsyncValue.error(e, s); }
  }

  Future<void> add(Transaction tx) async { await _repo.add(tx); load(); }
  Future<void> delete(String id) async { await _repo.delete(id); load(); }
}

final txSearchProvider = StateProvider<String>((_) => '');
final txTypeFilterProvider = StateProvider<String?>((_) => null);

final filteredTransactionProvider = Provider<List<Transaction>>((ref) {
  final all   = ref.watch(transactionListProvider).valueOrNull ?? [];
  final query = ref.watch(txSearchProvider);
  final type  = ref.watch(txTypeFilterProvider);

  var result = all;
  if (query.isNotEmpty) {
    final q = query.toLowerCase();
    result = result.where((t) =>
      t.vendorName.toLowerCase().contains(q) ||
      (t.description?.toLowerCase().contains(q) ?? false)
    ).toList();
  }
  if (type != null) result = result.where((t) => t.type == type).toList();
  return result;
});

// ════════════════════════════════════════════════════════════════
//  DASHBOARD SUMMARY
// ════════════════════════════════════════════════════════════════
final dashboardSummaryProvider = Provider<DashboardSummary>((ref) {
  final stock = ref.watch(stockListProvider).valueOrNull ?? [];
  final vendors = ref.watch(vendorListProvider).valueOrNull ?? [];
  final txs = ref.watch(transactionListProvider).valueOrNull ?? [];

  final inStock = stock.where((e) => e.transactionType == 'in').toList();
  final totalValue  = inStock.fold(0.0, (s, e) => s + e.totalValue);
  final totalWeight = inStock.fold(0.0, (s, e) => s + e.totalWeight);
  final totalCredit = txs.where((t) => t.isCredit).fold(0.0, (s, t) => s + t.amount);
  final totalDebit  = txs.where((t) => t.isDebit).fold(0.0, (s, t) => s + t.amount);

  return DashboardSummary(
    totalStockValue: totalValue,
    totalWeight: totalWeight,
    totalItems: inStock.fold(0, (s, e) => s + e.quantity),
    totalVendors: vendors.length,
    totalCredit: totalCredit,
    totalDebit: totalDebit,
    recentStock: stock.take(5).toList(),
    recentTxs: txs.take(5).toList(),
  );
});

class DashboardSummary {
  final double totalStockValue;
  final double totalWeight;
  final int totalItems;
  final int totalVendors;
  final double totalCredit;
  final double totalDebit;
  final List<StockEntry> recentStock;
  final List<Transaction> recentTxs;

  const DashboardSummary({
    required this.totalStockValue,
    required this.totalWeight,
    required this.totalItems,
    required this.totalVendors,
    required this.totalCredit,
    required this.totalDebit,
    required this.recentStock,
    required this.recentTxs,
  });
}
