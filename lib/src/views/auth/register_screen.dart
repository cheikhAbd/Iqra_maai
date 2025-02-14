import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iqra_maai/src/controllers/auth_controller.dart';
import 'package:iqra_maai/src/controllers/user_controller.dart';

import '../../common/color_extension.dart';
import '../../data/models/user.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final AuthController _authController = Get.find<AuthController>();
  final UserController _userController = Get.put(UserController());

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
            color: Colors.blue, // Couleur de votre choix
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Sign Up',
              style: TextStyle(
                  fontSize: 30,
                  color: TColor.text,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: Obx(() {
              return Stepper(
                physics: ScrollPhysics(),
                currentStep: _authController.currentStep.value,
                onStepTapped: (step) => _authController.goToStep(step),
                onStepContinue: () async{
                  

                  if (_authController.currentStep.value == 3) {
                    // Si c'est la dernière étape, afficher les données dans la console
                    await _authController.registerUser();
                  } else if (_authController.currentStep.value == 1) {
                    User? userMap = await _userController.fetchUserByPhone(_authController.phone.text);
                    if (userMap == null){
                      await _authController.sendOTP();
                    _authController.nextStep();
                    }else{
                      Get.snackbar('Error', "User already exist");
                    }
                    
                  } else {
                    _authController.nextStep();
                  }
                },
                onStepCancel: _authController.previousStep,
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      spacing: 15,
                      children: [
                        if (_authController.currentStep.value == 1)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: Text('Back'),
                          ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text(
                            _authController.currentStep.value == 3
                                ? 'Register'
                                : 'Continue',
                          ),
                        ),
                      ],
                    ),
                  );
                },
                steps: [
                  Step(
                    title: Text("Personal"),
                    content: Column(
                      children: [
                        TextField(
                          controller: _authController.fullName,
                          decoration: InputDecoration(labelText: "Full name"),
                        ),
                        TextField(
                          controller: _authController.userName,
                          decoration: InputDecoration(labelText: "User name"),
                        ),
                      ],
                    ),
                    isActive: _authController.currentStep.value >= 0,
                    state: _authController.currentStep.value > 0
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: Text("Account"),
                    content: Column(
                      children: [
                        TextField(
                          controller: _authController.email,
                          decoration: InputDecoration(labelText: "Email"),
                        ),
                        TextField(
                          controller: _authController.phone,
                          decoration: InputDecoration(labelText: "Phone"),
                        ),
                      ],
                    ),
                    isActive: _authController.currentStep.value >= 1,
                    state: _authController.currentStep.value > 1
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: Text("OTP Verification"),
                    content: Column(
                      children: [
                        TextField(
                          controller: _authController.otp,
                          decoration: InputDecoration(labelText: "OTP"),
                        ),
                      ],
                    ),
                    isActive: _authController.currentStep.value >= 2,
                    state: _authController.currentStep.value > 2
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: Text("Password"),
                    content: Column(
                      children: [
                        TextField(
                          controller: _authController.password,
                          decoration: InputDecoration(labelText: "Password"),
                          obscureText: true,
                        ),
                        TextField(
                          controller: _authController.confimPassword,
                          decoration:
                              InputDecoration(labelText: "Confirm Password"),
                          obscureText: true,
                        ),
                      ],
                    ),
                    isActive: _authController.currentStep.value >= 3,
                    state: _authController.currentStep.value == 3
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

