import 'package:flutter/material.dart';

import '../../common_widgets/navigation_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart "),
      ),
      body: Center(
        child: Text("Cart Page"),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}