import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/library.dart';

class LibraryRepository {
  static const String boxName = 'libraries';

  Future<Box<Library>> get _box async => await Hive.openBox<Library>(boxName);

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      // Enregistrez les adaptateurs
      Hive.registerAdapter(LibraryAdapter());
    }
  }

  // Create
  Future<Library> create(Library library) async {
    final box = await _box;
    await box.put(library.id, library);
    return library;
  }

  // Read
  Future<Library?> get(int id) async {
    final box = await _box;
    return box.get(id);
  }

  Future<List<Library>> getAll() async {
    final box = await _box;
    return box.values.toList();
  }

  // Update
  Future<Library> update(Library library) async {
    final box = await _box;
    await box.put(library.id, library);
    return library;
  }

  // Delete
  Future<void> delete(String id) async {
    final box = await _box;
    await box.delete(id);
  }
}