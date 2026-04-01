// GENERATED CODE – DO NOT MODIFY BY HAND
part of 'stock_entry.dart';

class StockEntryAdapter extends TypeAdapter<StockEntry> {
  @override final int typeId = 0;

  @override
  StockEntry read(BinaryReader reader) {
    final n = reader.readByte();
    final f = <int, dynamic>{for (int i = 0; i < n; i++) reader.readByte(): reader.read()};
    return StockEntry(
      id: f[0] as String,
      name: f[1] as String,
      category: f[2] as String,
      karat: f[3] as String,
      weightGrams: f[4] as double,
      pricePerGram: f[5] as double,
      quantity: f[6] as int,
      vendorId: f[7] as String,
      vendorName: f[8] as String,
      createdAt: f[9] as DateTime,
      updatedAt: f[10] as DateTime,
      notes: f[11] as String?,
      transactionType: f[12] as String,
      isActive: f[14] as bool? ?? true,
      tag: f[15] as String?,
    )..totalValue = f[13] as double;
  }

  @override
  void write(BinaryWriter writer, StockEntry obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.name)
      ..writeByte(2)..write(obj.category)
      ..writeByte(3)..write(obj.karat)
      ..writeByte(4)..write(obj.weightGrams)
      ..writeByte(5)..write(obj.pricePerGram)
      ..writeByte(6)..write(obj.quantity)
      ..writeByte(7)..write(obj.vendorId)
      ..writeByte(8)..write(obj.vendorName)
      ..writeByte(9)..write(obj.createdAt)
      ..writeByte(10)..write(obj.updatedAt)
      ..writeByte(11)..write(obj.notes)
      ..writeByte(12)..write(obj.transactionType)
      ..writeByte(13)..write(obj.totalValue)
      ..writeByte(14)..write(obj.isActive)
      ..writeByte(15)..write(obj.tag);
  }

  @override int get hashCode => typeId.hashCode;
  @override bool operator ==(Object other) =>
      other is StockEntryAdapter && typeId == other.typeId;
}
