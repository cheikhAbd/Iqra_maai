import 'dart:convert';

import 'package:get/get.dart';
import 'package:iqra_maai/src/data/models/user.dart';
import '../data/repositories/user_repository.dart';
import '../services/user_service.dart';

class UserController extends GetxController {
  final UserService _userService = Get.put(UserService(), permanent: true);
  // final AuthController _authController = Get.put(AuthController());
  final UserRepository _userRepository = UserRepository();
  var users = <User>[].obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  var isLoading = false.obs;

  @override
  onInit() {
    super.onInit();
    loadCurrentUserStream();
    ever(currentUser, (user) {
      if (user != null) {
        printInfo(info: "Utilisateur chargé : ${user.id}");
        // printInfo(info: "Utilisateur chargé : ${_authController.accessToken.value}");
      } else {
        printInfo(info: "Aucun utilisateur connecté.");
      }
    });
  }

  // Méthode de type Stream qui écoute le chargement de l'utilisateur depuis le stockage local
  Stream<User?> loadUserFromLocalStorage() async* {
    final User? savedUser = await _userRepository.loadUser("currentUser");

    if (savedUser != null) {
      yield savedUser; // Émettre l'utilisateur trouvé
    } else {
      yield null; // Si aucun utilisateur n'est trouvé, émettre null
    }
  }

  /// Méthode pour charger l'utilisateur et démarrer le flux
  void loadCurrentUserStream() {
    loadUserFromLocalStorage().listen((user) {
      if (user != null) {
        currentUser.value = user;
      } else {
        currentUser.value = null; // Aucun utilisateur trouvé
      }
    });
  }

  Future<User?> loadUserFromLocal() async {
    try {
      return _userRepository.get(currentUser.value!.id);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user: $e');
      return null;
    }
  }

  Future<void> fetchUsers({int page = 1, int perPage = 5}) async {
    try {
      isLoading.value = true;

      // Récupérer les données de l'API
      final userList =
          await _userService.getUsers(page: page, perPage: perPage);

      // Convertir les données en objets User
      users.value = userList.map((userMap) => User.fromMap(userMap)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserById(int userId) async {
    try {
      isLoading.value = true;
      final userMap =
          await _userService.getUserById(userId); // Map<String, dynamic>
      currentUser.value = User.fromMap(userMap); // Convertir en User
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserByUsername(String username) async {
    try {
      isLoading.value = true;
      final userMap = await _userService.getUserByUsername(username);

      // Debugging: Afficher les données renvoyées
      printInfo(info: 'userMap: $userMap'); // Vérifier la structure des données

      // Si 'purchase_history' est une chaîne JSON, il faut la décoder
      if (userMap['purchase_history'] is String) {
        userMap['purchase_history'] = jsonDecode(userMap['purchase_history']);
      }

      // Convertir en objet User
      currentUser.value = User.fromMap(userMap);
    } catch (e) {
      Get.snackbar('Error', "Something went wrong in");
      printInfo(info: "-------------- $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<User?> fetchUserByPhone(String phone) async {
    try {
      isLoading.value = true;
      final userMap = await _userService.getUserByPhone(phone);

      if (userMap != null) {
        // Debugging: Afficher les données renvoyées
        printInfo(
            info: 'userMap: $userMap'); // Vérifier la structure des données

        // Si 'purchase_history' est une chaîne JSON, il faut la décoder
        if (userMap['purchase_history'] is String) {
          userMap['purchase_history'] = jsonDecode(userMap['purchase_history']);
        }

        // Convertir en objet User
        return User.fromMap(userMap);
      }else{
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', "Something Went Wrong :)");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
    try {
      isLoading.value = true;
      final response = await _userService.updateUser(userId, userData);
      Get.snackbar('Success', response['message']);
      Get.offAllNamed("/login");
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      isLoading.value = true;
      await _userService.deleteUser(userId);
      Get.snackbar('Success', 'User deleted successfully');
      fetchUsers(); // Refresh user list after deletion
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
