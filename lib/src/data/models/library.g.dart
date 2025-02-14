// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LibraryAdapter extends TypeAdapter<Library> {
  @override
  final int typeId = 5;

  @override
  Library read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Library(
      id: fields[0] as int,
      books: (fields[1] as List?)?.cast<Book>(),
      lastAccessed: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Library obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.books)
      ..writeByte(2)
      ..write(obj.lastAccessed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
