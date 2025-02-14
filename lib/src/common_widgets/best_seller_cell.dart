import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../common/color_extension.dart';

class BestSellerCell extends StatelessWidget {
  const BestSellerCell({super.key, required this.bOBJ});
  final Map bOBJ;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      width: Get.width * 0.3,
      //height: Get.width * 0.8, // Définir une hauteur fixe pour éviter l'overflow
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                bOBJ['img'].toString(),
                fit: BoxFit.cover,
                width: Get.width * 0.3,
                height: Get.width *
                    0.45, // Réduire la taille pour éviter l'overflow
              ),
            ),
          ),
          Text(
            bOBJ["name"].toString(),
            textAlign: TextAlign.center,
            // maxLines: 3,
            style: TextStyle(
                color: TColor.text, fontSize: 12, fontWeight: FontWeight.w700),
          ),
          Text(
            bOBJ["author"].toString(),
            textAlign: TextAlign.left,
            maxLines: 1,
            style: TextStyle(
                color: TColor.subTitle,
                fontSize: 9,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 15,
          ),
          IgnorePointer(
            ignoring: true,
            child: RatingBar.builder(
              initialRating: double.tryParse( bOBJ["rating"].toString() ) ?? 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 13,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: TColor.primary,
              ),
              onRatingUpdate: (rating) {
                printInfo(info: "$rating");
              },
            ),
          )
        ],
      ),
    );
  }
}
