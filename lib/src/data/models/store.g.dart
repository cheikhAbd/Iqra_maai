// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreAdapter extends TypeAdapter<Store> {
  @override
  final int typeId = 6;

  @override
  Store read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Store(
      id: fields[0] as int,
      availableBooks: (fields[1] as List?)?.cast<Book>(),
      promotions: fields[2] as String?,
      userReviews: fields[3] as String?,
      bestSellers: fields[4] as String?,
      newReleases: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Store obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.availableBooks)
      ..writeByte(2)
      ..write(obj.promotions)
      ..writeByte(3)
      ..write(obj.userReviews)
      ..writeByte(4)
      ..write(obj.bestSellers)
      ..writeByte(5)
      ..write(obj.newReleases);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
