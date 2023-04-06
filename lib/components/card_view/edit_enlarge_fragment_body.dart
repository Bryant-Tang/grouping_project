import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

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

class TitleDateOfEvent extends StatefulWidget {
  const TitleDateOfEvent(
      {super.key,
      required this.titleController,
      required this.group,
      required this.color,
      required this.startTime,
      required this.endTime,
      required this.callback
      });

  final TextEditingController titleController;
  final String group;
  final Color color;
  final DateTime startTime;
  final DateTime endTime;
  final Function(DateTime, DateTime) callback;

  @override
  State<TitleDateOfEvent> createState() => TitleDateOfEventState();
}

class TitleDateOfEventState extends State<TitleDateOfEvent> {
  // final String title;
  // final DateTime startTime;
  // final DateTime endTime;
  // final String group;
  // final Color color;
  // final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    DateTime start = widget.startTime;
    DateTime end = widget.endTime;

    void timePickerDialog(DateTime show, int state) {
      Time tmp = Time(hour: 0, minute: 0);
      Navigator.of(context).push(
        showPicker(
          value: tmp,
          onChange: (time) {
            setState(() {
              if (state == 0) {
                start = DateTime(
                    show.year, show.month, show.day, time.hour, time.minute);
              } else if (state == 1) {
                end = DateTime(
                    show.year, show.month, show.day, time.hour, time.minute);
              }
              widget.callback(start, end);
            });
          },
        ),
      );
    }

    void startConfirmChange(Object? value) {
      DateTime tmp = DateTime(0);
      if (value is DateTime) {
        tmp = value;
      }
      Navigator.pop(context);
      timePickerDialog(tmp, 0);
    }

    void endConfirmChange(Object? value) {
      DateTime tmp = DateTime(0);
      if (value is DateTime) {
        tmp = value;
      }
      Navigator.pop(context);
      timePickerDialog(tmp, 1);
    }

    void cancelChange() {
      setState(() {
        Navigator.pop(context);
      });
    }
    
    void selectStartTime(){
      showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: const Text('選擇時間'),
            content: SizedBox(
                width: 200,
                height: 400,
                child: SfDateRangePicker(
                  // onSelectionChanged: _onSelected,
                  onSubmit: startConfirmChange,
                  onCancel: cancelChange,
                  initialSelectedRange: PickerDateRange(
                      DateTime.now(), DateTime.now()),
                  showActionButtons: true,
                )),
          );
        }));
    }

    void selectEndTime(){
      showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: const Text('選擇時間'),
            content: SizedBox(
                width: 200,
                height: 400,
                child: SfDateRangePicker(
                  // onSelectionChanged: _onSelected,
                  onSubmit: endConfirmChange,
                  onCancel: cancelChange,
                  initialSelectedRange: PickerDateRange(
                      DateTime.now(), DateTime.now()),
                  showActionButtons: true,
                )),
          );
        }));
    }

    DateFormat parseDate = DateFormat('h:mm a, MMM d, yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntiLabel(group: widget.group, color: widget.color),
        // Text(
        //   title,
        //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        // ),
        TextField(
          controller: widget.titleController,
          decoration: InputDecoration(
              hintText: '輸入標題',
              errorText: widget.titleController.text.isEmpty ? '不可為空' : ''),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            TextButton(
              onPressed: selectStartTime,
              child: Text(
                parseDate.format(start),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(
              Icons.arrow_right_alt,
              size: 20,
              // color will be a variable
              color: widget.color,
            ),
            TextButton(
              onPressed: selectEndTime,
              child: Text(
                parseDate.format(end),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class Contributors extends StatelessWidget {
  //參與的所有使用者

  const Contributors({super.key, required this.contributorIds});
  final List<String> contributorIds;

  Container createHeadShot(String person) {
    /// 回傳 contributor 的頭貼
    return Container(
      height: 30,
      width: 30,
      decoration: const ShapeDecoration(
          shape: CircleBorder(side: BorderSide(color: Colors.black)),
          color: Colors.blueAccent),
    );
  }

  List<Container> datas() {
    List<Container> tmp = [];
    for (int i = 0; i < contributorIds.length; i++) {
      tmp.add(createHeadShot(contributorIds[i]));
    }
    // only for test!!!!
    if (tmp.isEmpty) {
      tmp.add(Container(
        height: 30,
        width: 30,
        decoration: const ShapeDecoration(
            shape: CircleBorder(side: BorderSide(color: Colors.black)),
            color: Colors.greenAccent),
      ));
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: datas(),
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
