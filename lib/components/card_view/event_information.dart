import 'package:flutter/material.dart';
import 'package:grouping_project/components/card_view/information_fragment_enlarge.dart';
import 'package:grouping_project/service/event_service.dart';
import 'package:grouping_project/service/profile_service.dart';

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
  const EventInformationShrink(
      {super.key,
      required this.group,
      required this.title,
      required this.descript,
      required this.startTime,
      required this.endTime,
      required this.eventId});

  final String group;
  final String title;
  final String descript;
  final DateTime startTime;
  final DateTime endTime;
  final String eventId;

  @override
  Widget build(BuildContext context) {
    String date1 =
        '${intFixed(startTime.hour >= 12 ? startTime.hour - 12 : startTime.hour, 2)}:${intFixed(startTime.minute, 2)} ${startTime.hour >= 12 ? "PM" : "AM"}, ${monthDigitToLetter[startTime.month]} ${startTime.day}, ${startTime.year}';
    String date2 =
        '${intFixed(endTime.hour >= 12 ? endTime.hour - 12 : endTime.hour, 2)}:${intFixed(endTime.minute, 2)} ${endTime.hour >= 12 ? "PM" : "AM"}, ${monthDigitToLetter[endTime.month]} ${endTime.day}, ${endTime.year}';

    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 84,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntiLabel(group: group),
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
            descript,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(
            height: 1,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Text(
                  date1,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold),
                ),
                const Icon(
                  Icons.arrow_right_alt,
                  size: 20,
                  color: Colors.amber,
                ),
                Text(
                  date2,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ])
        ],
      ),
    );
  }
}

class EventInformationEnlarge extends StatelessWidget{
  /// (未完成!!)
  /// 這個 class 實現了 event 放大時要展現的資訊
  /// 藉由創建時得到的資料來回傳一個 Container 回去
  /// ps. 需與 cardViewTemplate 一起使用
  const EventInformationEnlarge(
      {super.key,
      required this.group,
      required this.title,
      required this.descript,
      required this.startTime,
      required this.endTime,});
  
  final String group;
  final String title;
  final String descript;
  final DateTime startTime;
  final DateTime endTime;

  //Color usingColor;

  @override
  Widget build(BuildContext context){
    String date1 =
        '${intFixed(startTime.hour >= 12 ? startTime.hour - 12 : startTime.hour, 2)}:${intFixed(startTime.minute, 2)} ${startTime.hour >= 12 ? "PM" : "AM"}, ${monthDigitToLetter[startTime.month]} ${startTime.day}, ${startTime.year}';
    String date2 =
        '${intFixed(endTime.hour >= 12 ? endTime.hour - 12 : endTime.hour, 2)}:${intFixed(endTime.minute, 2)} ${endTime.hour >= 12 ? "PM" : "AM"}, ${monthDigitToLetter[endTime.month]} ${endTime.day}, ${endTime.year}';

    List<UserProfile> emptyTest = [];

    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 450,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, style: const TextStyle(fontSize: 13),),
            Row(children: const [Icon(Icons.edit, size: 10,), Icon(Icons.notifications, size: 10,)],)
          ],),

          const Divider(),
          
          Column(
            children: [
              // !!!!!!!!!!!!!!!!!
              AntiLabel(group: title,),
              Text(title, style: const TextStyle(fontSize: 15),),
              Row(
                children: [
                  Text(
                    date1,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  const Icon(
                    Icons.arrow_right_alt,
                    size: 20,
                    color: Colors.amber,
                  ),
                  Text(
                    date2,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),

          Contributors(contributors: emptyTest),

          Text('敘述', style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 121, 121, 121)),),
          const Divider(),


        ],
      ),
    );
  }
}

