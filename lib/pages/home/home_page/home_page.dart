// TODO: Create home page with Scaffold Widget
// Path: lib/pages/home/home_page/home_page.dart
// place navigation bar at the button of page

import 'package:flutter/material.dart';
import 'package:grouping_project/pages/home/navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: const Center(
          child: Text("Home Page"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const NavigationAppBar());
  }
}

