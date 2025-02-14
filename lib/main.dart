import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iqra_maai/src/common/color_extension.dart';
import 'package:iqra_maai/src/controllers/auth_controller.dart';
import 'package:iqra_maai/src/controllers/user_controller.dart';
import 'package:iqra_maai/src/data/repositories/book_repository.dart';
import 'package:iqra_maai/src/data/repositories/bookmark_repository.dart';
import 'package:iqra_maai/src/data/repositories/category_repository.dart';
import 'package:iqra_maai/src/data/repositories/library_repository.dart';
import 'package:iqra_maai/src/data/repositories/note_repository.dart';
import 'package:iqra_maai/src/data/repositories/otp_repository.dart';
import 'package:iqra_maai/src/data/repositories/store_repository.dart';
import 'package:iqra_maai/src/data/repositories/token_repository.dart';
import 'package:iqra_maai/src/data/repositories/user_repository.dart';
import 'package:iqra_maai/src/l10n/translation_service.dart';
import 'package:iqra_maai/src/routes/routes.dart';
import 'package:iqra_maai/src/views/home_page.dart';
import 'package:iqra_maai/src/views/onboarding/onboarding_view.dart';

import 'src/data/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Future.delayed(Duration(seconds: 30), () {
    FlutterNativeSplash.remove();
  });

  // Initialisation de Hive
  await Hive.initFlutter();

  // Initialiser Hive correctement avec appel de méthode
  await UserRepository().init();
  await TokenRepository().init();
  await BookRepository().init();
  await BookmarkRepository().init();
  await StoreRepository().init();
  await LibraryRepository().init();
  await NotesRepository().init();
  await OtpVerificationRepository().init();
  await CategoryRepository().init();

  // Initialisation de la langue avec TranslationService
  TranslationService().setInitialLocale();

  Get.put(AuthController(), permanent: true);

  runApp(MyApp());

  // FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Iqra Maai',
      theme: ThemeData(primaryColor: TColor.primary, fontFamily: 'SF Pro Text'),
      translations: TranslationService(),
      locale: Get.deviceLocale, // Locale initiale
      fallbackLocale: TranslationService.fallbackLocale, // Locale par défaut
      // initialRoute: '/on_boarding',
      getPages: routes,
      home: AuthStreamWrapper(),
    );
  }
}

class AuthStreamWrapper extends StatelessWidget {
  AuthStreamWrapper({super.key});
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: _userController.loadUserFromLocalStorage(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              // Pendant le chargement, montrer un indicateur de chargement
              return Center(
                  child: CircularProgressIndicator(color: TColor.primary));
            }

            // Si un utilisateur est trouvé
            if (snapshot.hasData && snapshot.data != null) {
              AuthController authController = Get.put(AuthController());

              if (authController.accessToken.value.isNotEmpty) {
                return HomePage();
              } else {
                return OnboardingView();
              }
            }

            // Si l'utilisateur n'est pas trouvé, rediriger vers la page de connexion
          return OnboardingView();
          }),
    );
  }
}                 
