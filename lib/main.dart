import 'package:grouping_project/pages/auth/cover.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grouping_project/pages/profile/group_profile/create_group.dart';
import 'package:grouping_project/pages/templates/building.dart';
import 'package:grouping_project/theme/color_schemes.dart';
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
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          // primarySwatch: Colors.amber,
          colorSchemeSeed: Colors.amber,
          fontFamily: 'NotoSansTC',
          // colorScheme: lightColorScheme
        ),
        // darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        // themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        // 呼叫 home_page.dart
        home: const CoverPage());
  }
}
