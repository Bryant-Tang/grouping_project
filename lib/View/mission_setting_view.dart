import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/VM/mission_setting_view_model.dart';
import 'package:grouping_project/VM/state.dart';
import 'package:grouping_project/View/workspace/workspace_view.dart';
import 'package:grouping_project/model/model_lib.dart';
// import 'package:grouping_project/components/card_view/mission_information.dart';
// import 'package:grouping_project/VM/enlarge_edit_view_model.dart';
// import 'package:grouping_project/VM/mission_card_view_model.dart';
import 'package:grouping_project/components/card_view/enlarge_context_template.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

/*
* this file is used to create mission or edit existed mission 
*/

class MissionSettingPageView extends StatefulWidget {
  const MissionSettingPageView({super.key, required this.model});

  final MissionSettingViewModel model;

  factory MissionSettingPageView.create(
          {required AccountModel accountProfile}) =>
      MissionSettingPageView(
          model: MissionSettingViewModel.create(accountProfile));
  factory MissionSettingPageView.edit({required MissionModel missionModel}) =>
      MissionSettingPageView(model: MissionSettingViewModel.edit(missionModel));

  @override
  State<MissionSettingPageView> createState() => _MissionSettingPageViewState();
}

class _MissionSettingPageViewState extends State<MissionSettingPageView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MissionSettingViewModel>.value(
      value: widget.model,
      child: Consumer<MissionSettingViewModel>(
        builder: (context, model, child) => Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          debugPrint('back');
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.cancel)),
                    Row(
                      children: [
                        model.settingMode == SettingMode.edit
                            ? IconButton(
                                onPressed: () {
                                  // debugPrint('remove');
                                  // model.removeEvent();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const WorksapceBasePage()),
                                      (route) => false);
                                },
                                icon: const Icon(Icons.delete))
                            : const SizedBox(),
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
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const WorksapceBasePage()),
                                    (route) => false);
                              }
                            },
                            icon: const Icon(Icons.done)),
                      ],
                    )
                  ],
                ),
                const Divider(
                  thickness: 1.5,
                  color: Color.fromARGB(255, 170, 170, 170),
                ),
                // TitleDateOfMission(
                //   titleController: titleController,
                //   deadline: deadline,
                //   group: group,
                //   color: color,
                //   stage: missionStage,
                //   stateName: stateName,
                //   callback: (p0) {
                //     deadline = p0;
                //   },
                //   cbStage: (stage, stateName) {
                //     missionStage = stage;
                //     this.stateName = stateName;
                //   },
                // ),
                CardViewTitle(title: '參與成員', child: Container()),
                const SizedBox(
                  height: 1,
                ),
                const CardViewTitle(title: '敘述', child: IntroductionBlock()),
                const SizedBox(
                  height: 2,
                ),
                // TODO: connect mission and mission
                CardViewTitle(
                  title: '相關任務',
                  child: Container(),
                ),
                const SizedBox(
                  height: 2,
                ),
                // TODO: connect note and mission
                CardViewTitle(title: '相關共筆', child: Container()),
                const SizedBox(
                  height: 2,
                ),
                // TODO: connect mission and meeting
                CardViewTitle(
                  title: '相關會議',
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
    return Consumer<MissionSettingViewModel>(
      builder: (context, model, child) => TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 10,
        onChanged: model.updateIntroduction,
        decoration: InputDecoration(
            hintText: '輸入標題',
            errorText: model.introductionValidator(),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 2),
            border: const OutlineInputBorder()),
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}

class TitleDateOfMission extends StatefulWidget {
  const TitleDateOfMission({super.key});

  @override
  State<TitleDateOfMission> createState() => TitleDateOfMissionState();
}

class TitleDateOfMissionState extends State<TitleDateOfMission> {
  @override
  Widget build(BuildContext context) {
    void timePickerDialog(DateTime show, MissionSettingViewModel model) {
      Time tmp = Time(hour: 0, minute: 0);
      Navigator.of(context).push(
        showPicker(
          value: tmp,
          onChange: (time) {
            setState(() {
              model.updateDeadline(DateTime(
                  show.year, show.month, show.day, time.hour, time.minute));
            });
          },
        ),
      );
    }

    // void confirmChange(Object? value) {
    //   DateTime tmp = DateTime(0);
    //   if (value is DateTime) {
    //     tmp = value;
    //   }
    //   Navigator.pop(context);
    //   timePickerDialog(tmp);
    // }

    void cancelChange() {
      setState(() {
        Navigator.pop(context);
      });
    }

    // void selectTime() {
    //   showDialog(
    //       context: context,
    //       builder: ((BuildContext context) {
    //         return AlertDialog(
    //           title: const Text('選擇時間'),
    //           content: SizedBox(
    //               width: 200,
    //               height: 400,
    //               child: SfDateRangePicker(
    //                 // onSelectionChanged: _onSelected,
    //                 onSubmit: confirmChange,
    //                 onCancel: cancelChange,
    //                 initialSelectedRange:
    //                     PickerDateRange(DateTime.now(), DateTime.now()),
    //                 showActionButtons: true,
    //               )),
    //         );
    //       }));
    // }

    DateFormat parseDate = DateFormat('h:mm a, MMM d, yyyy');

    return Consumer<MissionSettingViewModel>(
      builder: (context, model, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AntiLabel(group: widget.group, color: widget.color),
          // Text(
          //   title,
          //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          TextFormField(
            initialValue: model.title,
            onChanged: model.updateTitle,
            decoration: InputDecoration(
                hintText: '輸入標題',
                errorText: model.titleValidator(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 2),
                border: const OutlineInputBorder()),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                              timePickerDialog(tmp, model);
                            },
                            onCancel: cancelChange,
                            initialSelectedRange:
                                PickerDateRange(DateTime.now(), DateTime.now()),
                            showActionButtons: true,
                          )),
                    );
                  })),
              child: Text(
                parseDate.format(model.deadline),
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000)),
              )),
          const StateOfMission()
        ],
      ),
    );
  }
}

class StateOfMission extends StatefulWidget {
  const StateOfMission({super.key});

  @override
  State<StateOfMission> createState() => _StateOfMissionState();
}

class _StateOfMissionState extends State<StateOfMission> {
  // late List<MissionStateModel> stageDatas = [];
  // late MissionStage stage;
  // late String stateName = 'Error';
  // late Color color = Colors.black38;
  // String selectedValue = '待討論 Pending';
  // TextEditingController stateNameCrtl = TextEditingController();
// TODO: can't upload statename, seperate user and group
  // @override
  // void initState() {
  //   super.initState();
  //   stage = widget.stage;
  //   stateName = widget.stateName;
  //   color = stageToColor(widget.stage);
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   stateNameCrtl.dispose();
  // }

  Color stageToColor(MissionStage stage) {
    // TODO: color discussion
    if (stage == MissionStage.progress) {
      return Colors.blue.withOpacity(0.2);
    } else if (stage == MissionStage.pending) {
      return Colors.purple.withOpacity(0.2);
    } else if (stage == MissionStage.close) {
      return Colors.red.withOpacity(0.2);
    } else {
      return Colors.black38;
    }
  }

  Column contextTemple(String title, List<MissionStateModel> datas,
      MissionStage stage, MissionSettingViewModel model) {
    List<Widget> chips = [];

    for (int i = 0; i < datas.length; i++) {
      chips.add(
          chipSelected(stageToColor(stage), datas[i].stateName, stage, model));
      chips.add(const SizedBox(
        height: 4,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const Divider(
              height: 7,
              thickness: 3,
            )
          ] +
          chips,
    );
  }

  // ListView chooseState(MissionSettingViewModel model) {
  //   return ListView(
  //     children: [
  //       contextTemple(
  //           '進行中 In Progress', model.inProgress, MissionStage.progress),
  //       contextTemple('待討論 Pending', model.pending, MissionStage.pending),
  //       contextTemple('已結束 Close', model.close, MissionStage.close),
  //       const Divider(
  //         height: 7,
  //         thickness: 2,
  //       ),
  //       const CreateStage()
  //     ],
  //   );
  // }

  InkWell chipSelected(Color color, String stateName, MissionStage stage,
      MissionSettingViewModel model) {
    return InkWell(
        onTap: () {
          model.updateState(stage, stateName);
          Navigator.pop(context);
          // this.stage = stage;
          // this.stateName = stateName;
          // this.color = stageToColor(stage);
          // widget.callback(stage, stateName);
          // // debugPrint(color.toString());
          // setState(() {
          //   Navigator.pop(context);
          // });
        },
        child: Container(
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            child: Text(
              ' •$stateName ',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )));
  }

  Container chipView(Color color, String stateName) {
    return Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Text(
          ' •$stateName ',
          style: const TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MissionSettingViewModel>(
      builder: (context, model, child) => InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: ListView(
                        children: [
                          contextTemple('進行中 In Progress', model.inProgress,
                              MissionStage.progress, model),
                          contextTemple('待討論 Pending', model.pending,
                              MissionStage.pending, model),
                          contextTemple('已結束 Close', model.close,
                              MissionStage.close, model),
                          const Divider(
                            height: 7,
                            thickness: 2,
                          ),
                          const CreateStage()
                        ],
                      ),
                    ),
                  );
                });
          },
          child: chipView(model.color, model.stateModel.stateName)),
    );
  }
}

class CreateStage extends StatefulWidget {
  const CreateStage({super.key});

  @override
  State<CreateStage> createState() => _CreateStageState();
}

class _CreateStageState extends State<CreateStage> {
  String selectedStage = '進行中 In Progress';
  String newStateName = '';

  MissionStage stringToStage(String stage) {
    if (stage == '進行中 In Progress') {
      return MissionStage.progress;
    } else if (stage == '待討論 Pending') {
      return MissionStage.pending;
    } else if (stage == '已結束 Close') {
      return MissionStage.close;
    } else {
      return MissionStage.progress;
    }
  }

  DropdownButton selectStage(void Function(void Function()) setNewState) {
    return DropdownButton(
        value: selectedStage,
        items: const [
          DropdownMenuItem(
            value: '進行中 In Progress',
            child: Text(
              '進行中 In Progress',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          DropdownMenuItem(
            value: '待討論 Pending',
            child: Text(
              '待討論 Pending',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          DropdownMenuItem(
            value: '已結束 Close',
            child: Text(
              '已結束 Close',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          )
        ],
        onChanged: (value) {
          // debugPrint('before: $selectedValue');
          // TODO: don't use setState method
          setNewState(() {
            selectedStage = value;
          });
          // debugPrint('after: $selectedValue');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MissionSettingViewModel>(
      builder: (context, model, child) => TextButton(
        // key: ValueKey(selectedValue),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: StatefulBuilder(
                    builder: ((context, setNewState) {
                      return Container(
                          padding: const EdgeInsets.all(2),
                          height: 180,
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('創建狀態 Create State',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '階段 Stage',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  selectStage(setNewState)
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '名字 State Name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Container(
                                    width: 130,
                                    padding: const EdgeInsets.only(right: 30),
                                    child: TextField(
                                      onChanged: (value) =>
                                          newStateName = value,
                                    ),
                                  )
                                ],
                              ),
                              TextButton(
                                  onPressed: () {
                                    // TODO: call back new stage and new stateName
                                    model.createState(
                                        stringToStage(selectedStage),
                                        newStateName);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Ok'))
                            ],
                          ));
                    }),
                  ),
                );
              });
          // setState(() {});
        },
        child: const Text(
          '創建狀態 Create State',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
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
    return Consumer<MissionSettingViewModel>(
      builder: (context, model, child) => Row(
        children: model.contributors
            .map((AccountModel profile) => RawChip(
                  label: Text(profile.name),
                  avatar: CircleAvatar(
                      child: profile.photo.isEmpty
                          ? Text(profile.name.substring(0, 1))
                          : Image.memory(profile.photo)),
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
