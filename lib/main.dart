import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grouping_project/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/model/user_model.dart';
import 'firebase_options.dart';

import 'home_page.dart';

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
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        // 將 NotoSansTC 設為 default font family
        fontFamily: 'NotoSansTC'
      ),
      // 呼叫 home_page.dart
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
        initialData: null,
        value: AuthService().onAuthStateChanged,
        builder: (context, snapshot) {
          return MaterialApp(
            home: Wrapper(),
          );
        });
  }
}

