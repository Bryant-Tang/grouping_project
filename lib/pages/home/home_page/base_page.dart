// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouping_project/ViewModel/view_model_lib.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/View/auth/login.dart';
import 'package:grouping_project/pages/profile/group_profile/create_group.dart';

import 'package:grouping_project/pages/view_template/building.dart';
import 'package:grouping_project/pages/home/home_page/create_button.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_dashboard_page.dart';
import 'package:provider/provider.dart';
import 'package:grouping_project/pages/home/calendar/calendar.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  // late Future<void> _dataFuture;
  final _pageController = PageController();
  final _pages = const <Widget>[
    HomePage(),
    CalendarPage(),
    Center(child: BuildingPage(errorMessage: "Message Page")),
    Center(child: BuildingPage(errorMessage: "Note Page")),
  ];
  final filename = ["home", "calendar", "messages", "note"];
  Widget getSvgIcon({required String path, required BuildContext context}) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return SvgPicture.asset(path,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
  }
  String getPath(filename) {
    return "assets/icons/appBar/$filename.svg";
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PersonalDashboardViewModel>(
        create: (context) => PersonalDashboardViewModel()..updateProfile(),
        child: Consumer<ThemeManager>(
          builder: (context, themeManager, child) =>
              Consumer<PersonalDashboardViewModel>(
            builder: (context, model, child) => model.isLoading
                ? const Scaffold(
                    body: Center(child: CircularProgressIndicator()))
                : Scaffold(
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
                                radius: 20,
                                backgroundImage: model.profileImage != null
                                    ? Image.file(model.profileImage!).image
                                    : Image.asset(
                                            "assets/images/profile_male.png")
                                        .image,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                model.userName,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const Icon(Icons.unfold_more),
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
                                return SwitchWorkSpaceSheet();
                              });
                        },
                      ),
                      automaticallyImplyLeading: false,
                      actions: [
                        IconButton(
                            //temp remove async for quick test
                            onPressed: themeManager.toggleTheme,
                            icon: Icon(themeManager.icon)),
                        IconButton(
                            //temp remove async for quick test
                            onPressed: () async {
                              await model.signOut();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            icon: const Icon(
                                Icons.settings_accessibility_rounded)),
                      ],
                    ),
                    body: PageView(
                      controller: _pageController,
                      onPageChanged: model.updateSelectedIndex,
                      children: _pages,
                    ),
                    extendBody: true,
                    floatingActionButton: const CreateButton(),
                    // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                    bottomNavigationBar: NavigationBar(
                        onDestinationSelected: (index) {
                          model.updateSelectedIndex(index);
                          _pageController.animateToPage(index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        selectedIndex: model.selectedIndex,
                        destinations: filename
                            .map((name) => NavigationDestination(
                                  icon: getSvgIcon(
                                      path: getPath(name), context: context),
                                  // color: Colors.black,
                                  label: name,
                                ))
                            .toList()),
                  ),
          ),
        ));
  }
}

class SwitchWorkSpaceSheet extends StatelessWidget {
  // implement the switch work space sheet
  final allGroupProfile = [
    ProfileModel(
        name: "服務學習課程",
        color: 0xFF00417D,
        introduction: "python 程式教育課程小組",
        tags: ["#Python", "#程式基礎教育", "#工作"]
            .map((t) => ProfileTag(tag: t, content: t))
            .toList()),
    ProfileModel(
        name: "服務學習課程",
        color: 0xFF993300,
        introduction: "python 程式教育課程小組",
        tags: ["#Python", "#程式基礎教育", "#工作"]
            .map((t) => ProfileTag(tag: t, content: t))
            .toList()),
    ProfileModel(
        name: "服務學習課程",
        color: 0xFFFFB782,
        introduction: "python 程式教育課程小組",
        tags: ["#Python", "#程式基礎教育", "#工作"]
            .map((t) => ProfileTag(tag: t, content: t))
            .toList()),
  ];
  SwitchWorkSpaceSheet({Key? key}) : super(key: key);
  // implement the switch work space sheet build method
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.fromLTRB(3, 3, 3, 0),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Expanded(
                  child: ListView.builder(
                    clipBehavior: Clip.hardEdge,
                    itemBuilder: (context, index) {
                      return GroupSwitcherView(
                          groupProfile: allGroupProfile.elementAt(index));
                    },
                    itemCount: allGroupProfile.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  ),
                ),
                MaterialButton(
                    onPressed: () {
                      debugPrint('create new work space');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreateWorkspacePage())).then((value) {
                        // debugPrint(value.toString());
                      });
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
                    )),
              ])),
    );
  }
}

class GroupSwitcherView extends StatelessWidget {
  final ProfileModel groupProfile;
  const GroupSwitcherView({Key? key, required this.groupProfile})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: MaterialButton(
        onPressed: () {
          debugPrint('switch to ${groupProfile.name}');
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            // implement shadow Border
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(groupProfile.color ?? 0xFF00417D),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(groupProfile.name ?? "",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          groupProfile.introduction ?? "",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: (groupProfile.tags ?? [])
                          .map((tag) => ColorTagChip(
                              tagString: tag.tag,
                              color: Color(groupProfile.color ?? 0xFF00417D)))
                          .toList(),
                    )
                  ],
                )
              ]),
        ),
      ),
    );
  }
}

class ColorTagChip extends StatelessWidget {
  const ColorTagChip(
      {Key? key, required this.tagString, this.color = Colors.amber})
      : super(key: key);
  final Color color;
  final String tagString;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 6, 4),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.circular(20),
            color: color.withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Center(
            child: Text(tagString,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 10)),
          ),
        ),
      ),
    );
  }
}
