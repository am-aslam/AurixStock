import 'package:hive_flutter/hive_flutter.dart';
import '../models/stock_entry.dart';
import '../models/vendor.dart';
import '../models/transaction.dart';
import '../core/constants/app_constants.dart';

class HiveService {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(AppConstants.stockTypeId)) {
      Hive.registerAdapter(StockEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(AppConstants.vendorTypeId)) {
      Hive.registerAdapter(VendorAdapter());
    }
    if (!Hive.isAdapterRegistered(AppConstants.transactionTypeId)) {
      Hive.registerAdapter(TransactionAdapter());
    }
    await Future.wait([
      Hive.openBox<StockEntry>(AppConstants.stockBox),
      Hive.openBox<Vendor>(AppConstants.vendorBox),
      Hive.openBox<Transaction>(AppConstants.transactionBox),
      Hive.openBox(AppConstants.settingsBox),
    ]);
  }

  static Box<StockEntry>  get stockBox       => Hive.box<StockEntry>(AppConstants.stockBox);
  static Box<Vendor>      get vendorBox      => Hive.box<Vendor>(AppConstants.vendorBox);
  static Box<Transaction> get transactionBox => Hive.box<Transaction>(AppConstants.transactionBox);
  static Box               get settingsBox   => Hive.box(AppConstants.settingsBox);
}
