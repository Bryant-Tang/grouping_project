import 'package:flutter/material.dart';
import 'package:grouping_project/components/card_view/enlarge_controller_view.dart';
import 'package:grouping_project/model/model_lib.dart';

import 'package:intl/intl.dart';

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

String intFixed(int n, int count) => n.toString().padLeft(count, "0");

// anti-label pass color data?
// this is for shrink card
class EventInformationShrink extends StatelessWidget {
  /// 這個 class 實現了 event 縮小時要展現的資訊
  /// 藉由創建時得到的資料來回傳一個 Container 回去
  /// ps. 需與 cardViewTemplate 一起使用
  const EventInformationShrink({super.key, required this.eventModel});

  final EventModel eventModel;

  @override
  Widget build(BuildContext context) {
    String group = eventModel.ownerName;
    String title = eventModel.title ?? 'unknown';
    String descript = eventModel.introduction ?? 'unknown';
    DateTime startTime = eventModel.startTime ?? DateTime(0);
    DateTime endTime = eventModel.endTime ?? DateTime(0);
    List<String> contributorIds = eventModel.contributorIds ?? [];
    Color color = Color(eventModel.color);
    // String group = 'personal';
    // String title = 'Test titel';
    // String descript = 'This is a information test';
    // DateTime startTime = DateTime(0);
    // DateTime endTime = DateTime.now();
    // List<String> contributorIds = [];
    // Color color = Colors.amber;

    DateFormat parseDate = DateFormat('h:mm a, MMM d, yyyy');

    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntiLabel(
            group: group,
            color: Colors.amber,
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            descript.split('\n').length > 1 ? '${descript.split('\n')[0]}...' : descript,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(
            height: 1,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Text(
                  parseDate.format(startTime),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const Icon(
                  Icons.arrow_right_alt,
                  size: 20,
                  color: Colors.amber,
                ),
                Text(
                  parseDate.format(endTime),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ])
        ],
      ),
    );
  }
}
