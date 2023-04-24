import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grouping_project/VM/event_setting_view_model.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:grouping_project/components/card_view/enlarge_context_template.dart';
/*
* this file is used to create event or edit existed event 
*/

class EventSettingPageView extends StatefulWidget {
  const EventSettingPageView({super.key});
  @override
  State<EventSettingPageView> createState() => _EventSettingPageViewState();
}

class _EventSettingPageViewState extends State<EventSettingPageView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventSettingViewModel>(
      builder: (context, model, child) => 
      Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // IconButton(
                  //     onPressed: () {
                  //       debugPrint('back');
                  //       Navigator.pop(context);
                  //     },
                  //     icon: const Icon(Icons.cancel)),
                  IconButton(
                      onPressed: () async {
                        bool valid = await model.onSave();
                        if (!valid && mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('非法輸入'),
                              content: Text(model.errorMessage()),
                            ),
                          );
                        } else if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.done)),
                ],
              ),
              // Divider(
              //   thickness: 1.5,
              //   color: Theme.of(context).colorScheme.surfaceVariant,
              // ),
              // const TitleDateOfEvent(),
              // const CardViewTitle(title: '參與成員', child: ContributorList()),
              // const SizedBox(
              //   height: 1,
              // ),
              // const CardViewTitle(title: '敘述', child: IntroductionBlock()),
              // const SizedBox(
              //   height: 2,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleDateOfEvent extends StatefulWidget {
  const TitleDateOfEvent({super.key});

  @override
  State<TitleDateOfEvent> createState() => TitleDateOfEventState();
}

class TitleDateOfEventState extends State<TitleDateOfEvent> {
  @override
  Widget build(BuildContext context) {
    void timePickerDialog( DateTime show, int state, EventSettingViewModel model) {
      Time tmp = Time(hour: 0, minute: 0);
      Navigator.of(context).push(
        showPicker(
          value: tmp,
          onChange: (time) {
            if (state == 0) {
              model.updateStartTime(DateTime(
                  show.year, show.month, show.day, time.hour, time.minute));
              // debugPrint(start.toString());
            } else if (state == 1) {
              model.updateEndTime(DateTime(
                  show.year, show.month, show.day, time.hour, time.minute));
            }
          },
        ),
      );
    }

    // void startConfirmChange(Object? value) {
    //   DateTime tmp = DateTime(0);
    //   if (value is DateTime) {
    //     tmp = value;
    //   }
    //   Navigator.pop(context);
    //   timePickerDialog(tmp, 0);
    // }

    // void endConfirmChange(Object? value) {
    //   DateTime tmp = DateTime(0);
    //   if (value is DateTime) {
    //     tmp = value;
    //   }
    //   Navigator.pop(context);
    //   timePickerDialog(tmp, 1);
    // }

    // void cancelChange() {
    //   setState(() {
    //     Navigator.pop(context);
    //   });
    // }

    // void selectStartTime() {
    //   showDialog(
    //                       context: context,
    //                       builder: ((BuildContext context) {
    //                         return AlertDialog(
    //                           title: const Text('選擇時間'),
    //                           content: SizedBox(
    //                               width: 200,
    //                               height: 400,
    //                               child: SfDateRangePicker(
    //                                 // onSelectionChanged: _onSelected,
    //                                 onSubmit: startConfirmChange,
    //                                 onCancel: cancelChange,
    //                                 initialSelectedRange: PickerDateRange(
    //                                     DateTime.now(), DateTime.now()),
    //                                 showActionButtons: true,
    //                               )),
    //                         );
    //                       }));
    // }

    // void selectEndTime() {
    //   showDialog(
    //                       context: context,
    //                       builder: ((BuildContext context) {
    //                         return AlertDialog(
    //                           title: const Text('選擇時間'),
    //                           content: SizedBox(
    //                               width: 200,
    //                               height: 400,
    //                               child: SfDateRangePicker(
    //                                 // onSelectionChanged: _onSelected,
    //                                 onSubmit: endConfirmChange,
    //                                 onCancel: cancelChange,
    //                                 initialSelectedRange: PickerDateRange(
    //                                     DateTime.now(), DateTime.now()),
    //                                 showActionButtons: true,
    //                               )),
    //                         );
    //                       }));
    // }

    DateFormat parseDate = DateFormat('h:mm a, MMM d, yyyy');

    return Consumer<EventSettingViewModel>(
        builder: (context, model, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AntiLabel(group: widget.group, color: widget.color),
                // Text(
                //   title,
                //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                // TextFormField(
                //   initialValue: model.title,
                //   onChanged: model.updateTitle,
                //   decoration: InputDecoration(
                //       hintText: '輸入標題',
                //       errorText: model.titleValidator(""),
                //       isDense: true,
                //       contentPadding: const EdgeInsets.symmetric(vertical: 2),
                //       border: const OutlineInputBorder()),
                //   style: const TextStyle(
                //       fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: ((BuildContext context) {
                            return AlertDialog(
                              title: const Text('選擇時間'),
                              content: SizedBox(
                                  width: 200,
                                  height: 400,
                                  child: SfDateRangePicker(
                                    // onSelectionChanged: _onSelected,
                                    onSubmit: (value) {
                                      DateTime tmp = DateTime(0);
                                      if (value is DateTime) {
                                        tmp = value;
                                      }
                                      Navigator.pop(context);
                                      timePickerDialog(tmp, 0, model);
                                    },
                                    // onCancel: cancelChange,
                                    initialSelectedRange: PickerDateRange(
                                        DateTime.now(), DateTime.now()),
                                    showActionButtons: true,
                                  )),
                            );
                          })),
                      child: Text(
                        parseDate.format(model.startTime),
                        // "sss",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            backgroundColor: model.color.withOpacity(0.2)),
                      ),
                    ),
                    Icon(
                      Icons.arrow_right_alt,
                      size: 20,
                      // color will be a variable
                      color: model.color,
                    ),
                    TextButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: ((BuildContext context) {
                            return AlertDialog(
                              title: const Text('選擇時間'),
                              content: SizedBox(
                                  width: 200,
                                  height: 400,
                                  child: SfDateRangePicker(
                                    // onSelectionChanged: _onSelected,
                                    onSubmit: (value) {
                                      DateTime tmp = DateTime(0);
                                      if (value is DateTime) {
                                        tmp = value;
                                      }
                                      Navigator.pop(context);
                                      timePickerDialog(tmp, 1, model);
                                    },
                                    // onCancel: cancelChange,
                                    initialSelectedRange: PickerDateRange(
                                        DateTime.now(), DateTime.now()),
                                    showActionButtons: true,
                                  )),
                            );
                          })),
                      child: Text(
                        parseDate.format(model.endTime),
                        // "sss",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            // TODO: text color
                            color: Colors.black,
                            backgroundColor: model.color.withOpacity(0.2)),
                      ),
                    )
                  ],
                ),
              ],
            ));
  }
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

class IntroductionBlock extends StatefulWidget {
  const IntroductionBlock({super.key});

  @override
  State<IntroductionBlock> createState() => _IntroductionBlockState();
}

class _IntroductionBlockState extends State<IntroductionBlock> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventSettingViewModel>(
      builder: (context, model, child) => TextFormField(
        initialValue: model.introduction,
        keyboardType: TextInputType.multiline,
        maxLines: 10,
        onChanged: model.updateIntroduction,
        decoration: InputDecoration(
            hintText: '輸入標題',
            errorText: model.introductionValidator(""),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 2),
            border: const OutlineInputBorder()),
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}

class ContributorList extends StatefulWidget {
  //參與的所有使用者
  const ContributorList({super.key});
  @override
  State<ContributorList> createState() => _ContributorState();
}

class _ContributorState extends State<ContributorList> {
  // TODO: 創建者必定要有? 如何判斷? 可以刪除?
  // List<RawChip> people = [];
  // List<String> peopleIds = [];

  // Future<RawChip> createHeadShot(String person) async {
  /// 回傳 contributor 的頭貼
  // var userData = await DataController()
  //     .download(dataTypeToGet: ProfileModel(), dataId: person);
  // io.File photo = userData.photo ?? io.File('assets/images/cover.png');
  // bool selected = false;
  // if (widget.eventModel != null) {
  //   selected = widget.eventModel!.contributorIds!.contains(person);
  //   if (selected) peopleIds.add(person);
  // }
  //   return RawChip(
  //     label: Text(userData.name ?? 'unknown'),
  //     avatar: CircleAvatar(child: Image.file(photo)),
  //     selected: selected,
  //     onSelected: (value) {
  //       setState(() {
  //         selected = value;
  //         if (value) {
  //           peopleIds.add(person);
  //         } else {
  //           peopleIds.remove(person);
  //         }
  //         // widget.callback(peopleIds);
  //       });
  //     },
  //     elevation: 4,
  //     selectedColor: const Color(0xFF2196F3),
  //   );
  // }

  // Future<void> datas() async {
  //   if (widget.eventModel != null) {
  //     for (int i = 0; i < widget.eventModel!.contributorIds!.length; i++) {
  //       people.add(await createHeadShot(widget.contributorIds[i]));
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventSettingViewModel>(
      builder: (context, model, child) => Row(
        children: model.contributors
            .map((AccountModel profile) => RawChip(
                  label: Text(profile.name),
                  avatar: CircleAvatar(
                      child: profile.photo.isEmpty
                          ? Text(profile.name.substring(0, 1))
                          : Image.file(File.fromRawPath(profile.photo))),
                  selected: true,
                  onSelected: (value) {},
                  elevation: 4,
                  selectedColor: const Color(0xFF2196F3),
                ))
            .toList(),
      ),
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
              child: Row(children: const [
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
