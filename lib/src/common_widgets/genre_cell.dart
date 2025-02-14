import 'package:flutter/material.dart';
import 'package:get/get.dart';


class GenreCell extends StatelessWidget {
  const GenreCell({super.key, required this.gOBJ, required this.bgColor});
  final Map gOBJ;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      padding: EdgeInsets.all(8),
      width: Get.width * 0.7,
      height: Get.width * 0.1,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            gOBJ['img'].toString(),
            fit: BoxFit.fill,
            width: Get.width * 0.7,
            height: Get.width *
                0.35, // Réduire la taille pour éviter l'overflow
          ),
          Text(
            gOBJ["name"].toString(),
            textAlign: TextAlign.center,
            // maxLines: 3,
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
