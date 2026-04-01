// GENERATED CODE – DO NOT MODIFY BY HAND
part of 'vendor.dart';

class VendorAdapter extends TypeAdapter<Vendor> {
  @override final int typeId = 1;

  @override
  Vendor read(BinaryReader reader) {
    final n = reader.readByte();
    final f = <int, dynamic>{for (int i = 0; i < n; i++) reader.readByte(): reader.read()};
    return Vendor(
      id: f[0] as String,
      name: f[1] as String,
      phone: f[2] as String,
      email: f[3] as String?,
      address: f[4] as String?,
      createdAt: f[5] as DateTime,
      totalCredit: f[6] as double? ?? 0.0,
      totalDebit: f[7] as double? ?? 0.0,
      isActive: f[8] as bool? ?? true,
      notes: f[9] as String?,
      gstNumber: f[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Vendor obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.name)
      ..writeByte(2)..write(obj.phone)
      ..writeByte(3)..write(obj.email)
      ..writeByte(4)..write(obj.address)
      ..writeByte(5)..write(obj.createdAt)
      ..writeByte(6)..write(obj.totalCredit)
      ..writeByte(7)..write(obj.totalDebit)
      ..writeByte(8)..write(obj.isActive)
      ..writeByte(9)..write(obj.notes)
      ..writeByte(10)..write(obj.gstNumber);
  }

  @override int get hashCode => typeId.hashCode;
  @override bool operator ==(Object other) =>
      other is VendorAdapter && typeId == other.typeId;
}
