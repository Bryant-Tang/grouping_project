import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouping_project/VM/workspace/calendar_view_model.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/View/helper_page/building.dart';
import 'package:grouping_project/View/profile/profile_display_view.dart';
import 'package:grouping_project/components/button/create_button.dart';
import 'package:grouping_project/View/workspace/workspace_dashboard_page_view.dart';
import 'package:provider/provider.dart';
import 'package:grouping_project/View/workspace/workspace_calendar_page_view.dart';
import 'worksapce_switching_sheet_view.dart';

class WorksapceBasePage extends StatefulWidget {
  const WorksapceBasePage({Key? key}) : super(key: key);

  @override
  State<WorksapceBasePage> createState() => _WorksapceBasePageState();
}

class _WorksapceBasePageState extends State<WorksapceBasePage> {
  // late Future<void> _dataFuture;
  final _pageController = PageController();
  // final model = WorkspaceDashboardViewModel();
  final _pages = const <Widget>[
    WorkspaceDashboardPageView(),
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

  AppBar getAppBar(WorkspaceDashBoardViewModel model, themeManager, context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                backgroundImage: model.profileImage.isNotEmpty
                    ? Image.memory(model.profileImage).image
                    : Image.asset("assets/images/profile_male.png").image,
              ),
              const SizedBox(width: 10),
              Text(
                model.workspaceName,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.unfold_more),
            ],
          ),
        ),
        onPressed: () async {
          final res = await showModalBottomSheet(
              context: context,
              barrierColor: Colors.black.withOpacity(0.2),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              builder: (BuildContext context) {
                return ChangeNotifierProvider<
                        WorkspaceDashBoardViewModel>.value(
                    value: model,
                    builder: (context, child) => const SwitchWorkSpaceSheet());
              });
          if(res!=null && res){
            await model.getAllData();
          }
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
              showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  builder: (context) => ChangeNotifierProvider.value(
                        value: model,
                        child: const ProfileDispalyPageView(),
                      ));
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WorkspaceDashBoardViewModel>(
          create: (context) => WorkspaceDashBoardViewModel()..getAllData(),
        ),
        ChangeNotifierProvider<CalendarViewModel>(
          create: (context) => CalendarViewModel(),
        )
      ],
      child: Consumer<ThemeManager>(
          builder: (context, themeManager, child) =>
              Consumer<WorkspaceDashBoardViewModel>(
                  builder: (context, model, child){
                    return WillPopScope(
                      onWillPop: () async {
                        return false; // 禁用返回鍵
                      },
                      child: model.isLoading
                          ? const Scaffold(
                              body: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Scaffold(
                              appBar: getAppBar(model, themeManager, context),
                              body: RefreshIndicator(
                                onRefresh: model.getAllData,
                                child: PageView(
                                  scrollDirection: Axis.vertical,
                                  controller: _pageController,
                                  onPageChanged: model.updateSelectedIndex,
                                  children: _pages,
                                ),
                              ),
                              extendBody: true,
                              floatingActionButton: const CreateButton(),
                              // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                              bottomNavigationBar:
                                  getNavigationBar(model, themeManager, context),
                            ),
                          );},
          
        )
    ));
  }
}
