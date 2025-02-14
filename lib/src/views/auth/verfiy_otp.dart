import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iqra_maai/src/controllers/auth_controller.dart';

import '../../common/color_extension.dart';
import '../../common_widgets/round_button.dart';
import '../../common_widgets/round_text_field.dart';

class VerfiyOtpScreen extends StatelessWidget {
  VerfiyOtpScreen({super.key});
  // Edit controllers for OTP
  final TextEditingController phone = TextEditingController();
  final TextEditingController otp = TextEditingController();
  final AuthController _authController = Get.put(AuthController(), permanent: true);

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:  20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Text(
              'Verfiy OTP',
              style: TextStyle(
                  fontSize: 30,
                  color: TColor.text,
                  fontWeight: FontWeight.w700),
            ),
            // RoundTextField(
            //   controller: phone,
            //   hintText: "Phone Number",
            // ),
            RoundTextField(
              controller: otp,
              hintText: "OTP",
            ),
            RoundLineButton(
                onPressed: () {
                  _authController.verifyOtp(otp.text);
                },
                textOfButton: "Sign In")
          ],
        ),
      ),
    );
  }
}
