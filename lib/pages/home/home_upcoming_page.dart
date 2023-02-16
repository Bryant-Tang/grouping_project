import 'package:grouping_project/components/card_view.dart';
import 'package:grouping_project/service/event_service.dart';

import 'package:flutter/material.dart';

class UpcomingPage extends StatefulWidget {
  UpcomingPage({super.key});
  @override
  State<UpcomingPage> createState() => UpcomingPageState();
}

List<Widget> upcomingCards = [];

class UpcomingPageState extends State<UpcomingPage> {
  @override
  Widget build(BuildContext content) {
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
        return AlertDialog(
          title: Text(
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
                    label: Text('Title'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    contentPadding: EdgeInsets.all(10),
                    isDense: true,
                    errorText: upcomingTitle.isEmpty ? "Can't be empty" : null),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    upcomingDescript = value;
                  });
                },
                decoration: InputDecoration(
                    label: Text('Introduction'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    contentPadding: EdgeInsets.all(10),
                    isDense: true,
                    errorText: upcomingDescript.isEmpty ? "Can't be empty" : null),
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
                    backgroundColor: MaterialStatePropertyAll(Colors.red),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.redAccent)))),
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
                        side: BorderSide(color: Colors.greenAccent)))),
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
  void doneEvent() async {
    if(upcomingTitle == "default" || upcomingDescript == "default"){
      upcomingTitle = upcomingTitle == "default" ? '' : upcomingTitle;
      upcomingDescript = upcomingDescript == "default" ? '' : upcomingDescript;
      setState(() {
      });
    }
    if(upcomingTitle.isEmpty || upcomingDescript.isEmpty){
      upcomingTitle = upcomingTitle.isEmpty ? '' : upcomingTitle;
      upcomingDescript = upcomingDescript.isEmpty ? '' : upcomingDescript;
      setState(() {
      });
    }
    else{
      await createEventData(
          userOrGroupId: 'personal',
          eventId: 'test',
          title: upcomingTitle,
          introduction: upcomingDescript,
          startTime: DateTime.now(),
          endTime: DateTime.now());
      await addUpcoming();
      setState(
        () {
          Navigator.pop(context);
        },
      );
      upcomingTitle = "default";
      upcomingDescript = "default";
    }
  }
}

Map monthDigitToLetter = <int, String>{
  1: "JAN",
  2: "FEB",
  3: "MAR",
  4: "APR",
  5: "MAY",
  6: "JUN",
  7: "JUL",
  8: "AUG",
  9: "SEP",
  10: "OCT",
  11: "NOV",
  12: "DEC"
};

Future<void> addUpcoming() async {
  // userOrGroupId : personal ID
  var allDatas = await getAllEventData(userOrGroupId: 'personal');

  upcomingCards = [];
  for (int index = 0; index < allDatas.length; index++) {
    var upcoming = allDatas[index];
    upcomingCards.add(const SizedBox(
      height: 2,
    ));
    // pass Datatime
    DateTime startTime = upcoming!.startTime;
    DateTime endTime = upcoming.endTime;
    upcomingCards.add(
        // title tmp
        Upcoming(
            group: 'personal',
            title: upcoming.title,
            descript: upcoming.introduction,
            date1:
                '${startTime.hour >= 12 ? startTime.hour - 12 : startTime.hour}:${startTime.minute} ${startTime.hour >= 12 ? "PM" : "AM"}, ${monthDigitToLetter[startTime.month]} ${startTime.day}, ${startTime.year}',
            date2:
                '${endTime.hour >= 12 ? endTime.hour - 12 : endTime.hour}:${endTime.minute} ${endTime.hour >= 12 ? "PM" : "AM"}, ${monthDigitToLetter[endTime.month]} ${endTime.day}, ${endTime.year}'));
  }
}
