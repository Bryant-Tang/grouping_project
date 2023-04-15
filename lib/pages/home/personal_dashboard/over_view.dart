import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouping_project/components/card_view/event/event_card_view.dart';
import 'package:grouping_project/components/card_view/event_information.dart';
import 'package:grouping_project/components/overview_choice_button.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_event_page.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_mission_page.dart';

class OverView extends StatefulWidget {
  const OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  int overViewIndex = 0;
  late int eventNumbers = 0;
  late int missionNumbers = 0;

  DataController dataController = DataController();

  List<Widget> pages = [
    const EventPage(),
    const MissionPage(),
    // ListView(
    //   children: [
    //     Container(
    //       height: 100,
    //       decoration: BoxDecoration(border: Border.all(color: Colors.red)),
    //     ),
    //   ],
    // ),
    ListView(
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    dataController.downloadAll(dataTypeToGet: EventModel()).then((value) {
      eventNumbers = value.length;
      setState(() {});
    });
    dataController.downloadAll(dataTypeToGet: MissionModel()).then((value) {
      missionNumbers = value.length;
      setState(() {});
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  final headLine = const Text(
    'OVERVIEW',
    style: TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Color(0XFF717171)),
  );
  final line = const Divider(
    height: 1,
    thickness: 1,
    color: Color(0XFF999898),
  );
  List<bool> isSelectedList = [true, false, false];
  setEnable(int index) {
    overViewIndex = index;
    setState(() {
      for (int i = 0; i < isSelectedList.length; i++) {
        if (i == index) {
          isSelectedList[i] = true;
        } else {
          isSelectedList[i] = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headLine,
          line,
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: OverViewChoiceButton(
                      onTap: () {
                        setEnable(0);
                      },
                      labelText: '事件 - 即將到來',
                      iconPath: 'assets/icons/calendartick.svg',
                      numberText: eventNumbers,
                      isSelected: isSelectedList[0],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: OverViewChoiceButton(
                      onTap: () {
                        setEnable(1);
                      },
                      labelText: '任務 - 追蹤中',
                      iconPath: 'assets/icons/task.svg',
                      numberText: missionNumbers,
                      isSelected: isSelectedList[1],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: OverViewChoiceButton(
                      onTap: () {
                        setEnable(2);
                      },
                      labelText: '話題 - 代回覆',
                      iconPath: 'assets/icons/messagetick.svg',
                      numberText: eventNumbers,
                      isSelected: isSelectedList[2],
                    ),
                  ),
                ),
              ]),
          Expanded(
            flex: 4,
            child: Container(child: pages[overViewIndex]),
            // child: Container(
            //   decoration:
            //       BoxDecoration(border: Border.all(color: Colors.black)),
            // ),
          )
        ],
      ),
    );
  }
}

// 待確認是否應該是要將 listview 放在 container 裡面
// List<Widget> pages = [
// Expanded(child: ListView(children: const [EventPage()])),
// Expanded(child: ListView(
//   children: const [MissionPage()],
// )),
// ListView(
//   children: [
//     Container(
//       height: 100,
//       decoration: BoxDecoration(border: Border.all(color: Colors.black)),
//     ),
//     const EventPage(),
//     // CardViewTemplate(detailShrink: EventInformationShrink(eventModel: EventModel()), detailEnlarge: EventInformationEnlarge(eventModel: EventModel()))
//   ],
// ),
//   const EventPage(),
//   ListView(
//     children: [
//       Container(
//         height: 100,
//         decoration: BoxDecoration(border: Border.all(color: Colors.red)),
//       ),
//     ],
//   ),
//   ListView(
//     children: [
//       Container(
//         height: 100,
//         decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
//       ),
//     ],
//   ),
// ];
