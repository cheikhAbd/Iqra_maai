import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/notes.dart';

class NotesRepository {
  static const String boxName = 'Notess';

  Future<Box<Notes>> get _box async => await Hive.openBox<Notes>(boxName);

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      // Enregistrez les adaptateurs
      Hive.registerAdapter(NotesAdapter());
    }
  }

  // Create
  Future<Notes> create(Notes notes) async {
    final box = await _box;
    await box.put(notes.id, notes);
    return notes;
  }

  // Read
  Future<Notes?> get(int id) async {
    final box = await _box;
    return box.get(id);
  }

  Future<List<Notes>> getAll() async {
    final box = await _box;
    return box.values.toList();
  }

  // Update
  Future<Notes> update(Notes notes) async {
    final box = await _box;
    await box.put(notes.id, notes);
    return notes;
  }

  // Delete
  Future<void> delete(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  // Custom queries
  Future<List<Notes>> findByUserId(String userId) async {
    final box = await _box;
    return box.values.where((notes) => notes.userId == userId).toList();
  }

  Future<List<Notes>> findByBookId(String bookId) async {
    final box = await _box;
    return box.values.where((notes) => notes.bookId == bookId).toList();
  }
}