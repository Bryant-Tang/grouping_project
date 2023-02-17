// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:grouping_project/pages/auth/cover.dart';
import 'package:grouping_project/pages/home/card_edit_page.dart';
// import 'package:provider/provider.dart';
import 'package:grouping_project/service/auth_service.dart';
// import 'package:grouping_project/model/user_model.dart';
// import 'package:grouping_project/firebase_options.dart';

import 'package:grouping_project/components/business_card.dart';
import 'package:grouping_project/components/message.dart';
import 'package:grouping_project/pages/auth/login.dart';

import 'package:grouping_project/pages/home/home_group_page.dart';
import 'package:grouping_project/pages/home/home_upcoming_page.dart';
import 'package:grouping_project/pages/home/home_tracked_mission_page.dart';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _testPageState();
}

class _testPageState extends State<MyHomePage> {
  AuthService _authService = AuthService();
  var funtionSelect = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          // 讀取使用者或團體名字 !!!!!!!!!!!!
          'QUAN 的工作區',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CardEditDone()));
              },
              // 改變成使用者或團體的頭像 !!!!!!!!!!!
              icon: const Icon(Icons.circle)),
          IconButton(
              //temp remove async for quick test
              onPressed: () async {
                _authService.signOut();
                _authService.googleSignOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => new LoginPage()));
              },
              icon: const Icon(Icons.logout_outlined)),
        ],
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(children: [
          // 名片位置
          PersonalCard(),
          const SizedBox(
            height: 3,
          ),
          // 功能選擇區
          Container(
            height: 80,
            width: 325,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 4),
                itemCount: 4,
                itemBuilder: ((context, index) {
                  return Container(
                    width: 150,
                    margin: EdgeInsets.all(1),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: funtionSelect == index
                              ? Colors.black
                              : Colors.grey),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          funtionSelect = index;
                        });
                      },
                      icon: (index == 0
                          ? const Icon(Icons.group)
                          : index == 1
                              ? const Icon(Icons.calendar_today)
                              : index == 2
                                  ? const Icon(Icons.list)
                                  : const Icon(Icons.message)),
                      label: Text(
                        index == 0
                            ? 'WORKSPACE\n小組專區'
                            : index == 1
                                ? 'UPCOMING EVENT\n即將來臨'
                                : index == 2
                                    ? 'TRACKED MISSION\n任務追蹤'
                                    : 'TAGGED MESSAGE\n待回覆',
                        style: const TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  );
                })),
          ),
          const SizedBox(
            height: 3,
          ),
          // 顯示該功能的列表
          differentFunctionPage[funtionSelect]
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('add new event');
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.house), label: 'house'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'note'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'message')
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

List<Widget> differentFunctionPage = [
  Expanded(
    child: ListView(
    children: [
      GroupPage()
    ],
  )),
  Expanded(
    child: ListView(
    children: [
      // UpcomingExpand(
      //     group: 'personal',
      //     title: 'P+ 籃球會',
      //     descript: '領航員 vs 富邦勇士',
      //     date1: '9:00 PM, FEB 2, 2023',
      //     date2: '11:00 PM, FEB 2, 2023'),
      UpcomingPage()
    ],
  )),
  Expanded(
    child: ListView(
    children: [
      TrackedPage()
    ],
  )),
  Expanded(
      child: ListView(
    children: [Message(messageNumber: 1)],
  ))
];
