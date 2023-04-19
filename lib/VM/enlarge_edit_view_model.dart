import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'dart:io' as io show File;

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

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
      required this.callback});

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
  late DateTime start;
  late DateTime end;

  @override
  void initState() {
    super.initState();
    start = widget.startTime;
    end = widget.endTime;
  }

  @override
  Widget build(BuildContext context) {
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
                // debugPrint(start.toString());
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

    void selectStartTime() {
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
                    initialSelectedRange:
                        PickerDateRange(DateTime.now(), DateTime.now()),
                    showActionButtons: true,
                  )),
            );
          }));
    }

    void selectEndTime() {
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
                    initialSelectedRange:
                        PickerDateRange(DateTime.now(), DateTime.now()),
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
          onChanged: (value) {
            widget.titleController.text = value;
            widget.titleController.selection =
                TextSelection.fromPosition(TextPosition(offset: value.length));
            setState(() {});
          },
          decoration: InputDecoration(
              hintText: '輸入標題',
              errorText: widget.titleController.text.isEmpty ? '不可為空' : null,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 2),
              border: const OutlineInputBorder()),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            TextButton(
              onPressed: selectStartTime,
              child: Text(
                parseDate.format(start),
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
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
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class Descript extends StatefulWidget {
  const Descript({super.key, required this.descriptController});

  final TextEditingController descriptController;

  @override
  State<Descript> createState() => _DescriptState();
}

class _DescriptState extends State<Descript> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      controller: widget.descriptController,
      onChanged: (value) {
        widget.descriptController.text = value;
        widget.descriptController.selection =
            TextSelection.fromPosition(TextPosition(offset: value.length));
        setState(() {});
      },
      decoration: InputDecoration(
          hintText: '輸入標題',
          errorText: widget.descriptController.text.isEmpty ? '不可為空' : null,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 2),
          border: const OutlineInputBorder()),
      style: const TextStyle(fontSize: 15),
    );
  }
}

class TitleDateOfMission extends StatefulWidget {
  const TitleDateOfMission(
      {super.key,
      required this.titleController,
      required this.group,
      required this.color,
      required this.deadline,
      required this.callback});

  final TextEditingController titleController;
  final String group;
  final Color color;
  final DateTime deadline;
  final Function(DateTime) callback;

  @override
  State<TitleDateOfMission> createState() => TitleDateOfMissionState();
}

class TitleDateOfMissionState extends State<TitleDateOfMission> {
  late DateTime deadline;

  @override
  void initState() {
    super.initState();
    deadline = widget.deadline;
  }

  @override
  Widget build(BuildContext context) {
    void timePickerDialog(DateTime show) {
      Time tmp = Time(hour: 0, minute: 0);
      Navigator.of(context).push(
        showPicker(
          value: tmp,
          onChange: (time) {
            setState(() {
              deadline = DateTime(
                  show.year, show.month, show.day, time.hour, time.minute);
              widget.callback(deadline);
            });
          },
        ),
      );
    }

    void confirmChange(Object? value) {
      DateTime tmp = DateTime(0);
      if (value is DateTime) {
        tmp = value;
      }
      Navigator.pop(context);
      timePickerDialog(tmp);
    }

    void cancelChange() {
      setState(() {
        Navigator.pop(context);
      });
    }

    void selectTime() {
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
                    onSubmit: confirmChange,
                    onCancel: cancelChange,
                    initialSelectedRange:
                        PickerDateRange(DateTime.now(), DateTime.now()),
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
          onChanged: (value) {
            widget.titleController.text = value;
            widget.titleController.selection =
                TextSelection.fromPosition(TextPosition(offset: value.length));
            setState(() {});
          },
          decoration: InputDecoration(
              hintText: '輸入標題',
              errorText: widget.titleController.text.isEmpty ? '不可為空' : null,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 2),
              border: const OutlineInputBorder()),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
            onPressed: selectTime,
            child: Text(
              parseDate.format(deadline),
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000)),
            ))
      ],
    );
  }
}

class Contributors extends StatefulWidget {
  //參與的所有使用者
  const Contributors(
      {super.key,
      required this.contributorIds,
      this.eventModel,
      required this.callback});
  final List<String> contributorIds;
  final EventModel? eventModel;
  final Function(List<String>) callback;

  @override
  State<Contributors> createState() => _ContributorState();
}

class _ContributorState extends State<Contributors> {
  // TODO: 創建者必定要有? 如何判斷? 可以刪除?
  List<RawChip> people = [];
  List<String> peopleIds = [];

  Future<RawChip> createHeadShot(String person) async {
    /// 回傳 contributor 的頭貼

    var userData = await DataController()
        .download(dataTypeToGet: ProfileModel(), dataId: person);
    io.File photo = userData.photo ?? io.File('assets/images/cover.png');
    bool selected = false;
    if (widget.eventModel != null) {
      selected = widget.eventModel!.contributorIds!.contains(person);
      if (selected) peopleIds.add(person);
    }

    return RawChip(
      label: Text(userData.name ?? 'unknown'),
      avatar: CircleAvatar(child: Image.file(photo)),
      selected: selected,
      onSelected: (value) {
        setState(() {
          selected = value;
          if (value) {
            peopleIds.add(person);
          } else {
            peopleIds.remove(person);
          }
          widget.callback(peopleIds);
        });
      },
      elevation: 4,
      selectedColor: const Color(0xFF2196F3),
    );
  }

  Future<void> datas() async {
    if (widget.eventModel != null) {
      for (int i = 0; i < widget.eventModel!.contributorIds!.length; i++) {
        people.add(await createHeadShot(widget.contributorIds[i]));
      }
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
              child: Row(children: const[
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
