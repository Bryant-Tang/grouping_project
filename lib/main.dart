import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/app_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // brightness: themeManager.brightness,
        useMaterial3: true,
        // primarySwatch: Colors.amber,
        // colorSchemeSeed: themeManager.colorSchemeSeed,
        // fontFamily: 'NotoSansTC',
        // colorScheme: lightColorScheme
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        // 呼叫 home_page.dart
        '/': (context) => AppView(),
      },
      initialRoute: '/',
      // 呼叫 home_page.dart
      // home: const AppView()
    );
  }
}
