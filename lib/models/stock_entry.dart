import 'package:hive/hive.dart';

part 'stock_entry.g.dart';

@HiveType(typeId: 0)
class StockEntry extends HiveObject {
  @HiveField(0)  late String id;
  @HiveField(1)  late String name;
  @HiveField(2)  late String category;
  @HiveField(3)  late String karat;
  @HiveField(4)  late double weightGrams;
  @HiveField(5)  late double pricePerGram;
  @HiveField(6)  late int quantity;
  @HiveField(7)  late String vendorId;
  @HiveField(8)  late String vendorName;
  @HiveField(9)  late DateTime createdAt;
  @HiveField(10) late DateTime updatedAt;
  @HiveField(11) String? notes;
  @HiveField(12) late String transactionType; // 'in' | 'out'
  @HiveField(13) late double totalValue;
  @HiveField(14) late bool isActive;
  @HiveField(15) String? tag;

  StockEntry({
    required this.id,
    required this.name,
    required this.category,
    required this.karat,
    required this.weightGrams,
    required this.pricePerGram,
    required this.quantity,
    required this.vendorId,
    required this.vendorName,
    required this.createdAt,
    required this.updatedAt,
    required this.transactionType,
    this.notes,
    this.isActive = true,
    this.tag,
  }) : totalValue = weightGrams * pricePerGram * quantity;

  double get totalWeight => weightGrams * quantity;

  StockEntry copyWith({
    String? name, String? category, String? karat,
    double? weightGrams, double? pricePerGram, int? quantity,
    String? vendorId, String? vendorName, String? notes,
    String? transactionType, bool? isActive, String? tag,
  }) =>
      StockEntry(
        id: id,
        name: name ?? this.name,
        category: category ?? this.category,
        karat: karat ?? this.karat,
        weightGrams: weightGrams ?? this.weightGrams,
        pricePerGram: pricePerGram ?? this.pricePerGram,
        quantity: quantity ?? this.quantity,
        vendorId: vendorId ?? this.vendorId,
        vendorName: vendorName ?? this.vendorName,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
        notes: notes ?? this.notes,
        transactionType: transactionType ?? this.transactionType,
        isActive: isActive ?? this.isActive,
        tag: tag ?? this.tag,
      );

  Map<String, dynamic> toMap() => {
    'ID': id, 'Name': name, 'Category': category, 'Karat': karat,
    'Weight (g)': weightGrams, 'Price/g': pricePerGram, 'Quantity': quantity,
    'Vendor': vendorName, 'Type': transactionType,
    'Total Value': totalValue, 'Date': createdAt.toIso8601String(),
    'Notes': notes ?? '',
  };
}
