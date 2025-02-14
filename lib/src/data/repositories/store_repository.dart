import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/store.dart';

class StoreRepository {
  static const String boxName = 'stores';

  Future<Box<Store>> get _box async => await Hive.openBox<Store>(boxName);

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      // Enregistrez les adaptateurs
      Hive.registerAdapter(StoreAdapter());
    }
  }

  // Create
  Future<Store> create(Store store) async {
    final box = await _box;
    await box.put(store.id, store);
    return store;
  }

  // Read
  Future<Store?> get(int id) async {
    final box = await _box;
    return box.get(id);
  }

  Future<List<Store>> getAll() async {
    final box = await _box;
    return box.values.toList();
  }

  // Update
  Future<Store> update(Store store) async {
    final box = await _box;
    await box.put(store.id, store);
    return store;
  }

  // Delete
  Future<void> delete(String id) async {
    final box = await _box;
    await box.delete(id);
  }
}