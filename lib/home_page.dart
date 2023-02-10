import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grouping_project/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/model/user_model.dart';
import 'firebase_options.dart';

import 'component/createGroupCard.dart';
import 'component/createCardView.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _testPageState();
}

class _testPageState extends State<MyHomePage> {

  var funtionSelect = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
    appBar: AppBar(
      title: Text('QUAN 的工作區'),
      actions: [
        IconButton(onPressed: (){
          print('switch to personal Intro.');
        }, icon: Icon(Icons.circle))
      ],
    ),
    body: Container(
      child: Column(
        children: [
          // 名片位置
          Container(
            margin: EdgeInsets.all(3),
            width: 340,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 2,
                  blurRadius: 2
                )
              ]
            ),
          ),
          SizedBox(height: 3,),
          // 功能選擇區
          Container(
            height: 80,
            width: 300,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4
              ),
              itemCount: 4,
              itemBuilder: ((context, index){
                return 
                Container(margin: EdgeInsets.all(1),
                 decoration: BoxDecoration(border: Border.all(color: Colors.black))
                 ,child: TextButton(onPressed: (){
                  setState(() {
                    funtionSelect = index;
                  });
                },
                child: Center(child: Text(
                  index == 0 ?
                    'WORKSPACE\n小組專區' :
                  index == 1 ?
                    'UPCOMING EVENT\n即將來臨' :
                  index == 2 ?
                    'TRACKED MISSION\n任務追蹤' :
                    'TAGGED MESSAGE\n待回覆'
                ),),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.amberAccent
                ),
                ));
              }) 
            ),
          ),
          SizedBox(height: 3,),
          // 顯示該功能的列表
          DifferentFunctionPage[funtionSelect]
        ]
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: (){
        print('add new event');
      },
      child: Icon(Icons.add),
    ),
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.house), label: 'house'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'calendar'),
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
        CreateGroupCardView('Group 1', 'this is a test 1'),
        SizedBox(height: 2,),
        CreateGroupCardView('group 2', 'this is a test 2'),
        SizedBox(height: 2,),
        CreateGroupCardView('group 3', 'this is a test 3'),
        SizedBox(height: 2,),
        CreateGroupCardView('group 4', 'this is a test 4'),
        SizedBox(height: 2,),
        CreateGroupCardView('group 5', 'this is a test 5'),
        SizedBox(height: 2,),
        CreateGroupCardView('group 6', 'this is a test 6')
      ],
    )
  ),
  Expanded(
    child: ListView(
      children: [
        CreateUpcoming('personal', 'P+ 籃球會', '領航員 vs 富邦勇士', '9:00 PM, FEB 2, 2023', '11:00 PM, FEB 2, 2023'),
        SizedBox(height: 2,),
        CreateUpcoming('flutter 讀書會', '例行性讀書會', '討論 UI 設計與狀態儲存', '9:00 PM, FEB2, 2023', '11:00 PM, FEB 2, 2023')
      ],
    )
  ),
  Expanded(
    child: ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        CreateTracked('personal', '寒假規劃表進度', '年後 ~ 開學的規劃進度', '9:00 PM, FEB 2, 2023', '11:00 PM, FEB 2, 2023', 0),
        SizedBox(height: 2,),
        CreateTracked('flutter 讀書會', '例行性讀書會', '討論 UI 設計與狀態儲存', '9:00 PM, FEB2, 2023', '11:00 PM, FEB 2, 2023', 1)
      ],
    )
  ),
  Expanded(
    child: ListView(
      children: [
        CreateGroupCardView('Group 7', 'this is a test 7'),
        SizedBox(height: 2,),
        CreateGroupCardView('group 8', 'this is a test 8')
      ],
    )
  )
];