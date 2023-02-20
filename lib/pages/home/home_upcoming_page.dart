import 'package:grouping_project/components/card_view.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/service/event_service.dart';

import 'package:flutter/material.dart';

class UpcomingPage extends StatefulWidget {
  const UpcomingPage({super.key});
  @override
  State<UpcomingPage> createState() => UpcomingPageState();
}

List<Widget> upcomingCards = [];

class UpcomingPageState extends State<UpcomingPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height - 80,
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: upcomingCards +
                <Widget>[
                  TextButton(
                      onPressed: () {
                        _inquireInputDialog(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.amber, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                            child: Icon(
                          Icons.add,
                          color: Colors.amber,
                        )),
                      ))
                ],
          )
        ],
      ),
    );
  }

  String upcomingTitle = "default";
  String upcomingDescript = "default";
  _inquireInputDialog(BuildContext context) {
    StatefulBuilder dialogStateful() {
      return StatefulBuilder(builder: (context, StateSetter setState) {
        // 將創建資料拉到外面執行
        void doneEvent() async {
          // 檢查是否為不合理輸入
          if (upcomingTitle == "default" || upcomingDescript == "default") {
            upcomingTitle = upcomingTitle == "default" ? '' : upcomingTitle;
            upcomingDescript =
                upcomingDescript == "default" ? '' : upcomingDescript;
            setState(() {});
          }
          if (upcomingTitle.isEmpty || upcomingDescript.isEmpty) {
            upcomingTitle = upcomingTitle.isEmpty ? '' : upcomingTitle;
            upcomingDescript = upcomingDescript.isEmpty ? '' : upcomingDescript;
            setState(() {});
          } else {
            await passDataAndCreate();
            upcomingTitle = "default";
            upcomingDescript = "default";
          }
        }

        // 創造小視窗
        return AlertDialog(
          title: const Text(
            'Create New Upcoming',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    upcomingTitle = value;
                  });
                },
                decoration: InputDecoration(
                    label: const Text('Title'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    contentPadding: const EdgeInsets.all(10),
                    isDense: true,
                    errorText: upcomingTitle.isEmpty ? "Can't be empty" : null),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    upcomingDescript = value;
                  });
                },
                decoration: InputDecoration(
                    label: const Text('Introduction'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    contentPadding: const EdgeInsets.all(10),
                    isDense: true,
                    errorText:
                        upcomingDescript.isEmpty ? "Can't be empty" : null),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    upcomingTitle = "default";
                    upcomingDescript = "default";
                    Navigator.pop(context);
                  });
                },
                style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(Colors.red),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.redAccent)))),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
            TextButton(
                onPressed: doneEvent,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.greenAccent)))),
                child: const Text(
                  'Done',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ))
          ],
        );
      });
    }

    // 因為 showDialog 是 Stateless Widget，所以要另外寫一個 Stateful function
    return showDialog(
        context: context,
        builder: (context) {
          return dialogStateful();
        });
  }

  // 創建新event都需要一個自己的eventID，否則會被覆蓋掉(未解決)
  Future<void> passDataAndCreate() async {
    final AuthService authService = AuthService();
    String userId = authService.getUid();
    await createEventData(
        userOrGroupId: userId,
        title: upcomingTitle,
        introduction: upcomingDescript,
        startTime: DateTime.now(),
        endTime: DateTime.now());
    await addUpcoming(userId: userId);
    setState(
      () {
        Navigator.pop(context);
      },
    );
  }
}

Future<void> addUpcoming({required String userId}) async {
  // userOrGroupId : personal ID
  var allDatas = await getAllEventData(userOrGroupId: userId);

  upcomingCards = [];
  for (int index = 0; index < allDatas.length; index++) {
    var upcoming = allDatas[index];
    upcomingCards.add(const SizedBox(
      height: 2,
    ));

    // // pass Datatime
    // DateTime startTime = upcoming!.startTime;
    // DateTime endTime = upcoming.endTime;
    Widget useCard = Upcoming(
        group: upcoming.belong,
        title: upcoming.title ?? 'unknown',
        descript: upcoming.introduction ?? 'unknown',
        startTime: upcoming.startTime ?? DateTime(0),
        endTime: upcoming.endTime ?? DateTime(0));
    // upcomingCards.add(Ink(
    //   width: 100,
    //   height: 50,
    //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
    //   child: InkWell(
    //     onTap: () {
    //       //upcomingCards.elementAt(upcomingCards.indexOf());
    //     },
    //     splashColor: Colors.black12,
    //     onLongPress: () {},
    //     highlightColor: Colors.black26,
    //     child: useCard,
    //   ),
    // ));

    upcomingCards.add(
        // title tmp
        Upcoming(
            group: upcoming.belong,
            title: upcoming.title ?? 'unknown',
            descript: upcoming.introduction ?? 'unknown',
            startTime: upcoming.startTime ?? DateTime(0),
            endTime: upcoming.endTime ?? DateTime(0)));
  }
}
