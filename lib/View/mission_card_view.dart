import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/VM/mission_setting_view_model.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/components/color_tag_chip.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MissionCardViewTemplate extends StatefulWidget {
  const MissionCardViewTemplate({super.key});

  @override
  State<MissionCardViewTemplate> createState() =>
      _MissionCardViewTemplateState();
}

class _MissionCardViewTemplateState extends State<MissionCardViewTemplate> {
  void onClick(WorkspaceDashBoardViewModel workspaceVM,
      MissionSettingViewModel missionSettingVM) async {
    debugPrint('open mission page');
    const animationDuration = Duration(milliseconds: 400);
    final isNeedRefresh = await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: animationDuration,
            reverseTransitionDuration: animationDuration,
            pageBuilder: (BuildContext context, __, ___) =>
                MultiProvider(providers: [
                  ChangeNotifierProvider<MissionSettingViewModel>.value(
                      value: missionSettingVM),
                  ChangeNotifierProvider<WorkspaceDashBoardViewModel>.value(
                      value: workspaceVM)
                ], child: const MissionEditCardView())));
    if (isNeedRefresh != null && isNeedRefresh) {
      await workspaceVM.getAllData();
    }
  }

  Widget getStateLabelButton(
      Function callBack, MissionStateModel state, Color color) {
    return ElevatedButton(
        onPressed: () => callBack(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(4.0),
          foregroundColor: color,
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(backgroundColor: color, radius: 5),
            const SizedBox(width: 5),
            Text(state.stateName),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, workspaceVM, child) =>
          Consumer<MissionSettingViewModel>(
        builder: (context, model, child) {
          ThemeData themeData = ThemeData(
              colorSchemeSeed: model.color,
              brightness: context.watch<ThemeManager>().brightness);
          // model.getAllContibutorData();
          return Hero(
            tag: "${model.missionModel.id}",
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: AspectRatio(
                aspectRatio: 3.3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: themeData.colorScheme.surface,
                      foregroundColor: themeData.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 4,
                      padding: const EdgeInsets.all(3)),
                  onPressed: () => onClick(workspaceVM, model),
                  child: Row(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            color: themeData.colorScheme.surfaceVariant),
                        width: 12,
                        // color: Theme.of(context).colorScheme.primary
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                ColorTagChip(
                                    tagString: model.ownerAccountName,
                                    color: themeData.colorScheme.primary),
                              ],
                            ),
                            Text(model.title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: themeData.textTheme.titleMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                            Text(
                              model.introduction,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: themeData.textTheme.titleSmall!.copyWith(
                                  // color: themeData.colorScheme.secondary,
                                  fontSize: 14),
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.timer, size: 18),
                                Text(model.formattedDeadline),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            getStateLabelButton(() {}, model.missionState,
                                model.stageColorMap[model.missionState.stage]!),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MissionEditCardView extends StatefulWidget {
  const MissionEditCardView({Key? key}) : super(key: key);
  // const ExpandedCardView({super.key});

  @override
  State<MissionEditCardView> createState() => _EditCardViewCardViewState();
}

class _EditCardViewCardViewState extends State<MissionEditCardView> {
  // late ThemeData themeData;

  Widget getDateTime(MissionSettingViewModel model) {
    return Row(
      children: [
        Icon(Icons.timer,
            color: Theme.of(context).colorScheme.secondary, size: 16),
        const SizedBox(width: 4),
        Text(
          model.getTimerCounter(),
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
              fontSize: 14,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget generateContentDisplayBlock(String blockTitle, Widget child) {
    TextStyle blockTitleTextStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.secondary);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(blockTitle, style: blockTitleTextStyle),
            const Divider(thickness: 3),
            child
          ],
        ));
  }

  Widget getInformationDisplay(MissionSettingViewModel model) {
    TextStyle titleTextStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.bold, fontSize: 28);
    Widget eventOwnerLabel = Row(
      children: [
        ColorTagChip(
            tagString: "事件 - ${model.ownerAccountName} 的工作區",
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        eventOwnerLabel,
        TextFormField(
          initialValue: model.title == "任務標題" ? "" : model.title,
          style: titleTextStyle,
          onChanged: model.updateTitle,
          decoration: const InputDecoration(
              hintText: "任務標題",
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 2),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              )),
          validator: model.titleValidator,
        ),
        getDateTime(model)
      ],
    );
  }

  Widget getMissionDescriptionDisplay(MissionSettingViewModel model) {
    TextStyle textStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.bold, fontSize: 20);
    return generateContentDisplayBlock(
        '任務介紹',
        TextFormField(
          initialValue: model.introduction == "任務介紹" ? "" : model.introduction,
          style: textStyle,
          onChanged: model.updateIntroduction,
          maxLines: null,
          decoration: const InputDecoration(
              hintText: "任務介紹",
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 2),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              )),
          validator: model.introductionValidator,
        ));
  }

  void showTimePicker(
      Function callBack, BuildContext context, DateTime initialTime) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: const Text('選擇時間'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.height * 0.8,
              child: SfDateRangePicker(
                initialSelectedDate: initialTime,
                onSubmit: (value) {
                  debugPrint(value.toString());
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    showPicker(
                        is24HrFormat: true,
                        value: Time(
                            hour: initialTime.hour, minute: initialTime.minute),
                        onChange: (newTime) {
                          debugPrint(value.runtimeType.toString());
                          debugPrint(newTime.toString());
                          callBack((value as DateTime).copyWith(
                            hour: newTime.hour,
                            minute: newTime.minute,
                          ));
                        }),
                  );
                },
                onCancel: () {
                  Navigator.pop(context);
                },
                showActionButtons: true,
              ),
            ),
          );
        }));
  }

  Widget getStateLabelButton(
      Function callBack, MissionStateModel state, Color color) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ElevatedButton(
          onPressed: () => callBack(),
          style: ElevatedButton.styleFrom(
            side: BorderSide(color: color),
            foregroundColor: color,
            // backgroundColor: color.withOpacity(0.1),
            textStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            elevation: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(backgroundColor: color, radius: 5),
              const SizedBox(width: 5),
              Text(state.stateName),
            ],
          )),
    );
  }

  Widget getDeadlineBlock(MissionSettingViewModel model) {
    return generateContentDisplayBlock(
        '截止時間',
        ElevatedButton(
            onPressed: () => showTimePicker(
                model.updateDeadline, context, model.missionDeadline),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 10),
                Text(model.formattedDeadline),
              ],
            )));
  }

  Widget getContributorButton(
      MissionSettingViewModel model, AccountModel account) {
    return Padding(
        padding: const EdgeInsets.all(6.0),
        child: RawChip(
            onPressed: () => model.updateContibutor(account),
            // onDeleted: () => model.updateContibutor(account),
            // deleteIcon: model.isContributors(account) ? const Icon(Icons.delete) : const Icon(Icons.add),
            selected: model.isContributors(account),
            elevation: 3,
            label: Text(account.nickname),
            avatar: CircleAvatar(
                backgroundImage: account.photo.isEmpty
                    ? Image.asset('assets/images/profile_male.png').image
                    : Image.memory(account.photo).image)));
  }

  void onUpdateContributor(MissionSettingViewModel model) {
    showModalBottomSheet(
        context: context,
        builder: (context) =>
            ChangeNotifierProvider<MissionSettingViewModel>.value(
              value: model,
              child: Consumer<MissionSettingViewModel>(
                builder: (context, model, child) => SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                          child: model.contributorCandidate.isEmpty
                              ? const Center(child: Text('無其他成員'))
                              : Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Wrap(
                                      children: List.generate(
                                          model.contributorCandidate.length,
                                          (index) => getContributorButton(
                                              model,
                                              model.contributorCandidate[
                                                  index]))),
                                )),
                    ],
                  ),
                ),
              ),
            ));
    // debugPrint(model.contributors.length.toString());
  }

  Widget getContributorBlock(MissionSettingViewModel model) {
    return generateContentDisplayBlock(
        '參與者',
        MaterialButton(
          onPressed: () async {
            // debugPrint(model.missionModel.contributorIds.length.toString());
            onUpdateContributor(model);
          },
          child: model.contributors.isEmpty
              ? const Text('参加者はいません')
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Wrap(
                      children: List.generate(
                          model.contributors.length,
                          (index) => getContributorButton(
                              model, model.contributors[index])),
                    ),
                  ],
                ),
        ));
  }

  Widget getStateBlock(MissionSettingViewModel model) {
    return generateContentDisplayBlock(
        '任務狀態',
        getStateLabelButton(() => onUpdateState(model), model.missionState,
            model.stageColorMap[model.missionState.stage]!));
  }

  void onUpdateState(MissionSettingViewModel model) {
    showModalBottomSheet(
        context: context,
        builder: (context) =>
            ChangeNotifierProvider<MissionSettingViewModel>.value(
              value: model,
              child: Consumer<MissionSettingViewModel>(
                builder: (context, model, child) => SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListView(
                            children: <Widget>[
                              generateContentDisplayBlock(
                                  '進行中 In Progress',
                                  Column(
                                      children: List.from(model.inProgress.map(
                                          (stateLabel) => getStateLabelButton(
                                                  () {
                                                model.updateState(stateLabel);
                                                Navigator.pop(context);
                                              },
                                                  stateLabel,
                                                  model.stageColorMap[
                                                      stateLabel.stage]!))))),
                              generateContentDisplayBlock(
                                  '待討論 Pending',
                                  Column(
                                      children: List.from(model.pending.map(
                                          (stateLabel) => getStateLabelButton(
                                                  () {
                                                model.updateState(stateLabel);
                                                Navigator.pop(context);
                                              },
                                                  stateLabel,
                                                  model.stageColorMap[
                                                      stateLabel.stage]!))))),
                              generateContentDisplayBlock(
                                '已結束 Close',
                                Column(
                                    children: List.from(model.close.map(
                                        (stateLabel) => getStateLabelButton(() {
                                              model.updateState(stateLabel);
                                              Navigator.pop(context);
                                            },
                                                stateLabel,
                                                model.stageColorMap[
                                                    stateLabel.stage]!)))),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  void onFinish(MissionSettingViewModel model) async {
    if (formKey.currentState!.validate()) {
      final isNeedRefresh = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('確認'),
              content: const Text('是否確認編輯?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('否')),
                TextButton(
                    onPressed: () async {
                      await model.createMission();
                      if (context.mounted) {
                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text('是')),
              ],
            );
          });
      if (context.mounted && isNeedRefresh) {
        Navigator.pop(context, isNeedRefresh);
      }
    }
  }

  void onDelete(MissionSettingViewModel model) async {
    final isNeedRefresh = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('確認'),
            content: const Text('是否確認刪除'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('否')),
              TextButton(
                  onPressed: () async {
                    await model.deleteMission();
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text('是')),
            ],
          );
        });
    if (context.mounted) {
      // context
      //     .watch<ThemeManager>()
      //     .updateColorSchemeSeed(Color(context.watch<WorkspaceDashBoardViewModel>().accountProfileData.color));
      Navigator.pop(context, isNeedRefresh);
    }
  }

  final formKey = GlobalKey<FormState>();
  Stream<DateTime> currentTimeStream = Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, theme, child) => Consumer<WorkspaceDashBoardViewModel>(
        builder: (context, workspaceVM, child) =>
            Consumer<MissionSettingViewModel>(builder: (context, model, child) {
          // theme.updateColorSchemeSeed(model.color);
          return StreamBuilder<DateTime>(
            stream: currentTimeStream,
            builder: (context, snapshot) => GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Hero(
                tag: "${model.missionModel.id}",
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    elevation: 2,
                    leading: IconButton(
                      onPressed: () {
                        // theme.updateColorSchemeSeed(
                        //   Color(workspaceVM.accountProfileData.color));
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_rounded,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () => onFinish(model),
                        icon: Icon(Icons.check,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      IconButton(
                          onPressed: () => onDelete(model),
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                  // display all event data
                  body: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getInformationDisplay(model),
                              getMissionDescriptionDisplay(model),
                              getStateBlock(model),
                              getDeadlineBlock(model),
                              getContributorBlock(model),
                              generateContentDisplayBlock('子任務', Text('沒有子任務')),
                              // model.missionModel.relatedMissionIds.isEmpty
                              //     ? const

                              //     : ListView.builder(
                              //         shrinkWrap: true,
                              //         physics:
                              //             const NeverScrollableScrollPhysics(),
                              //         itemCount: model.eventModel
                              //             .relatedMissionIds.length,
                              //         itemBuilder: (context, index) => Text(
                              //             model.eventModel
                              //                 .relatedMissionIds[index]))),
                              // relation note
                              generateContentDisplayBlock(
                                  '關聯筆記', const Text('沒有關聯筆記')),
                              // relation message
                              generateContentDisplayBlock(
                                  '關聯話題', const Text('沒有關聯話題')),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// class MissionSettingPageView extends StatefulWidget {
//   const MissionSettingPageView({super.key});

// final MissionSettingViewModel model;

// factory MissionSettingPageView.create(
//         {required AccountModel accountProfile}) =>
//     MissionSettingPageView(
//         model: MissionSettingViewModel.create(accountProfile: accountProfile));
// factory MissionSettingPageView.edit({required MissionModel missionModel}) =>
//     MissionSettingPageView(model: MissionSettingViewModel.edit(missionModel));

//   @override
//   State<MissionSettingPageView> createState() => _MissionSettingPageViewState();
// }

// class _MissionSettingPageViewState extends State<MissionSettingPageView> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MissionSettingViewModel>(
//       builder: (context, model, child) => Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
//           child: ListView(

//           ),
//         ),
//       ),
//     );
//   }
// }

// class AntiLabel extends StatelessWidget {
//   /// 標籤反白的 group

//   const AntiLabel({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MissionSettingViewModel>(
//       builder: (context, model, child) => Container(
//           decoration: BoxDecoration(
//               color: model.color, borderRadius: BorderRadius.circular(10)),
//           child: Text(
//             ' •${model.owner} ',
//             style: const TextStyle(color: Colors.white, fontSize: 15),
//           )),
//     );
//   }
// }

// class IntroductionBlock extends StatefulWidget {
//   const IntroductionBlock({super.key});

//   @override
//   State<IntroductionBlock> createState() => _IntroductionBlockState();
// }

// class _IntroductionBlockState extends State<IntroductionBlock> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MissionSettingViewModel>(
//       builder: (context, model, child) => TextField(
//         keyboardType: TextInputType.multiline,
//         maxLines: 10,
//         onChanged: model.updateIntroduction,
//         decoration: InputDecoration(
//             hintText: '輸入標題',
//             errorText: model.introductionValidator(),
//             isDense: true,
//             contentPadding: const EdgeInsets.symmetric(vertical: 2),
//             border: const OutlineInputBorder()),
//         style: const TextStyle(fontSize: 15),
//       ),
//     );
//   }
// }

// class TitleDateOfMission extends StatefulWidget {
//   const TitleDateOfMission({super.key});

//   @override
//   State<TitleDateOfMission> createState() => TitleDateOfMissionState();
// }

// class TitleDateOfMissionState extends State<TitleDateOfMission> {
//   @override
//   Widget build(BuildContext context) {
//     void timePickerDialog(DateTime show, MissionSettingViewModel model) {
//       Time tmp = Time(hour: 0, minute: 0);
//       Navigator.of(context).push(
//         showPicker(
//           value: tmp,
//           onChange: (time) {
//             setState(() {
//               model.updateDeadline(DateTime(
//                   show.year, show.month, show.day, time.hour, time.minute));
//             });
//           },
//         ),
//       );
//     }

//     // void confirmChange(Object? value) {
//     //   DateTime tmp = DateTime(0);
//     //   if (value is DateTime) {
//     //     tmp = value;
//     //   }
//     //   Navigator.pop(context);
//     //   timePickerDialog(tmp);
//     // }

//     void cancelChange() {
//       setState(() {
//         Navigator.pop(context);
//       });
//     }

//     // void selectTime() {
//     //   showDialog(
//     //       context: context,
//     //       builder: ((BuildContext context) {
//     //         return AlertDialog(
//     //           title: const Text('選擇時間'),
//     //           content: SizedBox(
//     //               width: 200,
//     //               height: 400,
//     //               child: SfDateRangePicker(
//     //                 // onSelectionChanged: _onSelected,
//     //                 onSubmit: confirmChange,
//     //                 onCancel: cancelChange,
//     //                 initialSelectedRange:
//     //                     PickerDateRange(DateTime.now(), DateTime.now()),
//     //                 showActionButtons: true,
//     //               )),
//     //         );
//     //       }));
//     // }

//     DateFormat parseDate = DateFormat('h:mm a, MMM d, yyyy');

//     return Consumer<MissionSettingViewModel>(
//       builder: (context, model, child) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const AntiLabel(),
//           const SizedBox(
//             height: 5,
//           ),
//           // Text(
//           //   title,
//           //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           // ),
//           TextFormField(
//             initialValue: model.title,
//             onChanged: model.updateTitle,
//             decoration: InputDecoration(
//                 hintText: '輸入標題',
//                 errorText: model.titleValidator(),
//                 isDense: true,
//                 contentPadding: const EdgeInsets.symmetric(vertical: 2),
//                 border: const OutlineInputBorder()),
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           TextButton(
//               onPressed: () => showDialog(
//                   context: context,
//                   builder: ((BuildContext context) {
//                     return AlertDialog(
//                       title: const Text('選擇時間'),
//                       content: SizedBox(
//                           width: 200,
//                           height: 400,
//                           child: SfDateRangePicker(
//                             // onSelectionChanged: _onSelected,
//                             onSubmit: (value) {
//                               DateTime tmp = DateTime(0);
//                               if (value is DateTime) {
//                                 tmp = value;
//                               }
//                               Navigator.pop(context);
//                               timePickerDialog(tmp, model);
//                             },
//                             onCancel: cancelChange,
//                             initialSelectedRange:
//                                 PickerDateRange(DateTime.now(), DateTime.now()),
//                             showActionButtons: true,
//                           )),
//                     );
//                   })),
//               child: Text(
//                 parseDate.format(model.deadline),
//                 style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF000000)),
//               )),
//           const StateOfMission()
//         ],
//       ),
//     );
//   }
// }

// class StateOfMission extends StatefulWidget {
//   const StateOfMission({super.key});

//   @override
//   State<StateOfMission> createState() => _StateOfMissionState();
// }

// class _StateOfMissionState extends State<StateOfMission> {
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

  // Color stageToColor(MissionStage stage) {
  //   // TODO: color discussion
  //   if (stage == MissionStage.progress) {
  //     return Colors.blue.withOpacity(0.2);
  //   } else if (stage == MissionStage.pending) {
  //     return Colors.purple.withOpacity(0.2);
  //   } else if (stage == MissionStage.close) {
  //     return Colors.red.withOpacity(0.2);
  //   } else {
  //     return Colors.black38;
  //   }
  // }

  // Column contextTemple(String title, List<MissionStateModel> datas,
  //     MissionStage stage, MissionSettingViewModel model) {
  //   List<Widget> chips = [];

  //   for (int i = 0; i < datas.length; i++) {
  //     chips.add(
  //         chipSelected(stageToColor(stage), datas[i].stateName, stage, model));
  //     chips.add(const SizedBox(
  //       height: 4,
  //     ));
  //   }

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //           Text(
  //             title,
  //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //           ),
  //           const Divider(
  //             height: 7,
  //             thickness: 3,
  //           )
  //         ] +
  //         chips,
  //   );
  // }

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

//   InkWell chipSelected(Color color, String stateName, MissionStage stage,
//       MissionSettingViewModel model) {
//     return InkWell(
//         onTap: () {
//           // model.updateState(stage, stateName);
//           Navigator.pop(context);
//           // this.stage = stage;
//           // this.stateName = stateName;
//           // this.color = stageToColor(stage);
//           // widget.callback(stage, stateName);
//           // // debugPrint(color.toString());
//           // setState(() {
//           //   Navigator.pop(context);
//           // });
//         },
//         child: Container(
//             decoration: BoxDecoration(
//                 color: color, borderRadius: BorderRadius.circular(10)),
//             child: Text(
//               ' •$stateName ',
//               style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold),
//             )));
//   }

//   Container chipView(Color color, String stateName) {
//     return Container(
//         decoration: BoxDecoration(
//             color: color, borderRadius: BorderRadius.circular(10)),
//         child: Text(
//           ' •$stateName ',
//           style: const TextStyle(
//               color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MissionSettingViewModel>(
//       builder: (context, model, child) => InkWell(
//           onTap: () {
//             showDialog(
//                 context: context,
//                 builder: (context) {
//                   return Dialog(
//                     child: Padding(
//                       padding: const EdgeInsets.all(5),
//                       child: ListView(
//                         children: [
//                           contextTemple('進行中 In Progress', model.inProgress,
//                               MissionStage.progress, model),
//                           contextTemple('待討論 Pending', model.pending,
//                               MissionStage.pending, model),
//                           contextTemple('已結束 Close', model.close,
//                               MissionStage.close, model),
//                           const Divider(
//                             height: 7,
//                             thickness: 2,
//                           ),
//                           ChangeNotifierProvider<MissionSettingViewModel>.value(
//                               value: model, child: const CreateStage()),
//                           ChangeNotifierProvider<MissionSettingViewModel>.value(
//                               value: model, child: const DeleteStateName()),
//                         ],
//                       ),
//                     ),
//                   );
//                 });
//           },
//           child: chipView(stageToColor(model.stateModel.stage),
//               model.stateModel.stateName)),
//     );
//   }
// }

// class CreateStage extends StatefulWidget {
//   const CreateStage({super.key});

//   @override
//   State<CreateStage> createState() => _CreateStageState();
// }

// class _CreateStageState extends State<CreateStage> {
//   String selectedStage = '進行中 In Progress';
//   String newStateName = '';

//   MissionStage stringToStage(String stage) {
//     if (stage == '進行中 In Progress') {
//       return MissionStage.progress;
//     } else if (stage == '待討論 Pending') {
//       return MissionStage.pending;
//     } else if (stage == '已結束 Close') {
//       return MissionStage.close;
//     } else {
//       return MissionStage.progress;
//     }
//   }

//   DropdownButton selectStage(void Function(void Function()) setNewState) {
//     return DropdownButton(
//         value: selectedStage,
//         items: const [
//           DropdownMenuItem(
//             value: '進行中 In Progress',
//             child: Text(
//               '進行中 In Progress',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//             ),
//           ),
//           DropdownMenuItem(
//             value: '待討論 Pending',
//             child: Text(
//               '待討論 Pending',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//             ),
//           ),
//           DropdownMenuItem(
//             value: '已結束 Close',
//             child: Text(
//               '已結束 Close',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//             ),
//           )
//         ],
//         onChanged: (value) {
//           // debugPrint('before: $selectedValue');
//           // TODO: don't use setState method
//           setNewState(() {
//             selectedStage = value;
//           });
//           // debugPrint('after: $selectedValue');
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MissionSettingViewModel>(
//       builder: (context, model, child) => TextButton(
//         // key: ValueKey(selectedValue),
//         onPressed: () {
//           showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   content: StatefulBuilder(
//                     builder: ((context, setNewState) {
//                       return Container(
//                           padding: const EdgeInsets.all(2),
//                           height: 180,
//                           width: 300,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               const Text('創建狀態 Create State',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20)),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const Text(
//                                     '階段 Stage',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 15),
//                                   ),
//                                   selectStage(setNewState)
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const Text(
//                                     '名字 State Name',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 15),
//                                   ),
//                                   Container(
//                                     width: 130,
//                                     padding: const EdgeInsets.only(right: 30),
//                                     child: TextField(
//                                       onChanged: (value) =>
//                                           newStateName = value,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               TextButton(
//                                   onPressed: () {
//                                     model.createState(
//                                         stringToStage(selectedStage),
//                                         newStateName);
//                                     Navigator.pop(context);
//                                     Navigator.pop(context);
//                                   },
//                                   child: const Text('Ok'))
//                             ],
//                           ));
//                     }),
//                   ),
//                 );
//               });
//           // setState(() {});
//         },
//         child: const Text(
//           '創建狀態 Create State',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//         ),
//       ),
//     );
//   }
// }

// class DeleteStateName extends StatefulWidget {
//   const DeleteStateName({super.key});
//   @override
//   State<DeleteStateName> createState() => _DeleteStateNameState();
// }

// class _DeleteStateNameState extends State<DeleteStateName> {
//   @override
//   Widget build(BuildContext context) {
//     Color stageToColor(MissionStage stage) {
//       // TODO: color discussion
//       if (stage == MissionStage.progress) {
//         return Colors.blue.withOpacity(0.2);
//       } else if (stage == MissionStage.pending) {
//         return Colors.purple.withOpacity(0.2);
//       } else if (stage == MissionStage.close) {
//         return Colors.red.withOpacity(0.2);
//       } else {
//         return Colors.black38;
//       }
//     }

//     InkWell chipSelected(Color color, String stateName, MissionStage stage,
//         MissionSettingViewModel model) {
//       return InkWell(
//           onTap: () {
//             if (stateName == 'in progress' ||
//                 stateName == 'pending' ||
//                 stateName == 'close') {
//               showDialog(
//                   context: context,
//                   builder: (context) => const AlertDialog(
//                         title: Text('不可刪除預設狀態'),
//                       ));
//             } else {
//               model.deleteStateName(stage, stateName);
//               Navigator.pop(context);
//               Navigator.pop(context);
//             }
//           },
//           child: Container(
//               decoration: BoxDecoration(
//                   color: color, borderRadius: BorderRadius.circular(10)),
//               child: Text(
//                 ' •$stateName ',
//                 style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold),
//               )));
//     }

//     Column contextTemple(String title, List<MissionStateModel> datas,
//         MissionStage stage, MissionSettingViewModel model) {
//       List<Widget> chips = [];

//       for (int i = 0; i < datas.length; i++) {
//         chips.add(chipSelected(
//             stageToColor(stage), datas[i].stateName, stage, model));
//         chips.add(const SizedBox(
//           height: 4,
//         ));
//       }

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//               Text(
//                 title,
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//               ),
//               const Divider(
//                 height: 7,
//                 thickness: 3,
//               )
//             ] +
//             chips,
//       );
//     }

//     return Consumer<MissionSettingViewModel>(
//       builder: (context, model, child) => TextButton(
//         onPressed: () => showDialog(
//             context: context,
//             builder: (context) {
//               return Dialog(
//                 child: Padding(
//                   padding: const EdgeInsets.all(5),
//                   child: ListView(
//                     children: [
//                       contextTemple('進行中 In Progress', model.inProgress,
//                           MissionStage.progress, model),
//                       contextTemple('待討論 Pending', model.pending,
//                           MissionStage.pending, model),
//                       contextTemple(
//                           '已結束 Close', model.close, MissionStage.close, model),
//                       const Divider(
//                         height: 7,
//                         thickness: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//         child: const Text('刪除狀態 Delete State'),
//       ),
//     );
//   }
// }

// class ContributorList extends StatefulWidget {
//   //參與的所有使用者
//   const ContributorList({super.key});
//   @override
//   State<ContributorList> createState() => _ContributorState();
// }

// class _ContributorState extends State<ContributorList> {
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

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MissionSettingViewModel>(
//       builder: (context, model, child) => Row(
//         children: model.contributors
//             .map((AccountModel profile) => RawChip(
//                   label: Text(profile.name),
//                   avatar: CircleAvatar(
//                       child: profile.photo.isEmpty
//                           ? Text(profile.name.substring(0, 1))
//                           : Image.memory(profile.photo)),
//                   selected: true,
//                   onSelected: (value) {},
//                   elevation: 4,
//                   selectedColor: const Color(0xFF2196F3),
//                 ))
//             .toList(),
//       ),
//     );
//   }
// }

// class CollabMissons extends StatelessWidget {
//   const CollabMissons({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 1),
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           padding: const EdgeInsets.symmetric(horizontal: 2),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: const [
//                 BoxShadow(color: Colors.black26, blurRadius: 2)
//               ]),
//           child:
//               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   '寒假規劃表進度',
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   '距離死線剩餘 ? D ? H ? M',
//                   style: TextStyle(fontSize: 12),
//                 )
//               ],
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 2),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.black26),
//               child: const Text(
//                 'Not Start 未開始',
//                 style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
//               ),
//             )
//           ]),
//         ));
//   }
// }

// class CollabNotes extends StatefulWidget {
//   const CollabNotes({super.key});

//   @override
//   State<CollabNotes> createState() => _CollabNotesState();
// }

// class _CollabNotesState extends State<CollabNotes> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       color: Colors.white,
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width / 3,
//         height: 60,
//         child: Stack(
//           children: [
//             Positioned(
//               left: 5,
//               top: 8,
//               child: Row(children: const [
//                 Icon(Icons.menu_book_rounded),
//                 SizedBox(
//                   width: 1,
//                 ),
//                 Text(
//                   '開發紀錄',
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                 )
//               ]),
//             ),
//             const Positioned(
//               left: 5,
//               bottom: 8,
//               child: Text(
//                 'Someone 在 5 分鐘前編輯',
//                 style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CollabMeetings extends StatefulWidget {
//   const CollabMeetings({super.key});

//   @override
//   State<CollabMeetings> createState() => _CollabMeetingsState();
// }

// class _CollabMeetingsState extends State<CollabMeetings> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       color: Colors.white,
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width / 3,
//         height: 60,
//         child: Stack(
//           children: [
//             Positioned(
//               left: 5,
//               top: 8,
//               child: Row(children: const [
//                 Icon(Icons.menu_book_rounded),
//                 SizedBox(
//                   width: 1,
//                 ),
//                 Text(
//                   '會議記錄',
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                 )
//               ]),
//             ),
//             const Positioned(
//               left: 5,
//               bottom: 8,
//               child: Text(
//                 '15 則新訊息未讀',
//                 style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
