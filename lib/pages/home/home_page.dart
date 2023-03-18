import 'package:grouping_project/pages/home/card_edit_page.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/components/message.dart';
import 'package:grouping_project/pages/auth/login.dart';

// progress card
import 'package:grouping_project/components/card_view/progress.dart';
import 'package:grouping_project/pages/home/home_page/over_view.dart';

// 測試新功能用，尚未完工，請勿使用或刪除
import 'package:grouping_project/components/card_view/card_view_template.dart';
import 'package:grouping_project/pages/home/home_page/empty.dart';
import 'package:grouping_project/components/card_view/event_information.dart';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _TestPageState();
}

class _TestPageState extends State<MyHomePage> {
  final AuthService _authService = AuthService();
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CardEditDone()));
                },
                // 改變成使用者或團體的頭像 !!!!!!!!!!!
                icon: const Icon(Icons.circle)),
            IconButton(
                //temp remove async for quick test
                onPressed: () async {
                  _authService.signOut();
                  _authService.googleSignOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: const Icon(Icons.logout_outlined)),
          ],
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const[
            Expanded(
              flex: 2,
              child: Progress(),
            ),
            // Progress 位置
            SizedBox(
              height: 3,
            ),
            Expanded(
              flex: 5,
              child: OverView()
            ),
            // const SizedBox(
            //   height: 3,
            // ),
            // Expanded(
            //   flex: 5,
            //   child: differentFunctionPage[funtionSelect],
            // )
          ]),
        ),
        // 利用 extendBody: true 以及 BottomAppBar 的 shape, clipBehavior
        // 可以使得 bottom navigation bar 給 FAB 空間
        // ps. https://stackoverflow.com/questions/59455684/how-to-make-bottomnavigationbar-notch-transparent
        extendBody: true,
        floatingActionButton: Container(
          width: 50,
          height: 50,
          child: FloatingActionButton(
            onPressed: () {
              debugPrint('add new event');
            },
            child: const Icon(
              Icons.add,
              color: Color(0xFFFFFFFF),
              size: 30,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.house), label: 'house'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: 'calendar'),
              BottomNavigationBarItem(icon: Icon(Icons.note), label: 'note'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message), label: 'message')
            ],
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
          ),
        ));
  }
}

// this is test, don't delete it
EventInformationShrink shrink = EventInformationShrink(
  group: "personal",
  title: "test title",
  descript: "test information",
  color: Color(0xFFFFc953),
  contributors: [],
  eventId: "123456",
  startTime: DateTime(0),
  endTime: DateTime.now(),
);

EventInformationEnlarge enlarge = EventInformationEnlarge(
  group: "personal",
  title: "test title",
  descript: "test information",
  color: Color(0xFFFFc953),
  contributors: [],
  eventId: "123456",
  startTime: DateTime(0),
  endTime: DateTime.now(),
);

List<Widget> differentFunctionPage = [
  Expanded(
      child: ListView(
    // children: const [
    children: [
      //GroupPage()

      CardViewTemplate(detailShrink: shrink, detailEnlarge: enlarge)
    ],
  )),
  Expanded(
      child: ListView(
    children: const [
      // UpcomingExpand(
      //     group: 'personal',
      //     title: 'P+ 籃球會',
      //     descript: '領航員 vs 富邦勇士',
      //     date1: '9:00 PM, FEB 2, 2023',
      //     date2: '11:00 PM, FEB 2, 2023'),
      //UpcomingPage()
      const Placeholder()
    ],
  )),
  Expanded(
      child: ListView(
    // children: const [TrackedPage()],
    children: [const Placeholder()],
  )),
  Expanded(
      child: ListView(
    children: [Message(messageNumber: 1)],
  ))
];
