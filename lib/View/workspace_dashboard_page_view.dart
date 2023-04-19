import 'package:grouping_project/View/profile_display_view.dart';

// progress card
import 'package:grouping_project/pages/home/personal_dashboard/progress.dart';
import 'package:grouping_project/pages/home/personal_dashboard/over_view.dart';

// show frame of widget
// import 'package:flutter/rendering.dart';

// 測試新功能用，尚未完工，請勿使用或刪除
import 'package:grouping_project/pages/home/home_page/empty.dart';

import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.vertical,
      controller: PageController(initialPage: 1),
      children: const [
        ProfileDispalyPageView(),
        PeronalDashboardPage(),
      ],
    );
  }
}

class PeronalDashboardPage extends StatefulWidget {
  const PeronalDashboardPage({super.key});
  @override
  State<PeronalDashboardPage> createState() => _PeosonalDashboardPageState();
}

class _PeosonalDashboardPageState extends State<PeronalDashboardPage> {
  @override
  Widget build(BuildContext context) {
    // show the from of widget
    // debugPaintSizeEnabled = true;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Expanded(flex: 1, child: Progress()),
          Expanded(flex: 3, child: OverView()),
        ]);
  }
}
