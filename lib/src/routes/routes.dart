import 'package:get/get.dart';
import 'package:iqra_maai/src/views/auth/forget_password.dart';
import 'package:iqra_maai/src/views/auth/login_screen.dart';
import 'package:iqra_maai/src/views/auth/register_screen.dart';
import 'package:iqra_maai/src/views/auth/verfiy_otp.dart';
import 'package:iqra_maai/src/views/home_page.dart';
import 'package:iqra_maai/src/views/main_tab/cart_screen.dart';
import 'package:iqra_maai/src/views/onboarding/onboarding_view.dart';
import 'package:iqra_maai/src/views/onboarding/welcome_view.dart';

import '../views/main_tab/menu_screen.dart';
import '../views/main_tab/profil_screen.dart';
import '../views/main_tab/search_screen.dart';

final routes = [
  GetPage(
    name: '/on_boarding',
    page: () => const OnboardingView(),
  ),
  GetPage(
    name: '/welcome_view',
    page: () => const WelcomeView(),
    // middlewares: [NavigationState()],
  ),
  GetPage(
    name: '/login',
    page: () => LoginScreen(),
    // middlewares: [NavigationState()],
  ),
  GetPage(
    name: '/register',
    page: () => RegisterScreen(),
    // middlewares: [NavigationState()],
  ),
  GetPage(
    name: '/verfiy_otp',
    page: () => VerfiyOtpScreen(),
    // middlewares: [NavigationState()],
  ),
  GetPage(
    name: '/home',
    page: () => HomePage(),
    // middlewares: [NavigationState()],
  ),
  GetPage(
    name: '/forget_password',
    page: () => ForgetPassword(),
    // middlewares: [NavigationState()],
  ),
  GetPage(name: '/search', page: () => SearchScreen()),
  GetPage(name: '/menu', page: () => MenuScreen()),
  GetPage(name: '/profile', page: () => ProfilScreen()),
  GetPage(name: '/cart', page: () => CartScreen()),
];
