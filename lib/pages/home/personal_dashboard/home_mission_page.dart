import 'package:flutter/material.dart';
import 'package:grouping_project/components/card_view/card_view_template.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/components/card_view/mission_information.dart';

class MissionPage extends StatefulWidget {
  const MissionPage({super.key});
  @override
  State<MissionPage> createState() => MissionPageState();
}

List<Widget> missionCards = [];

class MissionPageState extends State<MissionPage> {
  
  @override
  void initState() async{
    super.initState();
    await showMissions();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height - 80,
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: missionCards
          )
        ],
      ),
    );

  // String trackedTitle = "default";
  // String trackedDescript = "default";
  // _inquireInputDialog(BuildContext context) {
  //   StatefulBuilder dialogStateful() {
  //     return StatefulBuilder(builder: (context, StateSetter setState) {
  //       // 將創建資料拉到外面執行
  //       void doneEvent() async {
  //         // 檢查是否為不合理輸入
  //         if (trackedTitle == "default" || trackedDescript == "default") {
  //           trackedTitle = trackedTitle == "default" ? '' : trackedTitle;
  //           trackedDescript =
  //               trackedDescript == "default" ? '' : trackedDescript;
  //           setState(() {});
  //         }
  //         if (trackedTitle.isEmpty || trackedDescript.isEmpty) {
  //           trackedTitle = trackedTitle.isEmpty ? '' : trackedTitle;
  //           trackedDescript = trackedDescript.isEmpty ? '' : trackedDescript;
  //           setState(() {});
  //         } else {
  //           await passDataAndCreate();
  //           trackedTitle = "default";
  //           trackedDescript = "default";
  //         }
  //       }

  //       // 創造小視窗
  //       return AlertDialog(
  //         title: const Text(
  //           'Create New Tracked Mission',
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         content: Column(
  //           children: [
  //             TextField(
  //               onChanged: (value) {
  //                 setState(() {
  //                   trackedTitle = value;
  //                 });
  //               },
  //               decoration: InputDecoration(
  //                   label: const Text('Title'),
  //                   border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(100)),
  //                   contentPadding: const EdgeInsets.all(10),
  //                   isDense: true,
  //                   errorText: trackedTitle.isEmpty ? "Can't be empty" : null),
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             TextField(
  //               onChanged: (value) {
  //                 setState(() {
  //                   trackedDescript = value;
  //                 });
  //               },
  //               decoration: InputDecoration(
  //                   label: const Text('Introduction'),
  //                   border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(100)),
  //                   contentPadding: const EdgeInsets.all(10),
  //                   isDense: true,
  //                   errorText:
  //                       trackedDescript.isEmpty ? "Can't be empty" : null),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //               onPressed: () {
  //                 setState(() {
  //                   trackedTitle = "default";
  //                   trackedDescript = "default";
  //                   Navigator.pop(context);
  //                 });
  //               },
  //               style: ButtonStyle(
  //                   backgroundColor: const MaterialStatePropertyAll(Colors.red),
  //                   shape: MaterialStatePropertyAll(RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                       side: const BorderSide(color: Colors.redAccent)))),
  //               child: const Text(
  //                 'Cancel',
  //                 style: TextStyle(
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white),
  //               )),
  //           TextButton(
  //               onPressed: doneEvent,
  //               style: ButtonStyle(
  //                   backgroundColor: MaterialStateProperty.all(Colors.green),
  //                   shape: MaterialStateProperty.all(RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                       side: const BorderSide(color: Colors.greenAccent)))),
  //               child: const Text(
  //                 'Done',
  //                 style: TextStyle(
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white),
  //               ))
  //         ],
  //       );
  //     });
  //   }

  //   // 因為 showDialog 是 Stateless Widget，所以要另外寫一個 Stateful function
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return dialogStateful();
  //       });
  // }

  // // 創建新event都需要一個自己的eventID，否則會被覆蓋掉(未解決)
  // Future<void> passDataAndCreate() async {
  //   String userId = Provider.of<UserModel>(context).uid;
  //   // await createMissionData(
  //   //     userOrGroupId: userId,
  //   //     title: trackedTitle,
  //   //     introduction: trackedDescript,
  //   //     startTime: DateTime.now(),
  //   //     endTime: DateTime.now());
  //   // await addTracked(userId: userId);
  //   setState(
  //     () {
  //       Navigator.pop(context);
  //     },
  //   );
  }
}

Future<void> showMissions() async {
  var allDatas = await DataController().downloadAll(dataTypeToGet: MissionModel());
  missionCards = [];
  for (int index = 0; index < allDatas.length; index++) {
    var mission = allDatas[index];
    missionCards.add(const SizedBox(
      height: 2,
    ));
    // MissionInformationShrink shrink = MissionInformationShrink(
    //   group: mission.ownerName,
    //   color: Color(mission.color),
    //   contributors: mission.contributors ?? [],
    //   title: mission.title ?? 'unknown',
    //   descript: mission.introduction ?? 'unknown',
    //   startTime: mission.startTime ?? DateTime(0),
    //   endTime: mission.endTime ?? DateTime(0),
    //   state: MissionState.inProgress,);

    // missionCards.add(
    //   CardViewTemplate(detailShrink: shrink, detailEnlarge: shrink)
    // );
  }
}
