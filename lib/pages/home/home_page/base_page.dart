import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/auth/login.dart';
import 'package:grouping_project/pages/profile/group_profile/create_group.dart';

import 'package:grouping_project/pages/templates/building.dart';
import 'package:grouping_project/pages/home/personal_dashboard/card_edit_page.dart';
import 'package:grouping_project/pages/home/home_page/create_button.dart';
import 'package:grouping_project/pages/home/home_page/navigation_bar.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_dashboard_page.dart';
import 'package:grouping_project/service/service_lib.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final _pageController = PageController();
  final _pages = const <Widget>[
    HomePage(),
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: MaterialButton(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage:
                        Image.asset("assets/images/profile_male.png").image,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    // ignore: todo
                    // TODO: Get User Name from data package
                    "${profile.name ?? "Unknown"} 的個人工作區",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Icon(Icons.unfold_more),
                  // SvgPicture.asset("assets/images/workspace_switcher.svg",
                  //     semanticsLabel: 'switcher')
                ],
              ),
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.1),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  builder: (BuildContext context) {
                    return Container(
                        clipBehavior: Clip.hardEdge,
                        margin: const EdgeInsets.fromLTRB(3, 3, 3, 0),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        constraints: const BoxConstraints(
                          maxHeight: 450,
                          minHeight: 180,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 12,
                                color: Colors.amber,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Center(
                                  child: Text(
                                    'WOKSPACE',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                              ),
                              MaterialButton(
                                  onPressed: () {
                                    debugPrint('create new work space');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateWorkspacePage()));
                                    // TODO: Create New Workspace Page
                                    // debugPrint("create new workspace");
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        size: 30,
                                        Icons.add_box_outlined,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 10),
                                      Text("創建新的工作小組",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black))
                                    ],
                                  ))
                            ]));
                  });
            },
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                //temp remove async for quick test
                onPressed: () async {
                  _authService.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: const Icon(Icons.settings_accessibility_rounded)),
          ],
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
