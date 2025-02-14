import 'package:hive/hive.dart';
import 'book.dart';
import 'user.dart';

part 'bookmark.g.dart';

@HiveType(typeId: 4)
class Bookmark {
  @HiveField(0)
  int id;

  @HiveField(1)
  int pageNumber;

  @HiveField(2)
  DateTime dateCreated;

  @HiveField(3)
  String bookId;

  @HiveField(4)
  String userId;

  @HiveField(5)
  Book book;

  @HiveField(6)
  User user;

  Bookmark({
    this.id = 0,
    this.pageNumber = 0,
    DateTime? dateCreated,
    this.bookId = '',
    this.userId = '',
    Book? book,
    User? user,
  }) : 
    dateCreated = dateCreated ?? DateTime.now(),
    book = book ?? Book(),
    user = user ?? User();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'page_number': pageNumber,
      'date_created': dateCreated.toIso8601String(),
      'book_id': bookId,
      'user_id': userId,
      'book': book.toMap(),
      'user': user.toMap(),
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'] ?? 0,
      pageNumber: map['page_number'] ?? 0,
      dateCreated: DateTime.tryParse(map['date_created'] ?? '') ?? DateTime.now(),
      bookId: map['book_id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      book: map['book'] != null ? Book.fromMap(map['book']) : null,
      user: map['user'] != null ? User.fromMap(map['user']) : null,
    );
  }
}