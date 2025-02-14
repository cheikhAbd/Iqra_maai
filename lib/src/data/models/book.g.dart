// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 8;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      id: fields[0] as int,
      title: fields[1] as String,
      author: fields[2] as String,
      genre: fields[3] as String,
      publicationDate: fields[4] as DateTime?,
      isbn: fields[5] as String,
      coverImage: fields[6] as String?,
      description: fields[7] as String?,
      fileUrl: fields[8] as String?,
      price: fields[9] as double,
      nbrPage: fields[10] as int?,
      popularity: fields[11] as double?,
      reading: fields[12] as bool,
      nbrChapter: fields[13] as int?,
      language: fields[14] as String?,
      publisher: fields[15] as String?,
      fileFormat: fields[16] as String?,
      fileSize: fields[17] as double?,
      storeId: fields[18] as String?,
      libraryId: fields[19] as String?,
      tags: fields[20] as String?,
      notes: (fields[21] as List?)?.cast<Notes>(),
      bookmarks: (fields[22] as List?)?.cast<Bookmark>(),
      users: (fields[23] as List?)?.cast<User>(),
      categories: (fields[24] as List?)?.cast<Category>(),
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.genre)
      ..writeByte(4)
      ..write(obj.publicationDate)
      ..writeByte(5)
      ..write(obj.isbn)
      ..writeByte(6)
      ..write(obj.coverImage)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.fileUrl)
      ..writeByte(9)
      ..write(obj.price)
      ..writeByte(10)
      ..write(obj.nbrPage)
      ..writeByte(11)
      ..write(obj.popularity)
      ..writeByte(12)
      ..write(obj.reading)
      ..writeByte(13)
      ..write(obj.nbrChapter)
      ..writeByte(14)
      ..write(obj.language)
      ..writeByte(15)
      ..write(obj.publisher)
      ..writeByte(16)
      ..write(obj.fileFormat)
      ..writeByte(17)
      ..write(obj.fileSize)
      ..writeByte(18)
      ..write(obj.storeId)
      ..writeByte(19)
      ..write(obj.libraryId)
      ..writeByte(20)
      ..write(obj.tags)
      ..writeByte(21)
      ..write(obj.notes)
      ..writeByte(22)
      ..write(obj.bookmarks)
      ..writeByte(23)
      ..write(obj.users)
      ..writeByte(24)
      ..write(obj.categories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
