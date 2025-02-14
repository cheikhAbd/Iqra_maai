import 'package:flutter/material.dart';
import 'package:iqra_maai/src/common_widgets/navigation_bar.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Menu Page"),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}