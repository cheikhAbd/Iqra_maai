import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/color_extension.dart';
import '../../common_widgets/round_button.dart';
import '../../common_widgets/round_text_field.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: TColor.primary,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Text(
                'Sign In',
                style: TextStyle(
                    fontSize: 30,
                    color: TColor.text,
                    fontWeight: FontWeight.w700),
              ),
              RoundTextField(
                controller: _authController
                    .usernameController, // Utilisez le contrôleur correct
                hintText: "User Name",
              ),
              RoundTextField(
                controller: _authController
                    .passwordController, // Utilisez le contrôleur correct
                hintText: "Password",
                obscureText: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.toNamed('/forget_password');
                      },
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                          fontSize: 15,
                          color: TColor.subTitle.withValues(alpha: 0.3),
                        ),
                      ))
                ],
              ),
              RoundLineButton(
                  onPressed: () {
                    _authController.login(
                        _authController.usernameController.text,
                        _authController.passwordController.text);
                  },
                  textOfButton: "Sign In")
            ],
          ),
        ),
      ),
    );
  }
}
