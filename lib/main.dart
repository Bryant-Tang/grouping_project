import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:grouping_project/View/app/app_view.dart';

void main() {
  Map<String, String> initialQueryParameters;
  if (kIsWeb) {
    initialQueryParameters =
        Uri.parse(html.window.location.href).queryParameters;
    runApp(MyApp(
      queryParameters: initialQueryParameters,
    ));
  }
}

class MyApp extends StatelessWidget {
  final Map<String, String> queryParameters;
  const MyApp({super.key, required this.queryParameters});
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
        '/': (context) => AppView(queryParameters: queryParameters),
      },
      initialRoute: '/',
      // 呼叫 home_page.dart
      // home: const AppView()
    );
  }
}
