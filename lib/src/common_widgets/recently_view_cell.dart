import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/color_extension.dart';

class RecentlyViewCell extends StatelessWidget {
  const RecentlyViewCell({super.key, required this.iOBJ});
  final Map iOBJ;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      width: Get.width * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 2),
                      blurRadius: 3)
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                iOBJ['img'].toString(),
                fit: BoxFit.cover,
                width: Get.width * 0.3,
                height: Get.width *
                    0.45, // Réduire la taille pour éviter l'overflow
              ),
            ),
          ),
          Text(
            iOBJ["name"].toString(),
            textAlign: TextAlign.left,
            // maxLines: 3,
            style: TextStyle(
                color: TColor.text, fontSize: 10, fontWeight: FontWeight.w700),
          ),
          Text(
            iOBJ["author"].toString(),
            textAlign: TextAlign.left,
            maxLines: 1,
            style: TextStyle(
                color: TColor.subTitle,
                fontSize: 9,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
