
//import 'package:grouping_project/components/card_view.dart';
import 'package:grouping_project/model/model_lib.dart';

import '';
import 'package:grouping_project/components/card_view/event_information.dart';
import 'package:grouping_project/components/card_view/card_view_template.dart';


import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});
  @override
  State<EventPage> createState() => EventPageState();
}

List<Widget> eventCards = [];

class EventPageState extends State<EventPage> {

  @override
  void initState() async{
    super.initState();
    await showEvents();
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
            children: eventCards
          )
        ],
      ),
    );
  // }

  // String upcomingTitle = "default";
  // String upcomingDescript = "default";
  // _inquireInputDialog(BuildContext context) {
  //   StatefulBuilder dialogStateful() {
  //     return StatefulBuilder(builder: (context, StateSetter setState) {
  //       // 將創建資料拉到外面執行
  //       void doneEvent() async {
  //         // 檢查是否為不合理輸入
  //         if (upcomingTitle == "default" || upcomingDescript == "default") {
  //           upcomingTitle = upcomingTitle == "default" ? '' : upcomingTitle;
  //           upcomingDescript =
  //               upcomingDescript == "default" ? '' : upcomingDescript;
  //           setState(() {});
  //         }
  //         if (upcomingTitle.isEmpty || upcomingDescript.isEmpty) {
  //           upcomingTitle = upcomingTitle.isEmpty ? '' : upcomingTitle;
  //           upcomingDescript = upcomingDescript.isEmpty ? '' : upcomingDescript;
  //           setState(() {});
  //         } else {
  //           await passDataAndCreate();
  //           upcomingTitle = "default";
  //           upcomingDescript = "default";
  //         }
  //       }

  //       // 創造小視窗
  //       return AlertDialog(
  //         title: const Text(
  //           'Create New Upcoming',
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         content: Column(
  //           children: [
  //             TextField(
  //               onChanged: (value) {
  //                 setState(() {
  //                   upcomingTitle = value;
  //                 });
  //               },
  //               decoration: InputDecoration(
  //                   label: const Text('Title'),
  //                   border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(100)),
  //                   contentPadding: const EdgeInsets.all(10),
  //                   isDense: true,
  //                   errorText: upcomingTitle.isEmpty ? "Can't be empty" : null),
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             TextField(
  //               onChanged: (value) {
  //                 setState(() {
  //                   upcomingDescript = value;
  //                 });
  //               },
  //               decoration: InputDecoration(
  //                   label: const Text('Introduction'),
  //                   border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(100)),
  //                   contentPadding: const EdgeInsets.all(10),
  //                   isDense: true,
  //                   errorText:
  //                       upcomingDescript.isEmpty ? "Can't be empty" : null),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //               onPressed: () {
  //                 setState(() {
  //                   upcomingTitle = "default";
  //                   upcomingDescript = "default";
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

  // 創建新event都需要一個自己的eventID，否則會被覆蓋掉(未解決)
  // Future<void> passDataAndCreate() async {
  //   final AuthService authService = AuthService();
  //   String userId = authService.getUid();
  //   EventModel eventModel = EventModel(
  //       title: upcomingTitle,
  //       introduction: upcomingDescript,
  //       startTime: DateTime.now(),
  //       endTime: DateTime.now()
  //   );
  //   //await createEventDataForPerson();
    
  //   // await addUpcoming(userId: userId);
  //   setState(
  //     () {
  //       Navigator.pop(context);
  //     },
  //   );
  }
}



Future<void> showEvents() async {
  var allDatas = await DataController().downloadAll(dataTypeToGet: EventModel());

  eventCards = [];
  for (int index = 0; index < allDatas.length; index++) {
    var event = allDatas[index];
    eventCards.add(const SizedBox(
      height: 2,
    ));
    EventInformationShrink shrink = EventInformationShrink(
      group: event.ownerName,
      color: Color(event.color),
      contributorIds: event.contributorIds ?? [],
      title: event.title ?? 'unknown',
      descript: event.introduction ?? 'unknown',
      startTime: event.startTime ?? DateTime(0),
      endTime: event.endTime ?? DateTime(0),);


    eventCards.add(
      CardViewTemplate(detailShrink: shrink, detailEnlarge: shrink)
    );
  }
}
