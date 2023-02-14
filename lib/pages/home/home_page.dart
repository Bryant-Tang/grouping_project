import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grouping_project/pages/auth/cover.dart';
import 'package:grouping_project/pages/home/card_edit_page.dart';
import 'package:grouping_project/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/model/user_model.dart';
import '../../firebase_options.dart';

import '../../component/business_card.dart';
import '../../component/card_view.dart';
import '../../component/message.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _testPageState();
}

class _testPageState extends State<MyHomePage> {
  AuthService _authService = AuthService();
  var funtionSelect = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QUAN 的工作區', style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
              onPressed: () {
                print('switch to personal Intro.');
                Navigator.push(context, MaterialPageRoute(builder: (context) => CardEditDone()));
              },
              icon: Icon(Icons.circle)),
          IconButton(
              //temp remove async for quick test
              onPressed: () async {
                _authService.signOut();
                _authService.googleSignOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => new Wrapper()));
              },
              icon: Icon(Icons.logout_outlined)),
        ],
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(children: [
          // 名片位置
          PersonalCard(),
          SizedBox(
            height: 3,
          ),
          // 功能選擇區
          Container(
            height: 80,
            width: 325,
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          ? Icon(Icons.group)
                          : index == 1
                              ? Icon(Icons.calendar_today)
                              : index == 2
                                  ? Icon(Icons.list)
                                  : Icon(Icons.message)),
                      label: Text(
                        index == 0
                            ? 'WORKSPACE\n小組專區'
                            : index == 1
                                ? 'UPCOMING EVENT\n即將來臨'
                                : index == 2
                                    ? 'TRACKED MISSION\n任務追蹤'
                                    : 'TAGGED MESSAGE\n待回覆',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  );
                })),
          ),
          SizedBox(
            height: 3,
          ),
          // 顯示該功能的列表
          DifferentFunctionPage[funtionSelect]
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('add new event');
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
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

List<Widget> DifferentFunctionPage = [
  Expanded(
      child: ListView(
    children: [
      GroupCard(title: 'Group 1', descript: 'this is a test 1'),
      SizedBox(
        height: 2,
      ),
      GroupCard(title: 'group 2', descript: 'this is a test 2'),
      SizedBox(
        height: 2,
      ),
      GroupCard(title: 'group 3', descript: 'this is a test 3'),
      SizedBox(
        height: 2,
      ),
      GroupCard(title: 'group 4', descript: 'this is a test 4'),
      SizedBox(
        height: 2,
      ),
      GroupCard(title: 'group 5', descript: 'this is a test 5'),
      SizedBox(
        height: 2,
      ),
      GroupCard(title: 'group 6', descript: 'this is a test 6'),
      // 按下加會同時新增 SizedBox(height: 2,), 跟 createGroupCardView(title, short description)
    ],
  )),
  Expanded(
      child: ListView(
    children: [
      Upcoming(
          group: 'personal',
          title: 'P+ 籃球會',
          descript: '領航員 vs 富邦勇士',
          date1: '9:00 PM, FEB 2, 2023',
          date2: '11:00 PM, FEB 2, 2023'),
      SizedBox(
        height: 2,
      ),
      Upcoming(
          group: 'flutter 讀書會',
          title: '例行性讀書會',
          descript: '討論 UI 設計與狀態儲存',
          date1: '9:00 PM, FEB2, 2023',
          date2: '11:00 PM, FEB 2, 2023')
    ],
  )),
  Expanded(
      child: ListView(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    children: [
      Tracked(
          group: 'personal',
          title: '寒假規劃表進度',
          descript: '年後 ~ 開學的規劃進度',
          date1: '9:00 PM, FEB 2, 2023',
          date2: '11:00 PM, FEB 2, 2023',
          state: 0),
      SizedBox(
        height: 2,
      ),
      Tracked(
          group: 'flutter 讀書會',
          title: '例行性讀書會',
          descript: '討論 UI 設計與狀態儲存',
          date1: '9:00 PM, FEB2, 2023',
          date2: '11:00 PM, FEB 2, 2023',
          state: 1)
    ],
  )),
  Expanded(
      child: ListView(
    children: [Message(messageNumber: 1)],
  ))
];
