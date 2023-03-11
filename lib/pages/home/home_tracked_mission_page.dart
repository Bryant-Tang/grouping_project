//import 'package:grouping_project/components/card_view.dart';
import 'package:grouping_project/components/card_view/mission_information.dart';
import 'package:grouping_project/components/card_view/card_view_template.dart';
import 'package:grouping_project/model/user_model.dart';

import 'package:flutter/material.dart';
import 'package:grouping_project/model_lib.dart';
import 'package:provider/provider.dart';

class TrackedPage extends StatefulWidget {
  const TrackedPage({super.key});
  @override
  State<TrackedPage> createState() => TrackedPageState();
}

List<Widget> trackedCards = [];

class TrackedPageState extends State<TrackedPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height - 80,
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: trackedCards +
                <Widget>[
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _inquireInputDialog(context);
                        });
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

  String trackedTitle = "default";
  String trackedDescript = "default";
  _inquireInputDialog(BuildContext context) {
    StatefulBuilder dialogStateful() {
      return StatefulBuilder(builder: (context, StateSetter setState) {
        // 將創建資料拉到外面執行
        void doneEvent() async {
          // 檢查是否為不合理輸入
          if (trackedTitle == "default" || trackedDescript == "default") {
            trackedTitle = trackedTitle == "default" ? '' : trackedTitle;
            trackedDescript =
                trackedDescript == "default" ? '' : trackedDescript;
            setState(() {});
          }
          if (trackedTitle.isEmpty || trackedDescript.isEmpty) {
            trackedTitle = trackedTitle.isEmpty ? '' : trackedTitle;
            trackedDescript = trackedDescript.isEmpty ? '' : trackedDescript;
            setState(() {});
          } else {
            await passDataAndCreate();
            trackedTitle = "default";
            trackedDescript = "default";
          }
        }

        // 創造小視窗
        return AlertDialog(
          title: const Text(
            'Create New Tracked Mission',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    trackedTitle = value;
                  });
                },
                decoration: InputDecoration(
                    label: const Text('Title'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    contentPadding: const EdgeInsets.all(10),
                    isDense: true,
                    errorText: trackedTitle.isEmpty ? "Can't be empty" : null),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    trackedDescript = value;
                  });
                },
                decoration: InputDecoration(
                    label: const Text('Introduction'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    contentPadding: const EdgeInsets.all(10),
                    isDense: true,
                    errorText:
                        trackedDescript.isEmpty ? "Can't be empty" : null),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    trackedTitle = "default";
                    trackedDescript = "default";
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
    // String userId = Provider.of<UserModel>(context).uid;
    // await createMissionData(
    //     userOrGroupId: userId,
    //     title: trackedTitle,
    //     introduction: trackedDescript,
    //     startTime: DateTime.now(),
    //     endTime: DateTime.now());
    MissionModel missionModel = MissionModel(
      title: trackedTitle,
      introduction: trackedDescript,
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      state: MissionState.inProgress
    );
    await missionModel.set();
    await addTracked();
    setState(
      () {
        Navigator.pop(context);
      },
    );
  }
}

Future<void> addTracked() async {
  // userOrGroupId : personal ID
  var allDatas = await MissionModel().getAll();
  trackedCards = [];
  for (int index = 0; index < allDatas.length; index++) {
    var tracked = allDatas[index];
    trackedCards.add(const SizedBox(
      height: 2,
    ));

    
    MissionInformationShrink shrink = MissionInformationShrink(
      group: tracked.ownerName,
      color: Color(int.parse(tracked.color)),
      contributors: tracked.contributors ?? [],
      title: tracked.title ?? 'unknown',
      descript: tracked.introduction ?? 'unknown',
      eventId: tracked.id,
      startTime: tracked.startTime ?? DateTime(0),
      endTime: tracked.endTime ?? DateTime(0),
      state: MissionState.inProgress,);

    trackedCards.add(
      CardViewTemplate(detailShrink: shrink, detailEnlarge: shrink)
    );
  }
}
