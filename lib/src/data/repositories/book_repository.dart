import 'package:hive/hive.dart';
import '../models/book.dart';
import 'package:path_provider/path_provider.dart';

class BookRepository {
  static const String boxName = 'books';

  Future<Box<Book>> get _box async => await Hive.openBox<Book>(boxName);

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      // Enregistrez les adaptateurs
      Hive.registerAdapter(BookAdapter());
    }
  }

  // Create
  Future<Book> create(Book book) async {
    final box = await _box;
    await box.put(book.id, book);
    return book;
  }

  // Read
  Future<Book?> get(String id) async {
    final box = await _box;
    return box.get(id);
  }

  Future<List<Book>> getAll() async {
    final box = await _box;
    return box.values.toList();
  }

  // Update
  Future<Book> update(Book book) async {
    final box = await _box;
    await box.put(book.id, book);
    return book;
  }

  // Delete
  Future<void> delete(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  // Custom queries
  // Future<List<Book>> findByAuthor(String author) async {
  //   final box = await _box;
  //   return box.values.where((book) => book.author == author).toList();
  // }

  // Future<List<Book>> findByGenre(String genre) async {
  //   final box = await _box;
  //   return box.values.where((book) => book.genre == genre).toList();
  // }

  // Future<Book?> findByIsbn(String isbn) async {
  //   final box = await _box;
  //   return box.values.firstWhere(
  //     (book) => book.isbn == isbn,
  //     orElse: () => null,
  //   );
  // }
}