import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/navigation_bar.dart';
import '../../controllers/auth_controller.dart';

class ProfilScreen extends StatelessWidget {
  ProfilScreen({super.key});

  final AuthController _authController = Get.put(AuthController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile "),
        actions: [
          IconButton(
              onPressed: () {
                _authController.logout();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text("Profile Page"),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}