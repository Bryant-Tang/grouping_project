import 'package:googleapis/mybusinessbusinessinformation/v1.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/auth/user.dart';
import 'package:grouping_project/pages/home/card_edit_page.dart';
import 'package:grouping_project/pages/home/navigation_bar.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/pages/auth/login.dart';

// progress card
import 'package:grouping_project/components/card_view/progress.dart';
import 'package:grouping_project/pages/home/home_page/over_view.dart';

// show frame of widget
// import 'package:flutter/rendering.dart';

// 測試新功能用，尚未完工，請勿使用或刪除
import 'package:grouping_project/pages/home/home_page/empty.dart';

import 'package:flutter/material.dart';

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
