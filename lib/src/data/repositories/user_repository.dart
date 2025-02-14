import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';

class UserRepository {
  static const String boxName = 'users';

  Future<Box<User>> get _box async => await Hive.openBox<User>(boxName);

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      // Enregistrez les adaptateurs
      Hive.registerAdapter(UserAdapter());
    }
  }

  // Create a new logged user
  Future<void> saveUser(String name, User user) async {
    final box = await _box;
    await box.put(name, user); // Utilisez l'uid comme clé
  }

  // Read
  Future<User?> get(int id) async {
    final box = await _box;
    return box.get(id);
  }

  // Load a current user
  Future<User?> loadUser(String name) async {
    final box = await _box;
    return box.get(name); // Retourne l'utilisateur si trouvé
  }

  Future<List<User>> getAll() async {
    final box = await _box;
    return box.values.toList();
  }

  // Update
  Future<User> update(User user) async {
    final box = await _box;
    await box.put(user.id, user);
    return user;
  }

  // Delete
  Future<void> delete(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  // Custom queries
  // Future<User?> findByUsername(String username) async {
  //   final box = await _box;
  //   return box.values.firstWhere(
  //     (user) => user.username == username,
  //     orElse: () => null,
  //   );
  // }

  // Future<User?> findByEmail(String email) async {
  //   final box = await _box;
  //   return box.values.firstWhere(
  //     (user) => user.email == email,
  //     orElse: () => null,
  //   );
  // }

  // Future<User?> findByPhone(String phone) async {
  //   final box = await _box;
  //   return box.values.firstWhere(
  //     (user) => user.phone == phone,
  //     orElse: () => null,
  //   );
  // }
}