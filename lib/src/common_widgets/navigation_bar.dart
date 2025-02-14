import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iqra_maai/src/common/color_extension.dart';
import '../controllers/nav_controllers.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar({super.key});

  final NavigationController navigationController =
      Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        selectedItemColor: TColor.primary,
        unselectedItemColor: Colors.grey[400],
        currentIndex: navigationController.selectedIndex.value,
        onTap: (index) {
          navigationController.changePage(index);
          Get.offAllNamed(
            index == 0
                ? '/home'
                : index == 1
                    ? '/search'
                    : index == 2
                        ? '/menu'
                        : '/cart',
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Whishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}
