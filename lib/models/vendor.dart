import 'package:hive/hive.dart';

part 'vendor.g.dart';

@HiveType(typeId: 1)
class Vendor extends HiveObject {
  @HiveField(0)  late String id;
  @HiveField(1)  late String name;
  @HiveField(2)  late String phone;
  @HiveField(3)  String? email;
  @HiveField(4)  String? address;
  @HiveField(5)  late DateTime createdAt;
  @HiveField(6)  late double totalCredit;
  @HiveField(7)  late double totalDebit;
  @HiveField(8)  late bool isActive;
  @HiveField(9)  String? notes;
  @HiveField(10) String? gstNumber;

  Vendor({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address,
    required this.createdAt,
    this.totalCredit = 0.0,
    this.totalDebit = 0.0,
    this.isActive = true,
    this.notes,
    this.gstNumber,
  });

  double get balance => totalCredit - totalDebit;
  bool get hasDebt => balance < 0;
  bool get hasCredit => balance > 0;
  bool get isSettled => balance == 0;

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  Vendor copyWith({
    String? name, String? phone, String? email, String? address,
    bool? isActive, String? notes, String? gstNumber,
    double? totalCredit, double? totalDebit,
  }) =>
      Vendor(
        id: id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        address: address ?? this.address,
        createdAt: createdAt,
        totalCredit: totalCredit ?? this.totalCredit,
        totalDebit: totalDebit ?? this.totalDebit,
        isActive: isActive ?? this.isActive,
        notes: notes ?? this.notes,
        gstNumber: gstNumber ?? this.gstNumber,
      );

  Map<String, dynamic> toMap() => {
    'ID': id, 'Name': name, 'Phone': phone, 'Email': email ?? '',
    'Address': address ?? '', 'Credit': totalCredit, 'Debit': totalDebit,
    'Balance': balance, 'GST': gstNumber ?? '',
    'Joined': createdAt.toIso8601String(),
  };
}
