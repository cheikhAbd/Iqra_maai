import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class ReusableText extends StatelessWidget {
  const ReusableText({super.key, required this.text, this.color, this.size, this.fontWeight});
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color ?? TColor.text, fontSize: size ?? 22, fontWeight: fontWeight ?? FontWeight.w700),
    );
  }
}


class TextForSideMenu extends StatelessWidget {
  const TextForSideMenu({super.key, required this.text, this.color, this.size});
  final String text;
  final Color? color;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      fontSize: size ?? 17,
      fontWeight: FontWeight.w700,
      color: color ?? TColor.text,
    ),);
  }
}
