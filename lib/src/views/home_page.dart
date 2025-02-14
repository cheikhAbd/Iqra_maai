import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iqra_maai/src/common/color_extension.dart';
import 'package:iqra_maai/src/common_widgets/best_seller_cell.dart';
import 'package:iqra_maai/src/common_widgets/custom_text_widget.dart';
import 'package:iqra_maai/src/common_widgets/genre_cell.dart';
import 'package:iqra_maai/src/common_widgets/recently_view_cell.dart';
import 'package:iqra_maai/src/common_widgets/round_button.dart';
import 'package:iqra_maai/src/common_widgets/round_text_field.dart';
import 'package:iqra_maai/src/common_widgets/top_picks_cell.dart';
import 'package:iqra_maai/src/controllers/auth_controller.dart';

import '../common_widgets/navigation_bar.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();

  final GlobalKey<ScaffoldState> sideMenuScaffoldKey =
      GlobalKey<ScaffoldState>();

  final AuthController _authController = Get.put(AuthController());

  final List topPicksArr = [
    {
      "name": "The Dissapearance of Emila Zola",
      "author": "Michael Wayne Rosen",
      "img": "lib/src/assets/images/the_disappearance.jpeg"
    },
    {
      "name": "Fatherhood",
      "author": "Marcus Berkmann",
      "img": "lib/src/assets/images/fatherhood.jpg"
    },
    {
      "name": "The Time Travellers Mandbook",
      "author": "Stride Lottie",
      "img": "lib/src/assets/images/the_time_travellers.jpg"
    },
  ];

  final List bestArr = [
    {
      "name": "Miserables",
      "author": "Victor Hugo",
      "img": "lib/src/assets/images/miserable.jpg",
      "rating": 4.5
    },
    {
      "name": "The Brothers Karamazov",
      "author": " Fyodor Dostoyevsky",
      "img": "lib/src/assets/images/The_Brothers_Karamazov.jpg",
      "rating": 4.8
    },
    {
      "name": "1984: 75th Anniversary",
      "author": "by George Orwell",
      "img": "lib/src/assets/images/1984.jpg",
      "rating": 3.5
    },
  ];
  final List gArr = [
    {
      "name": "Graphic Novels",
      "img": "lib/src/assets/images/graphic.jpeg",
    },
    {
      "name": "Graphic Novels",
      "img": "lib/src/assets/images/graphic2.jpg",
    },
    {
      "name": "Graphic Novels",
      "img": "lib/src/assets/images/graphic3.jpeg",
    },
  ];

  final List recentArr = [
    {
      "name": "The Dissapearance of Emila Zola",
      "author": "Michael Wayne Rosen",
      "img": "lib/src/assets/images/the_disappearance.jpeg"
    },
    {
      "name": "Fatherhood",
      "author": "Marcus Berkmann",
      "img": "lib/src/assets/images/fatherhood.jpg"
    },
    {
      "name": "The Time Travellers Mandbook",
      "author": "Stride Lottie",
      "img": "lib/src/assets/images/the_time_travellers.jpg"
    },
  ];

  final List menuArr = [
    {"name": "Home", "icon": Icons.home},
    {"name": "Our Books", "icon": Icons.book},
    {"name": "Our Stores", "icon": Icons.storefront},
    {"name": "Careers", "icon": Icons.business_center},
    {"name": "Sell With Us", "icon": Icons.attach_money},
    {"name": "Newsletter", "icon": Icons.newspaper},
    {"name": "Pop-up Leasing", "icon": Icons.open_in_new},
    {"name": "Account", "icon": Icons.account_circle},
    {"name": "Logout", "icon": Icons.logout},
  ];

  final int? selectMenu = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sideMenuScaffoldKey,
      endDrawer: Drawer(
        backgroundColor: Colors.transparent,
        elevation: 0,
        width: Get.width * 0.8,
        child: Container(
          decoration: BoxDecoration(
            color: TColor.dColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Get.width * 0.75)),
          ),
          child: ListView(
            children: [
              SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: menuArr.map((mOBJ) {
                      var index = menuArr.indexOf(mOBJ);
                      return InkWell(
                        onTap: () {
                          switch (mOBJ["name"]) {
                            case "Home":
                              Get.offNamed('/home');
                              printInfo(info: "ha ha ha");
                              break;
                            case "Our Books":
                              // Get.toNamed('/books');
                              printInfo(info: "ha ha ha");
                              break;
                            case "Our Stores":
                              // Get.toNamed('/stores');
                              printInfo(info: "ha ha ha");
                              break;
                            case "Careers":
                              // Get.toNamed('/careers');
                              printInfo(info: "ha ha ha");
                              break;
                            case "Sell With Us":
                              // Get.toNamed('/sell');
                              printInfo(info: "ha ha ha");
                              break;
                            case "Newsletter":
                              // Get.toNamed('/newsletter');
                              printInfo(info: "ha ha ha");
                              break;
                            case "Pop-up Leasing":
                              // Get.toNamed('/leasing');
                              printInfo(info: "ha ha ha");
                              break;
                            case "Account":
                              // Get.toNamed('/account');
                              printInfo(info: "ha ha ha");
                              break;
                            case "Logout":
                              _authController.logout();
                              break;
                            default:
                              break;
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          decoration: selectMenu == index ? BoxDecoration(
                            color: TColor.primary,
                            boxShadow: [BoxShadow(
                              color: TColor.primary,
                              blurRadius: 4,
                              offset: Offset(0, 3)
                            )]
                          ) : null,
                          
                          child: Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextForSideMenu(text: mOBJ["name"].toString(), size: 18, color: selectMenu == index ? Colors.white : null,),
                              Icon(
                                mOBJ["icon"],
                                color: selectMenu == index ? Colors.white : TColor.primary,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.settings,
                              color: TColor.subTitle,
                              size: 25,
                            )),
                        TextButton(
                            onPressed: () {},
                            child: TextForSideMenu(
                              text: "Terms",
                              color: TColor.subTitle,
                            )),
                        TextButton(
                            onPressed: () {},
                            child: TextForSideMenu(
                              text: "Privacy",
                              color: TColor.subTitle,
                            )),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                child: Transform.scale(
                  scale: 1.5,
                  origin: Offset(0, Get.width * 0.8),
                  child: Container(
                    width: Get.width,
                    height: Get.width,
                    decoration: BoxDecoration(
                        color: TColor.primary,
                        borderRadius: BorderRadius.circular(Get.width * 0.5)),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  // Title To The Page
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      "Our Top Picks",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w700),
                    ),
                    leading: Container(),
                    leadingWidth: 1,
                    actions: [
                      IconButton(
                        onPressed: () {
                          sideMenuScaffoldKey.currentState!.openEndDrawer();
                        },
                        icon: Icon(Icons.menu),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.width * 0.2,
                  ),
                  SizedBox(
                    width: Get.width,
                    height: Get.width * 0.8,
                    child: CarouselSlider.builder(
                      itemCount: topPicksArr.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) {
                        var iOBJ = topPicksArr[itemIndex] as Map? ?? {};
                        return TopPicksCell(iOBJ: iOBJ);
                      },
                      options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.45,
                          aspectRatio: 1,
                          enlargeFactor: 0.35,
                          enlargeStrategy: CenterPageEnlargeStrategy.zoom),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        ReusableText(text: "Best Sellers"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.width * 0.8,
                    child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: bestArr.length,
                        itemBuilder: ((context, index) {
                          var bOBJ = bestArr[index] as Map? ?? {};
                          return BestSellerCell(bOBJ: bOBJ);
                        })),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [ReusableText(text: "Genres")],
                    ),
                  ),
                  SizedBox(
                    height: Get.width * 0.6,
                    child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: gArr.length,
                        itemBuilder: ((context, index) {
                          var gOBJ = gArr[index] as Map? ?? {};
                          return GenreCell(
                            gOBJ: gOBJ,
                            bgColor:
                                index % 2 == 0 ? TColor.color1 : TColor.color2,
                          );
                        })),
                  ),
                  SizedBox(
                    height: Get.width * 0.1,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        ReusableText(text: "Recently Viewed"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.width * 0.7,
                    child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: recentArr.length,
                        itemBuilder: ((context, index) {
                          var rOBJ = recentArr[index] as Map? ?? {};
                          return RecentlyViewCell(iOBJ: rOBJ);
                        })),
                  ),
                  SizedBox(
                    height: Get.width * 0.1,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        ReusableText(text: "Monthly Newsletter"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.width * 0.05,
                  ),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      color: TColor.textbox.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Recieve our monthly newsletter and revieve update on new stocks, books and the occa",
                          style: TextStyle(
                            color: TColor.subTitle,
                            fontSize: 12,
                          ),
                        ),
                        RoundTextField(controller: txtName, hintText: "Name"),
                        RoundTextField(
                            controller: txtEmail, hintText: "Email Address"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RoundButton(
                              onPressed: () {},
                              textOfButton: "Sign Up",
                              width: Get.width * 0.1,
                              fontSize: 15,
                              height: 40,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}


/*
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
          IconButton(
              onPressed: () {
                _authController.logout();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text('welcomeMessage'.tr),
            ListTile(
              title: Text(_userController.currentUser.value!.fullName),
              subtitle: Text(_userController.currentUser.value!.phone ),
            )
          ],
        ), // Utilisation de GetX pour traduire
      ),

*/