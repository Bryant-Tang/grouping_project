import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:grouping_project/pages/profile/group_profile/create_group.dart';
// import 'package:grouping_project/pages/view_template/building.dart';
import 'package:provider/provider.dart';
import 'package:grouping_project/View/helper_page/cover_view.dart';
// import 'package:grouping_project/pages/profile/profile_edit_page.dart';
import 'firebase_options.dart';
// 繞過登入直接進入(測試用library)
// import 'package:grouping_project/pages/home/personal_dashboard/personal_dashboard_page.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeManager>(
          create: (_) => ThemeManager(),
        ),
        // ChangeNotifierProvider<WorkspaceDashBoardViewModel>(
        //   create: (_) => WorkspaceDashBoardViewModel(),
        // ),
      ],
      child: ChangeNotifierProvider<ThemeManager>(
        create: (_) => ThemeManager(),
        child: Consumer<ThemeManager>(
          builder: (context, themeManager, child) => MaterialApp(
              builder: (BuildContext context, Widget? child) {
                final MediaQueryData data = MediaQuery.of(context);
                /* TODO:  textscalefactor will change depend on device
                          also need to be careful with user depend on their own need
                */
                final double newtextScaleFactor = data.textScaleFactor;
                // final double newtextScaleFactor = data.size.height / data.size.width;
                final num constrainedTextScaleFactor = newtextScaleFactor.clamp(1.0, 2.0);
                return MediaQuery(
                  data: data.copyWith(
                    textScaleFactor: constrainedTextScaleFactor as double,
                  ),
                  child: child!,
                );
              },
              theme: ThemeData(
                brightness: themeManager.brightness,
                useMaterial3: true,
                // primarySwatch: Colors.amber,
                colorSchemeSeed: themeManager.colorSchemeSeed,
                fontFamily: 'NotoSansTC',
                // colorScheme: lightColorScheme
              ),
              debugShowCheckedModeBanner: false,
              // 呼叫 home_page.dart
              home: const CoverPage()),
        ),
      ),
    );
  }
}
