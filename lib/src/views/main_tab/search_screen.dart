import 'package:flutter/material.dart';

import '../../common_widgets/navigation_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Search Page"),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),

    );
  }
}