import 'package:grouping_project/pages/auth/cover.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grouping_project/pages/building.dart';
import 'package:grouping_project/pages/home/home_page/home_page.dart';
// import 'package:grouping_project/pages/profile/profile_edit_page.dart';
import 'package:grouping_project/pages/page_not_found.dart';
import 'firebase_options.dart';

// 繞過登入直接進入(測試用library)
// import 'package:grouping_project/pages/home/personal_dashboard_page.dart';
// import 'package:grouping_project/pages/event_data_test_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.amber,
            // 將 NotoSansTC 設為 default font family
            fontFamily: 'NotoSansTC'),
        debugShowCheckedModeBanner: false,
        // 呼叫 home_page.dart
        home: const CoverPage()
        // NotFoundPage.fromError("errorMessage"),
        // home: EditPersonalProfilePage(),
        // home: const BuildingPage(errorMessage: "測試頁面",),
        );
  }
}
