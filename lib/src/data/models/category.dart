import 'package:hive/hive.dart';
import 'book.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  double? popularity;

  @HiveField(4)
  List<Book> books;

  Category({
    this.id = 0,
    this.name = '',
    this.description,
    this.popularity,
    List<Book>? books,
  }) : books = books ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'popularity': popularity,
      'books': books.map((book) => book.toMap()).toList(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      popularity: map['popularity']?.toDouble(),
      books: (map['books'] as List?)?.map((book) => Book.fromMap(book)).toList() ?? [],
    );
  }
}