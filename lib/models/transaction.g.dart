// GENERATED CODE – DO NOT MODIFY BY HAND
part of 'transaction.dart';

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override final int typeId = 2;

  @override
  Transaction read(BinaryReader reader) {
    final n = reader.readByte();
    final f = <int, dynamic>{for (int i = 0; i < n; i++) reader.readByte(): reader.read()};
    return Transaction(
      id: f[0] as String,
      vendorId: f[1] as String,
      vendorName: f[2] as String,
      type: f[3] as String,
      amount: f[4] as double,
      date: f[5] as DateTime,
      description: f[6] as String?,
      stockEntryId: f[7] as String?,
      paymentMode: f[8] as String,
      referenceNumber: f[9] as String?,
      createdAt: f[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.vendorId)
      ..writeByte(2)..write(obj.vendorName)
      ..writeByte(3)..write(obj.type)
      ..writeByte(4)..write(obj.amount)
      ..writeByte(5)..write(obj.date)
      ..writeByte(6)..write(obj.description)
      ..writeByte(7)..write(obj.stockEntryId)
      ..writeByte(8)..write(obj.paymentMode)
      ..writeByte(9)..write(obj.referenceNumber)
      ..writeByte(10)..write(obj.createdAt);
  }

  @override int get hashCode => typeId.hashCode;
  @override bool operator ==(Object other) =>
      other is TransactionAdapter && typeId == other.typeId;
}
