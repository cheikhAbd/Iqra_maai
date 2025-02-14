import 'package:flutter/material.dart';
import 'package:iqra_maai/src/common/color_extension.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {super.key,
      required this.onPressed,
      this.height,
      this.width,
      this.textColor,
      required this.textOfButton, this.fontSize});

  final Color? textColor;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final double? fontSize;
  final String textOfButton;


  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      textColor: Colors.white,
      color: TColor.primary,
      height: height ?? 50,
      minWidth: width ?? double.maxFinite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Text(
        textOfButton,
        style: TextStyle(fontSize: fontSize ?? 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class RoundLineButton extends StatelessWidget {
  const RoundLineButton(
      {super.key,
      required this.onPressed,
      this.height,
      this.width,
      this.textColor,
      required this.textOfButton});

  final Color? textColor;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final String textOfButton;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: getColor(Colors.white, TColor.primary),
        foregroundColor: getColor(TColor.primary, Colors.white),
        shadowColor:
            WidgetStateProperty.resolveWith((states) => TColor.primary),
        minimumSize: WidgetStateProperty.resolveWith(
            (states) => Size(width ?? double.maxFinite, height ?? 50)),
        elevation: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.pressed) ? 1 : 0),
        shape: WidgetStateProperty.resolveWith((states) =>
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    width: 1,
                    color: states.contains(WidgetState.pressed)
                        ? Colors.transparent
                        : TColor.primary))),
      ),
      child: Text(
        textOfButton,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  WidgetStateProperty<Color> getColor(Color color, Color colorPressed) {
    return WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.pressed) ? colorPressed : color);
  }
}
