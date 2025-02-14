import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/color_extension.dart';

class TopPicksCell extends StatelessWidget {
  const TopPicksCell({super.key, required this.iOBJ});
  final Map iOBJ;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.3,
      height:
          Get.width * 0.8, // Définir une hauteur fixe pour éviter l'overflow
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            textAlign: TextAlign.center,
            // maxLines: 3,
            style: TextStyle(
                color: TColor.text, fontSize: 12, fontWeight: FontWeight.w700),
          ),
          Text(
            iOBJ["author"].toString(),
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
                color: TColor.subTitle,
                fontSize: 10,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
