import 'package:hive/hive.dart';
import 'category.dart';
import 'bookmark.dart';
import 'notes.dart';
import 'user.dart';

part 'book.g.dart';

@HiveType(typeId: 8)
class Book {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String author;

  @HiveField(3)
  String genre;

  @HiveField(4)
  DateTime publicationDate;

  @HiveField(5)
  String isbn;

  @HiveField(6)
  String? coverImage;

  @HiveField(7)
  String? description;

  @HiveField(8)
  String? fileUrl;

  @HiveField(9)
  double price;

  @HiveField(10)
  int? nbrPage;

  @HiveField(11)
  double? popularity;

  @HiveField(12)
  bool reading;

  @HiveField(13)
  int? nbrChapter;

  @HiveField(14)
  String? language;

  @HiveField(15)
  String? publisher;

  @HiveField(16)
  String? fileFormat;

  @HiveField(17)
  double? fileSize;

  @HiveField(18)
  String? storeId;

  @HiveField(19)
  String? libraryId;

  @HiveField(20)
  String? tags;

  @HiveField(21)
  List<Notes> notes;

  @HiveField(22)
  List<Bookmark> bookmarks;

  @HiveField(23)
  List<User> users;

  @HiveField(24)
  List<Category> categories;

  Book({
    this.id = 0,
    this.title = '',
    this.author = '',
    this.genre = '',
    DateTime? publicationDate,
    this.isbn = '',
    this.coverImage,
    this.description,
    this.fileUrl,
    this.price = 0.0,
    this.nbrPage,
    this.popularity,
    this.reading = false,
    this.nbrChapter,
    this.language,
    this.publisher,
    this.fileFormat,
    this.fileSize,
    this.storeId,
    this.libraryId,
    this.tags,
    List<Notes>? notes,
    List<Bookmark>? bookmarks,
    List<User>? users,
    List<Category>? categories,
  }) : 
    publicationDate = publicationDate ?? DateTime.now(),
    notes = notes ?? [],
    bookmarks = bookmarks ?? [],
    users = users ?? [],
    categories = categories ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'publication_date': publicationDate.toIso8601String(),
      'isbn': isbn,
      'cover_image': coverImage,
      'description': description,
      'file_url': fileUrl,
      'price': price,
      'nbr_page': nbrPage,
      'popularity': popularity,
      'reading': reading,
      'nbr_chapter': nbrChapter,
      'language': language,
      'publisher': publisher,
      'file_format': fileFormat,
      'file_size': fileSize,
      'store_id': storeId,
      'library_id': libraryId,
      'tags': tags,
      'notes': notes.map((note) => note.toMap()).toList(),
      'bookmarks': bookmarks.map((bookmark) => bookmark.toMap()).toList(),
      'users': users.map((user) => user.toMap()).toList(),
      'categories': categories.map((category) => category.toMap()).toList(),
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      genre: map['genre'] ?? '',
      publicationDate: DateTime.tryParse(map['publication_date'] ?? '') ?? DateTime.now(),
      isbn: map['isbn'] ?? '',
      coverImage: map['cover_image'],
      description: map['description'],
      fileUrl: map['file_url'],
      price: (map['price'] ?? 0.0).toDouble(),
      nbrPage: map['nbr_page'],
      popularity: map['popularity']?.toDouble(),
      reading: map['reading'] ?? false,
      nbrChapter: map['nbr_chapter'],
      language: map['language'],
      publisher: map['publisher'],
      fileFormat: map['file_format'],
      fileSize: map['file_size']?.toDouble(),
      storeId: map['store_id']?.toString(),
      libraryId: map['library_id']?.toString(),
      tags: map['tags'],
      notes: (map['notes'] as List?)?.map((note) => Notes.fromMap(note)).toList() ?? [],
      bookmarks: (map['bookmarks'] as List?)?.map((bookmark) => Bookmark.fromMap(bookmark)).toList() ?? [],
      users: (map['users'] as List?)?.map((user) => User.fromMap(user)).toList() ?? [],
      categories: (map['categories'] as List?)?.map((category) => Category.fromMap(category)).toList() ?? [],
    );
  }
}