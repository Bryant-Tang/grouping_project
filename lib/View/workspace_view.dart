// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/components/color_tag_chip.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/View/login_view.dart';
import 'package:grouping_project/View/create_group_view.dart';

import 'package:grouping_project/pages/view_template/building.dart';
import 'package:grouping_project/components/button/create_button.dart';
import 'package:grouping_project/View/workspace_dashboard_page_view.dart';
import 'package:provider/provider.dart';
import 'package:grouping_project/View/workspace_calendar_page_view.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  // late Future<void> _dataFuture;
  final _pageController = PageController();
  // final model = WorkspaceDashboardViewModel();
  final _pages = const <Widget>[
    DashboardPage(),
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

  AppBar getAppBar(model, themeManager, context) {
    return AppBar(
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
                backgroundImage: model.profile.photo != null
                    ? Image.file(model.profile.photo!).image
                    : Image.asset("assets/images/profile_male.png").image,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                model.profile.nickname ?? "Unknown",
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
                return ChangeNotifierProvider<
                        WorkspaceDashboardViewModel>.value(
                    value: model,
                    builder: (context, child) => const SwitchWorkSpaceSheet());
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            icon: const Icon(Icons.settings_accessibility_rounded)),
      ],
    );
  }

  NavigationBar getNavigationBar(model, themeManger, context) {
    return NavigationBar(
        onDestinationSelected: (index) {
          model.updateSelectedIndex(index);
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        },
        selectedIndex: model.selectedIndex,
        destinations: filename
            .map((name) => NavigationDestination(
                  icon: getSvgIcon(path: getPath(name), context: context),
                  // color: Colors.black,
                  label: name,
                ))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WorkspaceDashboardViewModel>(
      create: (context) => WorkspaceDashboardViewModel()..getAllData(),
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) =>
            Consumer<WorkspaceDashboardViewModel>(
                builder: (context, model, child) => WillPopScope(
                      onWillPop: () async {
                        return false; // 禁用返回鍵
                      },
                      child: Scaffold(
                        appBar: getAppBar(model, themeManager, context),
                        body: PageView(
                          controller: _pageController,
                          onPageChanged: model.updateSelectedIndex,
                          children: _pages,
                        ),
                        extendBody: true,
                        floatingActionButton: const CreateButton(),
                        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                        bottomNavigationBar:
                            getNavigationBar(model, themeManager, context),
                      ),
                    )),
      ),
    );
  }
}

class SwitchWorkSpaceSheet extends StatelessWidget {
  const SwitchWorkSpaceSheet({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.fromLTRB(3, 3, 3, 0),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 12,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(
                  child: Text('WOKSPACE',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              const Divider(thickness: 2, indent: 20, endIndent: 20),
              Expanded(
                child: ListView.builder(
                  clipBehavior: Clip.hardEdge,
                  itemBuilder: (context, index) {
                    return GroupSwitcherView(
                        groupProfile: context
                            .watch<WorkspaceDashboardViewModel>()
                            .allGroupProfile
                            .elementAt(index));
                  },
                  itemCount: context
                      .watch<WorkspaceDashboardViewModel>()
                      .allGroupProfile
                      .length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                ),
              ),
              MaterialButton(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateWorkspacePage()));
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        size: 25,
                        Icons.add_box_outlined,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 10),
                      Text("創建新的工作小組",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.bold))
                    ],
                  )),
            ]),
      ),
    );
  }
}

class GroupSwitcherView extends StatelessWidget {
  // TODO : 將 color 抽離出來
  final AccountModel groupProfile;
  const GroupSwitcherView({Key? key, required this.groupProfile})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashboardViewModel>(
        builder: (context, model, child) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: MaterialButton(
                onPressed: model.switchGroup,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    // implement shadow Border
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              Color(groupProfile.color),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(groupProfile.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontWeight: FontWeight.bold)),
                                Text(groupProfile.introduction,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ))
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: (groupProfile.tags)
                                  .map((tag) => ColorTagChip(
                                      tagString: tag.tag,
                                      color: Color(
                                          groupProfile.color)))
                                  .toList(),
                            )
                          ],
                        )
                      ]),
                ),
              ),
            ));
  }
}
