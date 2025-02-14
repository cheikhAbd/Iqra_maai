import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iqra_maai/src/common/color_extension.dart';
import 'package:iqra_maai/src/common_widgets/round_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "lib/src/assets/images/background1.jpg",
            width: Get.width,
            height: Get.height,
            fit: BoxFit.fill,
          ),
          SafeArea(
            child: Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Column(
                spacing: 10,
                children: [
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  Text(
                    "Books For\nEvery Taste",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: TColor.primary,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RoundButton(
                      onPressed: () {
                        Get.toNamed('/login');
                      },
                      textOfButton: "Sign In"),
                  SizedBox(
                    height: 10,
                  ),
                  RoundButton(
                      onPressed: () {
                        Get.toNamed('/register');
                      },
                      textOfButton: "Sign Up"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
