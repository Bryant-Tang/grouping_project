import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/pages/home/home_page.dart';
import 'package:grouping_project/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/model/user_model.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import './pages/auth/login.dart';

import 'home_page.dart';
import './pages/auth/login.dart';

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
          primarySwatch: Colors.orange,
          // 將 NotoSansTC 設為 default font family
          fontFamily: 'NotoSansTC'),
      debugShowCheckedModeBanner: false,
      // 呼叫 home_page.dart
      //home: Wrapper(),
      home: MyHomePage(),
    );
  }
}
