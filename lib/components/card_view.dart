import 'package:flutter/material.dart';
import 'dart:math';

List<Color> randomColor = [
  Colors.amber,
  Colors.redAccent,
  Colors.lightBlue,
  Colors.greenAccent,
  Colors.orangeAccent,
  Colors.pinkAccent,
  Colors.purple
];

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

class UpcomingExpand extends StatelessWidget {
  UpcomingExpand(
      {super.key,
      required this.group,
      required this.title,
      required this.descript,
      required this.startTime,
      required this.endTime});
  final String group;
  final String title;
  final String descript;
  final DateTime startTime;
  final DateTime endTime;

  /// 隨機選擇使用的顏色
  final Color usingColor = randomColor[Random().nextInt(randomColor.length)];

  @override
  Widget build(BuildContext context) {
    String date1 =
        '${intFixed(startTime.hour >= 12 ? startTime.hour - 12 : startTime.hour, 2)}:${intFixed(startTime.minute, 2)} ${startTime.hour >= 12 ? "PM" : "AM"}, ${monthDigitToLetter[startTime.month]} ${startTime.day}, ${startTime.year}';
    String date2 =
        '${intFixed(endTime.hour >= 12 ? endTime.hour - 12 : endTime.hour, 2)}:${intFixed(endTime.minute, 2)} ${endTime.hour >= 12 ? "PM" : "AM"}, ${monthDigitToLetter[endTime.month]} ${endTime.day}, ${endTime.year}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 400,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 0.5,
              blurRadius: 2,
            )
          ]),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                  color: usingColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
            ),
          ),
          Positioned(
            top: 25,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 這是展開的 card 的上方橫條
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: const [
                          Positioned(
                              child: Icon(
                            Icons.arrow_back,
                            size: 15,
                          )),
                          Positioned(
                            right: 25,
                            child: Icon(
                              Icons.edit,
                              size: 15,
                            ),
                          ),
                          Positioned(
                              right: 5,
                              child: Icon(
                                Icons.notifications,
                                size: 15,
                              ))
                        ],
                      )),
                  // 分隔線
                  SizedBox(
                    height: 7,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black12),
                    ),
                  ),
                  SizedBox(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const SizedBox(
                          height: 1,
                        ),
                        createAntiLabel(group, usingColor),
                        const SizedBox(height: 1),
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        SizedBox(
                            child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: date1,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            const WidgetSpan(
                                child: Icon(
                                  Icons.arrow_right_alt,
                                  size: 20,
                                  color: Colors.amber,
                                ),
                                alignment: PlaceholderAlignment.top),
                            TextSpan(
                                text: date2,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold))
                          ]),
                        ))
                      ])),
                  Container(
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '描述',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      // 分隔線
                      SizedBox(
                        height: 7,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black12),
                        ),
                      ),
                      const Text(
                        '年後的開學計畫',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '相關事件',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      // 分隔線
                      SizedBox(
                        height: 7,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black12),
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26)),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '相關共筆',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      // 分隔線
                      SizedBox(
                        height: 7,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black12),
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26)),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '相關議題',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      // 分隔線
                      SizedBox(
                        height: 7,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black12),
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26)),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// 建立 upcoming component
class Upcoming extends StatelessWidget{
  Upcoming({super.key, required this.group, required this.title, required this.descript, required this.eventId, required this.startTime, required this.endTime});
  final String group;
  final String title;
  final String descript;
  final DateTime startTime;
  final DateTime endTime;
  final String eventId;

  String getEventId(){
    return eventId;
  }

  /// 隨機選擇使用的顏色
  final Color usingColor = randomColor[Random().nextInt(randomColor.length)];
  @override
  Widget build(BuildContext context) {
    String date1 =
        '${intFixed(startTime.hour >= 12 ? startTime.hour - 12 : startTime.hour, 2)}:${intFixed(startTime.minute, 2)} ${startTime.hour >= 12 ? "PM" : "AM"}, ${monthDigitToLetter[startTime.month]} ${startTime.day}, ${startTime.year}';
    String date2 =
        '${intFixed(endTime.hour >= 12 ? endTime.hour - 12 : endTime.hour, 2)}:${intFixed(endTime.minute, 2)} ${endTime.hour >= 12 ? "PM" : "AM"}, ${monthDigitToLetter[endTime.month]} ${endTime.day}, ${endTime.year}';

    return Container(
        width: MediaQuery.of(context).size.width - 20,
        height: 84,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                spreadRadius: 0.5,
                blurRadius: 2,
              )
            ]),
        child: Stack(
          children: [
            // 左方的矩形方塊
            Positioned(
              child: Container(
                width: 8,
                height: 84,
                decoration: BoxDecoration(
                    color: usingColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5))),
              ),
            ),
            // 建立右方資訊
            Positioned(
              left: 15,
              top: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  createAntiLabel(group, usingColor),
                  const SizedBox(
                    height: 1,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
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
                  // 建立時間, 尚未完成
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: date1,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                      const WidgetSpan(
                          child: Icon(
                            Icons.arrow_right_alt,
                            size: 20,
                            color: Colors.amber,
                          ),
                          alignment: PlaceholderAlignment.top),
                      TextSpan(
                          text: date2,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold))
                    ]),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

// 建立track component
class Tracked extends StatelessWidget {
  Tracked(
      {super.key,
      required this.group,
      required this.title,
      required this.descript,
      required this.startTime,
      required this.endTime,
      required this.state});
  final String group;
  final String title;
  final String descript;
  final DateTime startTime;
  final DateTime endTime;
  final int state;

  /// 隨機選擇使用的顏色
  final Color usingColor = randomColor[Random().nextInt(randomColor.length)];

  @override
  Widget build(BuildContext context) {
    String date1 =
        '${intFixed(startTime.hour >= 12 ? startTime.hour - 12 : startTime.hour, 2)}:${intFixed(startTime.minute, 2)} ${startTime.hour >= 12 ? "PM" : "AM"}, ${monthDigitToLetter[startTime.month]} ${startTime.day}, ${startTime.year}';
    String date2 =
        '${intFixed(endTime.hour >= 12 ? endTime.hour - 12 : endTime.hour, 2)}:${intFixed(endTime.minute, 2)} ${endTime.hour >= 12 ? "PM" : "AM"}, ${monthDigitToLetter[endTime.month]} ${endTime.day}, ${endTime.year}';

    return Container(
        width: MediaQuery.of(context).size.width - 20,
        height: 84,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                spreadRadius: 0.5,
                blurRadius: 2,
              )
            ]),
        child: Stack(
          children: [
            // 左方的矩形方塊
            Positioned(
              child: Container(
                width: 8,
                height: 84,
                decoration: BoxDecoration(
                    color: usingColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5))),
              ),
            ),
            // 建立右方資訊
            Positioned(
              left: 15,
              top: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  createAntiLabel(group, usingColor),
                  const SizedBox(
                    height: 1,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
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
                  // 建立時間, 尚未完成
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: date1,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                      const WidgetSpan(
                          child: Icon(
                            Icons.arrow_right_alt,
                            size: 20,
                            color: Colors.amber,
                          ),
                          alignment: PlaceholderAlignment.top),
                      TextSpan(
                          text: date2,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold))
                    ]),
                  )
                ],
              ),
            ),

            // 建立狀態
            Positioned(
              right: 15,
              top: 60,
              child: createState(state),
            )
          ],
        ));
  }
}

// 標示反白的標籤
// event/missions屬於來自哪裡的那個標籤
Container createAntiLabel(String group, Color usingColor) {
  return Container(
    decoration: BoxDecoration(
        color: usingColor, borderRadius: BorderRadius.circular(10)),
    child: RichText(
      text: TextSpan(children: [
        const WidgetSpan(
            child: Text(' '), alignment: PlaceholderAlignment.middle),
        const WidgetSpan(
            child: Icon(
              Icons.circle,
              size: 7,
              color: Colors.white,
            ),
            alignment: PlaceholderAlignment.middle),
        WidgetSpan(
            child: Text(group,
                style: const TextStyle(color: Colors.white, fontSize: 10)),
            alignment: PlaceholderAlignment.middle),
        const WidgetSpan(
            child: Text(' '), alignment: PlaceholderAlignment.middle),
      ]),
    ),
    //child: Text(' ·' + group + ' ', style: TextStyle(color: Colors.white),),
  );
}

// 建立狀態
// 尚未完工
Container createState(int state) {
  Color stateColor = (state == 0
      ? Colors.grey
      : state == 1
          ? Colors.lightBlueAccent
          : Colors.greenAccent);
  String stateName = (state == 0
      ? 'Upcoming 未開始'
      : state == 1
          ? 'In progress 進行中'
          : 'Finish 完成');

  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: stateColor.withOpacity(0.3)),
    child: RichText(
      text: TextSpan(children: [
        const WidgetSpan(child: Text(' '), alignment: PlaceholderAlignment.middle),
        WidgetSpan(
            child: Icon(
              Icons.circle,
              size: 7,
              color: stateColor,
            ),
            alignment: PlaceholderAlignment.middle),
        WidgetSpan(
            child: Text(stateName,
                style: TextStyle(color: stateColor, fontSize: 10)),
            alignment: PlaceholderAlignment.middle),
        const WidgetSpan(child: Text(' '), alignment: PlaceholderAlignment.middle),
      ]),
    ),
  );
}
