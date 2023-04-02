import 'package:googleapis/mybusinessbusinessinformation/v1.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/auth/user.dart';
import 'package:grouping_project/pages/home/card_edit_page.dart';
import 'package:grouping_project/pages/home/navigation_bar.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/pages/auth/login.dart';

// progress card
import 'package:grouping_project/components/card_view/progress.dart';
import 'package:grouping_project/pages/home/home_page/over_view.dart';

// show frame of widget
// import 'package:flutter/rendering.dart';

// 測試新功能用，尚未完工，請勿使用或刪除
import 'package:grouping_project/components/create/add_topic.dart';
import 'package:grouping_project/components/create/add_event.dart';
import 'package:grouping_project/components/create/add_note.dart';
import 'package:grouping_project/components/create/add_mission.dart';
import 'package:grouping_project/pages/home/home_page/empty.dart';

import 'package:flutter/material.dart';

class PeronalDashboardPage extends StatefulWidget {
  const PeronalDashboardPage({super.key});
  @override
  State<PeronalDashboardPage> createState() => _TestPageState();
}

class _TestPageState extends State<PeronalDashboardPage> {
  final AuthService _authService = AuthService();
  ProfileModel profile = ProfileModel();
  var funtionSelect = 0;

  // var addNewEventHeight = -300.0;
  @override
  void initState() {
    super.initState();
    DataController()
        .download(dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!)
        .then((value) {
      setState(() {
        profile = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // show the from of widget
    // debugPaintSizeEnabled = true;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            // ignore: todo
            // TODO: Get User Name from data package
            profile.name ?? "Unknown",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => EmptyWidget()));
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
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 120,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Expanded(
                  flex: 2,
                  child: Progress(),
                ),
                // Progress 位置
                SizedBox(
                  height: 3,
                ),
                Expanded(flex: 5, child: OverView()),
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
              showModalBottomSheet(
                  context: context,
                  barrierColor: Colors.black12,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  builder: (BuildContext context) {
                    return SizedBox(
                        height: 475,
                        child: Column(children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 20,
                            decoration: const BoxDecoration(
                                color: Color(0xFFFFB782),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                          ),
                          const SizedBox(
                            height: 50,
                            child: Center(
                                child: Text(
                              'Create',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 390,
                            child: GridView.builder(
                                itemCount: 4,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  return createsPng[index];
                                }),
                          )
                        ]));
                  });
            },
            child: const Icon(
              Icons.add,
              color: Color(0xFFFFFFFF),
              size: 30,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const NavigationAppBar()
    );
  }
}

List<StatelessWidget> createsPng = const [
  AddTopic(),
  AddEvent(),
  AddNote(),
  AddMission()
];
