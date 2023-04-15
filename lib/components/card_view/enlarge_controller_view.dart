import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';

import 'package:intl/intl.dart';
import 'dart:io' as io show File;

String diff(DateTime end) {
  Duration difference = end.difference(DateTime.now());

  int days = difference.inDays;
  int hours = difference.inHours % 24;
  int minutes = difference.inMinutes % 60;

  return '剩餘 $days D $hours H $minutes M';
}

class AntiLabel extends StatelessWidget {
  /// 標籤反白的 group

  const AntiLabel({super.key, required this.group, required this.color});
  final String group;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Text(
          ' •$group ',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ));
  }
}

class TitleDateOfEvent extends StatelessWidget {
  const TitleDateOfEvent(
      {super.key,
      required this.title,
      required this.startTime,
      required this.endTime,
      required this.group,
      required this.color});

  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String group;
  final Color color;

  @override
  Widget build(BuildContext context) {
    DateFormat parseDate = DateFormat('h:mm a, MMM d, yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntiLabel(group: group, color: color),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
              parseDate.format(startTime),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.arrow_right_alt,
              size: 20,
              // color will be a variable
              color: color,
            ),
            Text(
              parseDate.format(endTime),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.access_time,
              size: 20,
              color: Colors.amber,
            ),
            Text(
              diff(endTime),
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
            )
          ],
        )
      ],
    );
  }
}

class Contributors extends StatefulWidget {
  //參與的所有使用者
  const Contributors({super.key, required this.contributorIds});
  final List<String> contributorIds;

  @override
  State<Contributors> createState() => _ContributorState();
}

class _ContributorState extends State<Contributors> {
  List<Container> people = [];

  Future<Container> createHeadShot(String person) async {
    /// 回傳 contributor 的頭貼

    var userData = await DataController()
        .download(dataTypeToGet: ProfileModel(), dataId: person);
    io.File photo = userData.photo ?? io.File('assets/images/cover.png');

    return Container(
        height: 30,
        width: 30,
        decoration: ShapeDecoration(
          shape: const CircleBorder(side: BorderSide(color: Colors.black)),
          color: Colors.blueAccent,
          image: DecorationImage(image: FileImage(photo)),
        ));
  }

  Future<void> datas() async {
    for (int i = 0; i < widget.contributorIds.length; i++) {
      people.add(await createHeadShot(widget.contributorIds[i]));
    }
  }

  @override
  void initState() {
    super.initState();
    datas().then((value) => setState(
          () {},
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: people,
    );
  }
}

class CollabMissons extends StatelessWidget {
  const CollabMissons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 2)
              ]),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '寒假規劃表進度',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  '距離死線剩餘 ? D ? H ? M',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black26),
              child: Text(
                'Not Start 未開始',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            )
          ]),
        ));
  }
}

class CollabNotes extends StatefulWidget {
  const CollabNotes({super.key});

  @override
  State<CollabNotes> createState() => _collabNotesState();
}

class _collabNotesState extends State<CollabNotes> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: 60,
        child: Stack(
          children: [
            Positioned(
              left: 5,
              top: 8,
              child: Row(children: [
                Icon(Icons.menu_book_rounded),
                SizedBox(
                  width: 1,
                ),
                Text(
                  '開發紀錄',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )
              ]),
            ),
            Positioned(
              left: 5,
              bottom: 8,
              child: Text(
                'Someone 在 5 分鐘前編輯',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CollabMeetings extends StatefulWidget {
  const CollabMeetings({super.key});

  @override
  State<CollabMeetings> createState() => _collabMeetingsState();
}

class _collabMeetingsState extends State<CollabMeetings> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: 60,
        child: Stack(
          children: [
            Positioned(
              left: 5,
              top: 8,
              child: Row(children: [
                Icon(Icons.menu_book_rounded),
                SizedBox(
                  width: 1,
                ),
                Text(
                  '會議記錄',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )
              ]),
            ),
            Positioned(
              left: 5,
              bottom: 8,
              child: Text(
                '15 則新訊息未讀',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
