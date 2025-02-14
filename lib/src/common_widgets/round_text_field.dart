import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class RoundTextField extends StatelessWidget {
  const RoundTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.validator,
      this.onChanged,
      this.maxLength,
      this.obscureText = false,
      this.prefixIcon,
      this.suffixIcon, this.keyboardType});
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLength;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: TColor.textbox, borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLength: maxLength,
        onChanged: onChanged,
        validator: validator,
        cursorColor: TColor.primary,
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            hintText: hintText,
            labelStyle: TextStyle(
              fontSize: 15,
            )),
      ),
    );
  }
}
