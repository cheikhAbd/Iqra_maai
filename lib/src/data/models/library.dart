import 'package:hive/hive.dart';
import 'book.dart';

part 'library.g.dart';

@HiveType(typeId: 5)
class Library {
  @HiveField(0)
  int id;

  @HiveField(1)
  List<Book> books;

  @HiveField(2)
  DateTime lastAccessed;

  Library({
    this.id = 0,
    List<Book>? books,
    DateTime? lastAccessed,
  }) : 
    books = books ?? [],
    lastAccessed = lastAccessed ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'books': books.map((book) => book.toMap()).toList(),
      'last_accessed': lastAccessed.toIso8601String(),
    };
  }

  factory Library.fromMap(Map<String, dynamic> map) {
    return Library(
      id: map['id'] ?? 0,
      books: (map['books'] as List?)?.map((book) => Book.fromMap(book)).toList() ?? [],
      lastAccessed: DateTime.tryParse(map['last_accessed'] ?? '') ?? DateTime.now(),
    );
  }
}