import 'package:flutter/material.dart';
import 'page/cover.dart';
import 'page/loginPage.dart';

import 'home_page.dart';

// 測試 group card 是否成功導入
import 'createGroupCard.dart';

void main() async {
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
        primarySwatch: Colors.amber,
      ),
      // 呼叫 home_page.dart
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  //State<MyHomePage> createState() => _MyHomePageState();
  State<MyHomePage> createState() => _testPageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginPage());
  }
}
