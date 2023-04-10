import 'package:grouping_project/pages/auth/cover.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grouping_project/pages/profile/group_profile/create_group.dart';
import 'package:grouping_project/pages/templates/building.dart';
// import 'package:grouping_project/pages/profile/profile_edit_page.dart';
import 'firebase_options.dart';

// 繞過登入直接進入(測試用library)
import 'package:grouping_project/pages/home/personal_dashboard/personal_dashboard_page.dart';
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
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.amber,
              backgroundColor: Colors.white,),
            primarySwatch: Colors.amber,
            fontFamily: 'NotoSansTC',
            useMaterial3: true,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            dividerColor: Colors.black26,
            navigationBarTheme: const NavigationBarThemeData(
              backgroundColor: Colors.white,
            )),
        debugShowCheckedModeBanner: false,
        // 呼叫 home_page.dart
        home: const CoverPage()
        // NotFoundPage.fromError("errorMessage"),
        // home: EditPersonalProfilePage(),
        // home: const BuildingPage(errorMessage: "測試頁面",),
        );
  }
}
