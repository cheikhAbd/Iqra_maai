import 'package:hive/hive.dart';
import 'book.dart';
import 'bookmark.dart';
import 'notes.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  int id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  @HiveField(4)
  String phone;

  @HiveField(5)
  String role;

  @HiveField(6)
  String status;

  @HiveField(7)
  String fullName;

  @HiveField(8)
  String profileImage;

  @HiveField(9)
  String readingPreferences;

  @HiveField(10)
  Map<String, dynamic> purchaseHistory;

  @HiveField(11)
  List<Book> library;

  @HiveField(12)
  List<Bookmark> bookmarks;

  @HiveField(13)
  List<Notes> notes;

  User({
    this.id = 0,
    this.username = '',
    this.email = '',
    this.password = '',
    this.phone = '',
    this.role = 'user',
    this.status = 'active',
    this.fullName = "",
    this.profileImage = "",
    this.readingPreferences = "",
    this.purchaseHistory = const {},
    List<Book>? library,
    List<Bookmark>? bookmarks,
    List<Notes>? notes,
  }) : 
    library = library ?? [],
    bookmarks = bookmarks ?? [],
    notes = notes ?? [];

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
      // 'role': role,
      // 'status': status,
      'full_name': fullName,
      'profile_image': profileImage.isNotEmpty ? profileImage : null,
      // 'reading_preferences': readingPreferences,
      // 'purchase_history': purchaseHistory,
      // 'library': library.map((book) => book.toMap()).toList(),
      // 'bookmarks': bookmarks.map((bookmark) => bookmark.toMap()).toList(),
      // 'notes': notes.map((note) => note.toMap()).toList(),
    };
  }

  

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'user',
      status: map['status'] ?? 'active',
      fullName: map['full_name'] ?? '',
      profileImage: map['profile_image'] ?? '',
      readingPreferences: map['reading_preferences'] ?? '',
      purchaseHistory: map['purchase_history'] ?? {},
      library: (map['library'] as List?)?.map((book) => Book.fromMap(book)).toList() ?? [],
      bookmarks: (map['bookmarks'] as List?)?.map((bookmark) => Bookmark.fromMap(bookmark)).toList() ?? [],
      notes: (map['notes'] as List?)?.map((note) => Notes.fromMap(note)).toList() ?? [],
    );
  }
}