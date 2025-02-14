import 'package:hive/hive.dart';
import 'book.dart';
import 'user.dart';

part 'notes.g.dart';

@HiveType(typeId: 3)
class Notes {
  @HiveField(0)
  int id;

  @HiveField(1)
  String text;

  @HiveField(2)
  int pageNumber;

  @HiveField(3)
  DateTime dateCreated;

  @HiveField(4)
  String bookId;

  @HiveField(5)
  String userId;

  @HiveField(6)
  Book book;

  @HiveField(7)
  User user;

  Notes({
    this.id = 0,
    this.text = '',
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
      'text': text,
      'page_number': pageNumber,
      'date_created': dateCreated.toIso8601String(),
      'book_id': bookId,
      'user_id': userId,
      'book': book.toMap(),
      'user': user.toMap(),
    };
  }

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      id: map['id']?? 0,
      text: map['text'] ?? '',
      pageNumber: map['page_number'] ?? 0,
      dateCreated: DateTime.tryParse(map['date_created'] ?? '') ?? DateTime.now(),
      bookId: map['book_id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      book: map['book'] != null ? Book.fromMap(map['book']) : null,
      user: map['user'] != null ? User.fromMap(map['user']) : null,
    );
  }
}