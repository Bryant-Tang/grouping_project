// import 'package:flutter/material.dart';
// import 'package:grouping_project/View/components/color_tag_chip.dart';
// import 'package:grouping_project/View/theme/theme_manager.dart';
// import 'package:grouping_project/ViewModel/workspace/workspace_view_model_lib.dart';
// import 'package:grouping_project/model/auth/auth_model_lib.dart';
// import 'package:grouping_project/model/workspace/workspace_model_lib.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:day_night_time_picker/day_night_time_picker.dart';

// class MissionCardViewTemplate extends StatefulWidget {
//   const MissionCardViewTemplate({super.key});

//   @override
//   State<MissionCardViewTemplate> createState() =>
//       _MissionCardViewTemplateState();
// }

// class _MissionCardViewTemplateState extends State<MissionCardViewTemplate> {
//   void onClick(WorkspaceDashBoardViewModel workspaceVM,
//       MissionSettingViewModel missionSettingVM) async {
//     debugPrint('open mission page');
//     context.read<ThemeManager>().updateColorSchemeSeed(missionSettingVM.color);
//     const animationDuration = Duration(milliseconds: 400);
//     final isNeedRefresh = await Navigator.push(
//         context,
//         PageRouteBuilder(
//             transitionDuration: animationDuration,
//             reverseTransitionDuration: animationDuration,
//             pageBuilder: (BuildContext context, __, ___) =>
//                 MultiProvider(providers: [
//                   ChangeNotifierProvider<MissionSettingViewModel>.value(
//                       value: missionSettingVM),
//                   ChangeNotifierProvider<WorkspaceDashBoardViewModel>.value(
//                       value: workspaceVM)
//                 ], child: const MissionEditCardView())));
//     if (isNeedRefresh != null && isNeedRefresh) {
//       await workspaceVM.getAllData();
//     }
//     if (mounted) {
//       context
//           .read<ThemeManager>()
//           .updateColorSchemeSeed(Color(workspaceVM.accountProfileData.color));
//     }
//   }

//   Widget getStateLabelButton(
//       Function callBack, MissionStateModel state, Color color) {
//     return ElevatedButton(
//         onPressed: () => callBack(),
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.all(4.0),
//           foregroundColor: color,
//           textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//           elevation: 0,
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircleAvatar(backgroundColor: color, radius: 5),
//             const SizedBox(width: 5),
//             Text(state.stateName),
//           ],
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WorkspaceDashBoardViewModel>(
//       builder: (context, workspaceVM, child) =>
//           Consumer<MissionSettingViewModel>(
//         builder: (context, model, child) {
//           ThemeData themeData = ThemeData(
//               colorSchemeSeed: model.color,
//               brightness: context.watch<ThemeManager>().brightness);
//           // model.getAllContibutorData();
//           return Hero(
//             tag: "${model.missionModel.id}",
//             child: Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: AspectRatio(
//               // TODO: delete ratio?
//                 aspectRatio: 3.3,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: themeData.colorScheme.surface,
//                       foregroundColor: themeData.colorScheme.primary,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       elevation: 4,
//                       padding: const EdgeInsets.all(3)),
//                   onPressed: () => onClick(workspaceVM, model),
//                   child: Row(
//                     children: [
//                       Container(
//                         clipBehavior: Clip.hardEdge,
//                         decoration: BoxDecoration(
//                             borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(10),
//                                 bottomLeft: Radius.circular(10)),
//                             color: themeData.colorScheme.surfaceVariant),
//                         width: 12,
//                         // color: Theme.of(context).colorScheme.primary
//                       ),
//                       const SizedBox(width: 5),
//                       Expanded(
//                         flex: 5,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Row(
//                               children: [
//                                 ColorTagChip(
//                                     tagString: model.ownerAccountName,
//                                     color: themeData.colorScheme.primary),
//                               ],
//                             ),
//                             Text(model.title,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: themeData.textTheme.titleMedium!
//                                     .copyWith(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14)),
//                             Text(
//                               model.introduction,
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                               style: themeData.textTheme.titleSmall!.copyWith(
//                                   // color: themeData.colorScheme.secondary,
//                                   fontSize: 12),
//                             ),
//                             Row(
//                               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Icon(Icons.timer, size: 18),
//                                 Text(model.formattedDeadline,
//                                       style: themeData.textTheme.titleSmall!
//                                           .copyWith(fontSize: 12, color: themeData.colorScheme.primary),),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             getStateLabelButton(() {}, model.missionState,
//                                 model.stageColorMap[model.missionState.stage]!),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class MissionEditCardView extends StatefulWidget {
//   const MissionEditCardView({Key? key}) : super(key: key);
//   // const ExpandedCardView({super.key});

//   @override
//   State<MissionEditCardView> createState() => _EditCardViewCardViewState();
// }

// class _EditCardViewCardViewState extends State<MissionEditCardView> {
//   // late ThemeData themeData;

//   Widget getDateTime(MissionSettingViewModel model) {
//     return Row(
//       children: [
//         Icon(Icons.timer,
//             color: Theme.of(context).colorScheme.secondary, size: 16),
//         const SizedBox(width: 4),
//         Text(
//           model.getTimerCounter(),
//           style: Theme.of(context).textTheme.labelSmall!.copyWith(
//               fontSize: 14,
//               color: Theme.of(context).colorScheme.secondary,
//               fontWeight: FontWeight.bold),
//         )
//       ],
//     );
//   }

//   Widget generateContentDisplayBlock(String blockTitle, Widget child) {
//     TextStyle blockTitleTextStyle = Theme.of(context)
//         .textTheme
//         .titleMedium!
//         .copyWith(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//             color: Theme.of(context).colorScheme.secondary);
//     return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(blockTitle, style: blockTitleTextStyle),
//             const Divider(thickness: 3),
//             child
//           ],
//         ));
//   }

//   Widget getInformationDisplay(MissionSettingViewModel model) {
//     TextStyle titleTextStyle = Theme.of(context)
//         .textTheme
//         .titleMedium!
//         .copyWith(fontWeight: FontWeight.bold, fontSize: 28);
//     Widget eventOwnerLabel = Row(
//       children: [
//         ColorTagChip(
//             tagString: "事件 - ${model.ownerAccountName} 的工作區",
//             color: Theme.of(context).colorScheme.primary,
//             fontSize: 14),
//       ],
//     );
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         eventOwnerLabel,
//         TextFormField(
//           initialValue: model.title == "任務標題" ? "" : model.title,
//           style: titleTextStyle,
//           onChanged: model.updateTitle,
//           decoration: const InputDecoration(
//               hintText: "任務標題",
//               isDense: true,
//               contentPadding: EdgeInsets.symmetric(vertical: 2),
//               border: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   width: 0,
//                   style: BorderStyle.none,
//                 ),
//               )),
//           validator: model.titleValidator,
//         ),
//         getDateTime(model)
//       ],
//     );
//   }

//   Widget getMissionDescriptionDisplay(MissionSettingViewModel model) {
//     TextStyle textStyle = Theme.of(context)
//         .textTheme
//         .titleMedium!
//         .copyWith(fontWeight: FontWeight.bold, fontSize: 16);
//     return generateContentDisplayBlock(
//         '任務介紹',
//         TextFormField(
//           initialValue: model.introduction == "任務介紹" ? "" : model.introduction,
//           style: textStyle,
//           onChanged: model.updateIntroduction,
//           maxLines: null,
//           decoration: const InputDecoration(
//               hintText: "任務介紹",
//               isDense: true,
//               contentPadding: EdgeInsets.symmetric(vertical: 2),
//               border: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   width: 0,
//                   style: BorderStyle.none,
//                 ),
//               )),
//           validator: model.introductionValidator,
//         ));
//   }

//   void showTimePicker(
//       Function callBack, BuildContext context, DateTime initialTime) {
//     showDialog(
//         context: context,
//         builder: ((BuildContext context) {
//           return AlertDialog(
//             title: const Text('選擇時間'),
//             content: SizedBox(
//               height: MediaQuery.of(context).size.height * 0.4,
//               width: MediaQuery.of(context).size.height * 0.8,
//               child: SfDateRangePicker(
//                 initialSelectedDate: initialTime,
//                 onSubmit: (value) {
//                   // debugPrint(value.toString());
//                   Navigator.pop(context);
//                   Navigator.of(context).push(
//                     showPicker(
//                         is24HrFormat: true,
//                         value: Time(
//                             hour: initialTime.hour, minute: initialTime.minute),
//                         onChange: (newTime) {
//                           debugPrint(value.runtimeType.toString());
//                           debugPrint(newTime.toString());
//                           callBack((value as DateTime).copyWith(
//                             hour: newTime.hour,
//                             minute: newTime.minute,
//                           ));
//                         }),
//                   );
//                 },
//                 onCancel: () {
//                   Navigator.pop(context);
//                 },
//                 showActionButtons: true,
//               ),
//             ),
//           );
//         }));
//   }

//   Widget getStateLabelButton(
//       Function callBack, MissionStateModel state, Color color) {
//     return Padding(
//       padding: const EdgeInsets.all(6.0),
//       child: ElevatedButton(
//           onPressed: () => callBack(),
//           style: ElevatedButton.styleFrom(
//             side: BorderSide(color: color),
//             foregroundColor: color,
//             // backgroundColor: color.withOpacity(0.1),
//             textStyle:
//                 const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             elevation: 4,
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircleAvatar(backgroundColor: color, radius: 5),
//               const SizedBox(width: 5),
//               Text(state.stateName),
//             ],
//           )),
//     );
//   }

//   Widget getDeadlineBlock(MissionSettingViewModel model) {
//     return generateContentDisplayBlock(
//         '截止時間',
//         ElevatedButton(
//             onPressed: () => showTimePicker(
//                 model.updateDeadline, context, model.missionDeadline),
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5),
//               ),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.access_time),
//                 const SizedBox(width: 10),
//                 Text(model.formattedDeadline),
//               ],
//             )));
//   }

//   Widget getContributorButton(
//       MissionSettingViewModel model, AccountModel account) {
//     return Padding(
//         padding: const EdgeInsets.all(6.0),
//         child: RawChip(
//             onPressed: () => model.updateContibutor(account),
//             // onDeleted: () => model.updateContibutor(account),
//             // deleteIcon: model.isContributors(account) ? const Icon(Icons.delete) : const Icon(Icons.add),
//             selected: model.isContributors(account),
//             elevation: 3,
//             label: Text(account.nickname),
//             avatar: CircleAvatar(
//                 backgroundImage: account.photo.isEmpty
//                     ? Image.asset('assets/images/profile_male.png').image
//                     : Image.memory(account.photo).image)));
//   }

//   void onUpdateContributor(MissionSettingViewModel model) {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) =>
//             ChangeNotifierProvider<MissionSettingViewModel>.value(
//               value: model,
//               child: Consumer<MissionSettingViewModel>(
//                 builder: (context, model, child) => SafeArea(
//                   child: Column(
//                     children: [
//                       Expanded(
//                           child: model.contributorCandidate.isEmpty
//                               ? const Center(child: Text('無其他成員'))
//                               : Padding(
//                                   padding: const EdgeInsets.all(20.0),
//                                   child: Wrap(
//                                       children: List.generate(
//                                           model.contributorCandidate.length,
//                                           (index) => getContributorButton(
//                                               model,
//                                               model.contributorCandidate[
//                                                   index]))),
//                                 )),
//                     ],
//                   ),
//                 ),
//               ),
//             ));
//     // debugPrint(model.contributors.length.toString());
//   }

//   Widget getContributorBlock(MissionSettingViewModel model) {
//     return generateContentDisplayBlock(
//         '參與者',
//         MaterialButton(
//           onPressed: () async {
//             // debugPrint(model.missionModel.contributorIds.length.toString());
//             onUpdateContributor(model);
//           },
//           child: model.contributors.isEmpty
//               ? const Text('参加者はいません')
//               : Wrap(
//                 children: List.generate(
//                     model.contributors.length,
//                     (index) => getContributorButton(
//                         model, model.contributors[index])),
//               ),
//         ));
//   }

//   Widget getStateBlock(MissionSettingViewModel model) {
//     return generateContentDisplayBlock(
//         '任務狀態',
//         getStateLabelButton(() => onUpdateState(model), model.missionState,
//             model.stageColorMap[model.missionState.stage]!));
//   }

//   void onUpdateState(MissionSettingViewModel model) {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) =>
//             ChangeNotifierProvider<MissionSettingViewModel>.value(
//               value: model,
//               child: Consumer<MissionSettingViewModel>(
//                 builder: (context, model, child) => SafeArea(
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: ListView(
//                             children: <Widget>[
//                               generateContentDisplayBlock(
//                                   '進行中 In Progress',
//                                   Column(
//                                       children: List.from(model.inProgress.map(
//                                           (stateLabel) => getStateLabelButton(
//                                                   () {
//                                                 model.updateState(stateLabel);
//                                                 Navigator.pop(context);
//                                               },
//                                                   stateLabel,
//                                                   model.stageColorMap[
//                                                       stateLabel.stage]!))))),
//                               generateContentDisplayBlock(
//                                   '待討論 Pending',
//                                   Column(
//                                       children: List.from(model.pending.map(
//                                           (stateLabel) => getStateLabelButton(
//                                                   () {
//                                                 model.updateState(stateLabel);
//                                                 Navigator.pop(context);
//                                               },
//                                                   stateLabel,
//                                                   model.stageColorMap[
//                                                       stateLabel.stage]!))))),
//                               generateContentDisplayBlock(
//                                 '已結束 Close',
//                                 Column(
//                                     children: List.from(model.close.map(
//                                         (stateLabel) => getStateLabelButton(() {
//                                               model.updateState(stateLabel);
//                                               Navigator.pop(context);
//                                             },
//                                                 stateLabel,
//                                                 model.stageColorMap[
//                                                     stateLabel.stage]!)))),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ));
//   }

//   void onFinish(MissionSettingViewModel model) async {
//     if (formKey.currentState!.validate()) {
//       final isNeedRefresh = await showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: const Text('確認'),
//               content: const Text('是否確認編輯?'),
//               actions: [
//                 TextButton(
//                     onPressed: () {
//                       Navigator.pop(context, false);
//                     },
//                     child: const Text('否')),
//                 TextButton(
//                     onPressed: () async {
//                       await model.createMission();
//                       if (context.mounted) {
//                         Navigator.pop(context, true);
//                       }
//                     },
//                     child: const Text('是')),
//               ],
//             );
//           });
//       if (context.mounted && isNeedRefresh) {
//         Navigator.pop(context, isNeedRefresh);
//       }
//     }
//   }

//   void onDelete(MissionSettingViewModel model) async {
//     final isNeedRefresh = await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('確認'),
//             content: const Text('是否確認刪除'),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.pop(context, false);
//                   },
//                   child: const Text('否')),
//               TextButton(
//                   onPressed: () async {
//                     await model.deleteMission();
//                     if (context.mounted) {
//                       Navigator.pop(context, true);
//                     }
//                   },
//                   child: const Text('是')),
//             ],
//           );
//         });
//     if (context.mounted) {
//       // context
//       //     .watch<ThemeManager>()
//       //     .updateColorSchemeSeed(Color(context.watch<WorkspaceDashBoardViewModel>().accountProfileData.color));
//       Navigator.pop(context, isNeedRefresh);
//     }
//   }

//   final formKey = GlobalKey<FormState>();
//   Stream<DateTime> currentTimeStream = Stream<DateTime>.periodic(
//     const Duration(seconds: 1),
//     (_) => DateTime.now(),
//   );
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeManager>(
//       builder: (context, theme, child) => Consumer<WorkspaceDashBoardViewModel>(
//         builder: (context, workspaceVM, child) =>
//             Consumer<MissionSettingViewModel>(builder: (context, model, child) {
//           // theme.updateColorSchemeSeed(model.color);
//           return StreamBuilder<DateTime>(
//             stream: currentTimeStream,
//             builder: (context, snapshot) => GestureDetector(
//               onTap: () {
//                 FocusScope.of(context).unfocus();
//               },
//               child: Hero(
//                 tag: "${model.missionModel.id}",
//                 child: Scaffold(
//                   appBar: AppBar(
//                     backgroundColor: Theme.of(context).colorScheme.surface,
//                     elevation: 2,
//                     leading: IconButton(
//                       onPressed: () {
//                         // theme.updateColorSchemeSeed(
//                         //   Color(workspaceVM.accountProfileData.color));
//                         Navigator.pop(context);
//                       },
//                       icon: Icon(Icons.arrow_back_ios_rounded,
//                           color:
//                               Theme.of(context).colorScheme.onSurfaceVariant),
//                     ),
//                     actions: [
//                       IconButton(
//                         onPressed: () => onFinish(model),
//                         icon: Icon(Icons.check,
//                             color:
//                                 Theme.of(context).colorScheme.onSurfaceVariant),
//                       ),
//                       IconButton(
//                           onPressed: () => onDelete(model),
//                           icon: const Icon(Icons.delete))
//                     ],
//                   ),
//                   // display all event data
//                   body: SingleChildScrollView(
//                     child: Form(
//                       key: formKey,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 10),
//                         child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               getInformationDisplay(model),
//                               getMissionDescriptionDisplay(model),
//                               getStateBlock(model),
//                               getDeadlineBlock(model),
//                               getContributorBlock(model),
//                               generateContentDisplayBlock('子任務', Text('沒有子任務')),
//                               // model.missionModel.relatedMissionIds.isEmpty
//                               //     ? const

//                               //     : ListView.builder(
//                               //         shrinkWrap: true,
//                               //         physics:
//                               //             const NeverScrollableScrollPhysics(),
//                               //         itemCount: model.eventModel
//                               //             .relatedMissionIds.length,
//                               //         itemBuilder: (context, index) => Text(
//                               //             model.eventModel
//                               //                 .relatedMissionIds[index]))),
//                               // relation note
//                               generateContentDisplayBlock(
//                                   '關聯筆記', const Text('沒有關聯筆記')),
//                               // relation message
//                               generateContentDisplayBlock(
//                                   '關聯話題', const Text('沒有關聯話題')),
//                             ]),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
