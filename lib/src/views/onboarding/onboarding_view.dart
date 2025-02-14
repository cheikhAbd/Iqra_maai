import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iqra_maai/src/common/color_extension.dart';
import 'package:iqra_maai/src/controllers/welcome_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    WelcomeController welcomeController = Get.put(WelcomeController());
    final pageController = PageController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: welcomeController.pageArr.length,
              onPageChanged: (index) {
                welcomeController.updatePageIndex(index);
              },
              itemBuilder: (context, index) {
                var pObj = welcomeController.pageArr[index];
                return Container(
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                  child: Column(
                    children: [
                      Text(
                        pObj["title"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        pObj["sub_title"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TColor.primaryLight,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        pObj["img"],
                        width: Get.width * 0.8,
                        height: Get.height * 0.5,
                        fit: BoxFit.fitWidth,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              welcomeController.skipToWelcome();
                            },
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                color: TColor.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          SmoothPageIndicator(
                            controller: pageController,
                            count: welcomeController.pageArr.length,
                            effect: ExpandingDotsEffect(
                              activeDotColor: TColor.primary,
                              dotHeight: 8,
                              dotWidth: 8,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // if (welcomeController.currentPageIndex.value ==
                              //     welcomeController.pageArr.length - 1) {
                              //   Get.off(() => const WelcomeView());
                              // } else {
                              //   pageController.nextPage(
                              //     duration: const Duration(milliseconds: 300),
                              //     curve: Curves.easeInOut,
                              //   );
                              // }
                              welcomeController.nextPage(pageController);
                            },
                            child: Text(
                              "Next",
                              style: TextStyle(
                                color: TColor.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


/*
Scaffold(
      appBar: AppBar(
        title: Text('appTitle'.tr), // Utilisation de GetX pour traduire
        actions: [
          DropdownButton<String>(
            underline: SizedBox(),
            icon: Icon(Icons.language, color: Colors.white),
            items: TranslationService.langs.map((String lang) {
              return DropdownMenuItem<String>(
                value: lang,
                child: Text(lang),
              );
            }).toList(),
            onChanged: (String? lang) {
              if (lang != null) {
                TranslationService().changeLocale(lang);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Text('welcomeMessage'.tr), // Utilisation de GetX pour traduire
      ),
    );
*/