import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'cover.dart';
import 'firebase_options.dart';

// 測試 group card 是否成功導入
import 'createGroupCard.dart';
// 測試 card view
import 'createCardView.dart';

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
      ),
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
    return const Scaffold(body: CoverPage());
  }
}

// 測試 group card component 的 page
class _testPageState extends State<MyHomePage> {

  String testTitle = 'Title';
  String testDes = 'this is a test\nwith a looooooooooooooooooooooooooooong text';

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CreateUpcoming('personal', 'Flutter tutorial', 'we will try something new', '9:00 PM, FEB 7, 2023', '11:00 PM, FEB 7, 2023')
    );
  }
}

