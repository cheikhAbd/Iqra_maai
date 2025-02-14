import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  // Observable pour suivre l'index de la page actuelle
  RxInt currentPageIndex = 0.obs;

  // Liste des pages
  List pageArr = [
      {
        "title": "Welcome to the\n'Read with me' app",
        "sub_title":
            "Your first destination for the world of books and knowledge! 🌟",
        "img": "lib/src/assets/images/on_1.jpg"
      },
      {
        "title": "Treasure International Books in Mauritania",
        "sub_title":
            "Literature without Borders : Your Library Your Gateway to th World ",
        "img": "lib/src/assets/images/on_2.png"
      },
      {
        "title": "The search for rare literary treasures has become easier",
        "sub_title": "Heritage Revival : Old Book Restoration Services",
        "img": "lib/src/assets/images/on_3.jpg"
      },
    ];

  // Méthode pour mettre à jour l'index de la page
  void updatePageIndex(int index) {
    currentPageIndex.value = index;
  }


  // Méthode pour passer à la page suivante
  void nextPage(PageController pageController ) {
    if (currentPageIndex.value < pageArr.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed('/welcome_view'); // Redirige vers WelcomeView après la dernière page
    }
  }

  // Méthode pour sauter directement à WelcomeView
  void skipToWelcome() {
    Get.offAllNamed('/welcome_view');
  } 
}