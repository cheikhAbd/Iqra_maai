import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/bookmark.dart';


class BookmarkRepository {
  static const String boxName = 'bookmarks';

  Future<Box<Bookmark>> get _box async => await Hive.openBox<Bookmark>(boxName);


  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      // Enregistrez les adaptateurs
      Hive.registerAdapter(BookmarkAdapter());
    }
  }

  // Create
  Future<Bookmark> create(Bookmark bookmark) async {
    final box = await _box;
    await box.put(bookmark.id, bookmark);
    return bookmark;
  }

  // Read
  Future<Bookmark?> get(String id) async {
    final box = await _box;
    return box.get(id);
  }

  Future<List<Bookmark>> getAll() async {
    final box = await _box;
    return box.values.toList();
  }

  // Update
  Future<Bookmark> update(Bookmark bookmark) async {
    final box = await _box;
    await box.put(bookmark.id, bookmark);
    return bookmark;
  }

  // Delete
  Future<void> delete(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  // Custom queries
  Future<List<Bookmark>> findByUserId(String userId) async {
    final box = await _box;
    return box.values.where((bookmark) => bookmark.userId == userId).toList();
  }

  Future<List<Bookmark>> findByBookId(String bookId) async {
    final box = await _box;
    return box.values.where((bookmark) => bookmark.bookId == bookId).toList();
  }
}