import 'package:hive/hive.dart';
import 'book.dart';

part 'store.g.dart';

@HiveType(typeId: 6)
class Store {
  @HiveField(0)
  int id;

  @HiveField(1)
  List<Book> availableBooks;

  @HiveField(2)
  String? promotions;

  @HiveField(3)
  String? userReviews;

  @HiveField(4)
  String? bestSellers;

  @HiveField(5)
  String? newReleases;

  Store({
    this.id = 0,
    List<Book>? availableBooks,
    this.promotions,
    this.userReviews,
    this.bestSellers,
    this.newReleases,
  }) : availableBooks = availableBooks ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'available_books': availableBooks.map((book) => book.toMap()).toList(),
      'promotions': promotions,
      'user_reviews': userReviews,
      'best_sellers': bestSellers,
      'new_releases': newReleases,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id']?? 0,
      availableBooks: (map['available_books'] as List?)?.map((book) => Book.fromMap(book)).toList() ?? [],
      promotions: map['promotions'],
      userReviews: map['user_reviews'],
      bestSellers: map['best_sellers'],
      newReleases: map['new_releases'],
    );
  }
}