import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 2)
class Transaction extends HiveObject {
  @HiveField(0)  late String id;
  @HiveField(1)  late String vendorId;
  @HiveField(2)  late String vendorName;
  @HiveField(3)  late String type;       // 'credit' | 'debit'
  @HiveField(4)  late double amount;
  @HiveField(5)  late DateTime date;
  @HiveField(6)  String? description;
  @HiveField(7)  String? stockEntryId;
  @HiveField(8)  late String paymentMode;
  @HiveField(9)  String? referenceNumber;
  @HiveField(10) late DateTime createdAt;

  Transaction({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.type,
    required this.amount,
    required this.date,
    this.description,
    this.stockEntryId,
    required this.paymentMode,
    this.referenceNumber,
    required this.createdAt,
  });

  bool get isCredit => type == 'credit';
  bool get isDebit  => type == 'debit';

  Map<String, dynamic> toMap() => {
    'ID': id, 'Vendor': vendorName, 'Type': type, 'Amount': amount,
    'Date': date.toIso8601String(), 'Payment Mode': paymentMode,
    'Reference': referenceNumber ?? '', 'Description': description ?? '',
  };
}
