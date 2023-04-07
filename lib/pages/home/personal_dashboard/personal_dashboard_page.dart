import 'package:grouping_project/pages/home/personal_dashboard/card_edit_page.dart';

// progress card
import 'package:grouping_project/components/card_view/progress.dart';
import 'package:grouping_project/pages/home/personal_dashboard/over_view.dart';

// show frame of widget
// import 'package:flutter/rendering.dart';

// 測試新功能用，尚未完工，請勿使用或刪除
import 'package:grouping_project/pages/home/home_page/empty.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.vertical,
      controller: PageController(initialPage: 1), 
      children: const [
        CardEditDone(),
        PeronalDashboardPage(),
      ],
    );
  }
}

class PeronalDashboardPage extends StatefulWidget {
  const PeronalDashboardPage({super.key});
  @override
  State<PeronalDashboardPage> createState() => _TestPageState();
}

class _TestPageState extends State<PeronalDashboardPage> {
  @override
  Widget build(BuildContext context) {
    // show the from of widget
    // debugPaintSizeEnabled = true;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 120,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Expanded(
              flex: 2,
              child: Progress(),
            ),
            // Progress 位置
            SizedBox(
              height: 3,
            ),
            Expanded(flex: 5, child: OverView()),
          ]),
    );
  }
}
