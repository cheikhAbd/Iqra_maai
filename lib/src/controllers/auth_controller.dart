import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iqra_maai/src/controllers/user_controller.dart';
import 'package:iqra_maai/src/data/models/token.dart';
import 'package:iqra_maai/src/data/repositories/token_repository.dart';
import 'package:iqra_maai/src/data/repositories/user_repository.dart';
import '../data/models/user.dart';
import '../services/auth_service.dart';
import 'nav_controllers.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.put(AuthService(), permanent: true);
  final UserController _userController =
      Get.put(UserController(), permanent: true);
  final NavigationController navigationController =
      Get.put(NavigationController());
  var accessToken = ''.obs;
  var refreshTokens = ''.obs;
  final TokenRepository _tokenRepository = TokenRepository();
  final UserRepository _userRepository = UserRepository();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final StreamController<String> _tokenStreamController =
      StreamController<String>.broadcast();
  Stream<String> get tokenStream => _tokenStreamController.stream;

  @override
  void onInit() {
    super.onInit();
    _loadTokensFromStorage();
  }

  // @override
  // void onClose() {
  //   _tokenStreamController
  //       .close(); // Fermer le StreamController
  //   super.onClose();
  // }

  // Charger les tokens depuis le stockage local
  Future<void> _loadTokensFromStorage() async {
    try {
      TokenModel? tokens = await _tokenRepository.getTokens();
      if (tokens != null) {
        accessToken.value = tokens.accessToken;
        refreshTokens.value = tokens.refreshToken;
      }
    } catch (e) {
      printInfo(
          info: "Erreur lors du chargement des tokens depuis le stockage : $e");
    }
  }

  Future<void> login(String username, String password) async {
    try {
      _userController.fetchUserByUsername(username);

      if (_userController.currentUser.value != null) {
        final response = await _authService.login(username, password);
        Get.snackbar("Success", "${response['message']}");

        Get.offNamed('/verfiy_otp');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      printInfo(info: e.toString());
    }
  }

  Future<void> verifyOtp(String code) async {
    try {
      if (_userController.currentUser.value != null) {
        final response = await _authService.verifyOtp(
            _userController.currentUser.value!.phone, code);

        accessToken.value = response['tokens']['access'];
        refreshTokens.value = response['tokens']['refresh'];
        TokenModel token = TokenModel(
            accessToken: accessToken.value, refreshToken: refreshTokens.value);
        _tokenRepository.saveTokens(token);
        _userRepository.saveUser(
            "currentUser", _userController.currentUser.value!);
        Get.snackbar("Success", "${response['message']}");
        startTokenRefresh();
        Get.offAllNamed('/home');
      } else {
        Get.snackbar("Error", "Something went wrong :) ");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> refreshToken() async {
    try {
      final newAccessToken =
          await _authService.refreshToken(refreshTokens.value);
      if (newAccessToken.isEmpty) throw Exception("Token rafraîchi vide");

      accessToken.value = newAccessToken;

      _tokenStreamController.add(newAccessToken); // Mettre à jour le stream

      _tokenRepository.updateAccessToken(newAccessToken);
    } catch (e) {
      printInfo(info: "Erreur lors du rafraîchissement du token -> $e");
    }
  }

  void startTokenRefresh() {
    if (_userController.currentUser.value == null || accessToken.isEmpty) {
      return;
    }

    // rafraîchir les tokens périodiquement
    Timer.periodic(Duration(minutes: 58), (_) async {
      if (_userController.currentUser.value != null && accessToken.isNotEmpty) {
        await refreshToken();
      }
      return;
    });
  }

  Future<void> logout() async {
    if (accessToken.value.isEmpty) {
      Get.snackbar("Error", "Token invalide ou inexistant.");
      return;
    }

    try {
      final message = await _authService.logout(accessToken.value);

      // Affichage d'un message de succès
      Get.snackbar("Success", message);

      // Supprimer les tokens et les informations utilisateur
      await _tokenRepository.deleteTokens();
      await _userRepository.delete("currentUser");
      _userController.currentUser.value = null;
      navigationController.selectedIndex.value = 0;

      // Rediriger vers l'écran d'accueil
      Get.offAllNamed('/on_boarding');
    } catch (e) {
      printInfo(info: "Erreur pendant la déconnexion ici: ${e.toString()}");
      Get.snackbar(
          "Error", "Une erreur s'est produite lors de la déconnexion.");
    }
  }

  // --------------------- Sign Up ----------------------------
  // Étape actuelle
  RxInt currentStep = 0.obs;

  // The Text editing controllers
  final TextEditingController fullName = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController otp = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confimPassword = TextEditingController();

  // Méthode pour passer à l'étape suivante
  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  // Méthode pour revenir à l'étape précédente
  void previousStep() {
    // L'utilisateur ne peut pas revenir à l'étape précédente après l'OTP
    if (currentStep.value > 0 && currentStep.value < 2) {
      currentStep.value--;
    }
  }

  // Méthode pour aller à une étape spécifique
  void goToStep(int step) {
    // if (step < 2 || (step == 2 && currentStep.value == 2)) {
    //   currentStep.value = step;
    // }
  }

  Future<void> registerUser() async {
    try {
      if (password.text == confimPassword.text) {
        User userData = User(
            fullName: fullName.text,
            username: userName.text,
            phone: phone.text,
            email: email.text,
            password: password.text,
            profileImage: "");

        // Créer un Map contenant les données de l'utilisateur et l'OTP
        Map<String, dynamic> registrationData = {
          ...userData
              .toMap(), // Déverse les données de l'utilisateur dans le nouveau Map
          "otp": otp.text, // Ajouter l'OTP
        };

        printInfo(info: "$registrationData");

        final response = await _authService.register(registrationData);
        Get.snackbar('Success', response['message']);
        Get.offNamed('/login');
      } else {
        Get.snackbar("Error", "The password must be matched");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> sendOTP() async {
    try {
      final response = await _authService.sendOTP(phone.text);
      Get.snackbar("Success", "${response['message']}");
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // ------------------------ Forget Password --------------
  Future<void> verfiyOtpResetPassword(String phone, String otp) async {
    final msg = await _authService.verifyOtpResetPassword(phone, otp);
    Get.snackbar("Success", "${msg['message']}");
  }
}
