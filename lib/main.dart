import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grouping_project/pages/auth/cover.dart';
import 'package:grouping_project/pages/auth/sign_up.dart';
import 'package:provider/provider.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/model/user_model.dart';
import 'firebase_options.dart';
import './pages/auth/login.dart';
import 'package:grouping_project/pages/event_data_test_page.dart';

// 繞過登入直接進入(測試用library)
import 'package:grouping_project/pages/home/home_page.dart';

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
      home: const CoverPage(),
      // home: MyHomePage(),
      // home: EventDataTestPage(),
    );
  }
}
