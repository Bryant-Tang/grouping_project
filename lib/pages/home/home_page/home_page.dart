import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/auth/login.dart';

import 'package:grouping_project/pages/building.dart';
import 'package:grouping_project/pages/home/card_edit_page.dart';
import 'package:grouping_project/pages/home/home_page/create_button.dart';
import 'package:grouping_project/pages/home/navigation_bar.dart';
import 'package:grouping_project/pages/home/personal_dashboard_page.dart';
import 'package:grouping_project/service/service_lib.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();
  final _pages = const <Widget>[
    PeronalDashboardPage(),
    Center(child: BuildingPage(errorMessage: "Calendar Page")),
    Center(child: BuildingPage(errorMessage: "Message Page")),
    Center(child: BuildingPage(errorMessage: "Note Page")),
  ];
  final AuthService _authService = AuthService();
  ProfileModel profile = ProfileModel();
  var funtionSelect = 0;

  @override
  void initState() {
    super.initState();
    DataController()
        .download(dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!)
        .then((value) {
      setState(() {
        profile = value;
      });
    });
  }
  
  int _currentPageIndex = 0;
  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            // ignore: todo
            // TODO: Get User Name from data package
            profile.name ?? "Unknown",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CardEditDone()));
                },
                // 改變成使用者或團體的頭像 !!!!!!!!!!!
                icon: const Icon(Icons.circle)),
            IconButton(
                //temp remove async for quick test
                onPressed: () async {
                  _authService.signOut();
                  _authService.googleSignOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: const Icon(Icons.logout_outlined)),
          ],
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
              debugPrint("page index: $_currentPageIndex");
            });
          },
          children: _pages,
        ),
        extendBody: true,
        floatingActionButton: const CreateButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: NavigationAppBar(
            currentIndex: _currentPageIndex,
            onTap: (index) {
              setState(() {
                _currentPageIndex = index;
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              });
            }));
  }
}
