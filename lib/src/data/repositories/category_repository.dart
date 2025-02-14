import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/category.dart';

class CategoryRepository {
  static const String boxName = 'categories';

  Future<Box<Category>> get _box async => await Hive.openBox<Category>(boxName);

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      // Enregistrez les adaptateurs
      Hive.registerAdapter(CategoryAdapter());
    }
  }

  // Create
  Future<Category> create(Category category) async {
    final box = await _box;
    await box.put(category.id, category);
    return category;
  }

  // Read
  Future<Category?> get(String id) async {
    final box = await _box;
    return box.get(id);
  }

  Future<List<Category>> getAll() async {
    final box = await _box;
    return box.values.toList();
  }

  // Update
  Future<Category> update(Category category) async {
    final box = await _box;
    await box.put(category.id, category);
    return category;
  }

  // Delete
  Future<void> delete(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  // Custom queries
  // Future<Category?> findByName(String name) async {
  //   final box = await _box;
  //   return box.values.firstWhere(
  //     (category) => category.name == name,
  //     orElse: () => null,
  //   );
  // }
}