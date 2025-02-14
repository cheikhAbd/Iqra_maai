import 'package:get/get.dart';
import 'package:iqra_maai/src/controllers/user_controller.dart';
import 'package:iqra_maai/src/views/onboarding/welcome_view.dart';
import '../controllers/auth_controller.dart';

class NavigationState extends GetMiddleware {
  final AuthController _authController = Get.put(AuthController(), permanent: true);
  final UserController _userController = Get.put(UserController(), permanent: true);

  @override
  GetPage<dynamic>? onPageCalled(GetPage<dynamic>? page) {
    // Vérifiez si l'utilisateur est connecté
    if (_authController.accessToken.isEmpty || _userController.currentUser.value == null) {
      // Si l'utilisateur n'est pas connecté, rediriger vers la page d'onboarding
      return GetPage(name: '/welcome_view', page: () => WelcomeView());
    }
    
    // Si l'utilisateur est connecté, vérifier si le token doit être rafraîchi
    if (_authController.accessToken.isNotEmpty) {
      _authController.refreshToken();
    }

    // Retourner la page demandée si tout est ok
    return super.onPageCalled(page);
  }

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    // Si l'utilisateur n'a pas de token, le rediriger vers la page de login
    if (_authController.accessToken.isEmpty || _userController.currentUser.value == null) {
      return GetNavConfig.fromRoute('/on_boarding');
    }

    // Si le token existe, laisser passer la redirection
    return super.redirectDelegate(route);
  }
}