// import 'package:flutter/material.dart';
// import 'package:grouping_project/View/components/activity_components/cards_components.dart';
// import 'package:grouping_project/View/components/color_tag_chip.dart';
// import 'package:grouping_project/View/theme/theme_manager.dart';
// import 'package:grouping_project/ViewModel/workspace/workspace_view_model_lib.dart';
// import 'package:provider/provider.dart';

// class EventCardViewTemplate extends StatefulWidget {
//   const EventCardViewTemplate({super.key});

//   @override
//   State<EventCardViewTemplate> createState() => _EventCardViewTemplateState();
// }

// class _EventCardViewTemplateState extends State<EventCardViewTemplate> {
//   void onClick(WorkspaceDashBoardViewModel workspaceVM,
//       EventSettingViewModel eventSettingVM) async {
//     // debugPrint('open event page');
//     context.read<ThemeManager>().updateColorSchemeSeed(eventSettingVM.color);
//     const animationDuration = Duration(milliseconds: 400);
//     final isNeedRefresh = await Navigator.push(
//         context,
//         PageRouteBuilder(
//             transitionDuration: animationDuration,
//             reverseTransitionDuration: animationDuration,
//             pageBuilder: (BuildContext context, __, ___) =>
//                 MultiProvider(providers: [
//                   ChangeNotifierProvider<EventSettingViewModel>.value(
//                       value: eventSettingVM),
//                   ChangeNotifierProvider<WorkspaceDashBoardViewModel>.value(
//                       value: workspaceVM)
//                 ], child: const EventEditCardView())));
//     if (isNeedRefresh != null && isNeedRefresh) {
//       await workspaceVM.getAllData();
//     }
//     if (mounted) {
//       context
//           .read<ThemeManager>()
//           .updateColorSchemeSeed(Color(workspaceVM.accountProfileData.color));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WorkspaceDashBoardViewModel>(
//       builder: (context, workspaceVM, child) => Consumer<EventSettingViewModel>(
//         builder: (context, model, child) {
//           ThemeData themeData = ThemeData(
//               colorSchemeSeed: model.color,
//               brightness: context.watch<ThemeManager>().brightness);
//           return Hero(
//             tag: "${model.eventModel.id}",
//             child: Padding(
//               padding: const EdgeInsets.all(5.0),
//               // TODO: delete ratio?
//               child: AspectRatio(
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
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Row(
//                               children: [
//                                 ColorTagChip(
//                                     tagString: model.eventOwnerAccount.nickname,
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
//                               children: [
//                                 Text(model.formattedStartTime,
//                                     style: themeData.textTheme.titleSmall!
//                                         .copyWith(fontSize: 12, color: themeData.colorScheme.primary)),
//                                 const Icon(Icons.arrow_right_rounded),
//                                 Expanded(
//                                   child: Text(model.formattedEndTime,
//                                       style: themeData.textTheme.titleSmall!
//                                           .copyWith(fontSize: 12, color: themeData.colorScheme.primary),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis),
//                                 )
//                               ],
//                             )
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


// class EventEditCardView extends StatefulWidget {
//   const EventEditCardView({Key? key}) : super(key: key);
//   // const ExpandedCardView({super.key});

//   @override
//   State<EventEditCardView> createState() => _EditEventCardViewState();
// }

// class _EditEventCardViewState extends State<EventEditCardView> {
//   // EditableCard({BuildContext context, EditableViewModel viewModel)};

//   _getDateTime(EventSettingViewModel model, BuildContext context) {
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

//   Widget getInformationDisplay(
//       EventSettingViewModel model) {
//     TextStyle titleTextStyle = Theme.of(context)
//         .textTheme
//         .titleMedium!
//         .copyWith(fontWeight: FontWeight.bold, fontSize: 28);
//     Widget eventOwnerLabel = Row(
//       children: [
//         ColorTagChip(
//             // tagString: "事件 - ${model.eventModel.ownerAccount.nickname} 的工作區",
//             tagString: "NoName 的工作區",
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
//           initialValue: model.title == "事件標題" ? "" : model.title,
//           style: titleTextStyle,
//           onChanged: model.updateTitle,
//           decoration: const InputDecoration(
//               hintText: "事件標題",
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
//         _getDateTime(model, context)
//       ],
//     );
//   }

//   Widget getEventDescriptionDisplay(
//       EventSettingViewModel model) {
//     TextStyle textStyle = Theme.of(context)
//         .textTheme
//         .titleMedium!
//         .copyWith(fontWeight: FontWeight.bold, fontSize: 16);
//     return GenerateContentDisplayBlock(
//         blockTitle: '事件介紹',
//         child: TextFormField(
//           initialValue: model.introduction == "事件介紹" ? "" : model.introduction,
//           style: textStyle,
//           onChanged: model.updateIntroduction,
//           maxLines: null,
//           decoration: const InputDecoration(
//               hintText: "事件介紹",
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

//   // Widget getContributorButton(
//   //     EventSettingViewModel model, AccountModel account) {
//   //   return Padding(
//   //       padding: const EdgeInsets.all(6.0),
//   //       child: RawChip(
//   //           onPressed: () => model.updateContibutor(account),
//   //           // onDeleted: () => model.updateContibutor(account),
//   //           // deleteIcon: model.isContributors(account) ? const Icon(Icons.delete) : const Icon(Icons.add),
//   //           selected: model.isContributors(account),
//   //           elevation: 3,
//   //           label: Text(account.nickname),
//   //           avatar: CircleAvatar(
//   //               backgroundImage: account.photo.isEmpty
//   //                   ? Image.asset('assets/images/profile_male.png').image
//   //                   : Image.memory(account.photo).image)));
//   // }

//   void _onUpdateContributor(EventSettingViewModel model, BuildContext context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) =>
//             ChangeNotifierProvider<EventSettingViewModel>.value(
//               value: model,
//               child: Consumer<EventSettingViewModel>(
//                 builder: (context, model, child) => SafeArea(
//                   child: Column(
//                     children: [
//                       // Expanded(
//                       //     child: model.contributorCandidate.isEmpty
//                       //         ? const Center(child: Text('無其他成員'))
//                       //         : Padding(
//                       //             padding: const EdgeInsets.all(20.0),
//                       //             child: Wrap(
//                       //                 children: List.generate(
//                       //                     model.contributorCandidate.length,
//                       //                     (index) => getContributorButton(
//                       //                         model,
//                       //                         model.contributorCandidate[
//                       //                             index]))),
//                       //           )),
//                     ],
//                   ),
//                 ),
//               ),
//             ));
//     // debugPrint(model.contributors.length.toString());
//   }

//   Widget getContributorBlock(
//       EventSettingViewModel model) {
//         return GenerateContentDisplayBlock(blockTitle: '參與者', child: MaterialButton(
//       onPressed: () async {
//         // debugPrint(model.eventModel.contributorIds.length.toString());
//         _onUpdateContributor(model, context);
//       },
//       // child: model.contributors.isEmpty
//       //     ? const Text('沒有參與者')
//       //     : Wrap(
//       //         children: List.generate(
//       //             model.contributors.length,
//       //             (index) => getContributorButton(
//       //                 model, model.contributors[index])),
//       //       ),
//     ));
//   }

//   void onFinish(EventSettingViewModel model) async {
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
//                       // await model.createEvent();           // TODO: craeteEvent
//                       if (context.mounted) {
//                         Navigator.pop(context, true);
//                       }
//                     },
//                     child: const Text('確認')),
//               ],
//             );
//           });
//       if (context.mounted && isNeedRefresh) {
//         Navigator.pop(context, isNeedRefresh);
//       }
//     }
//   }

//   void onDelete(EventSettingViewModel model) async {
//     final isNeedRefresh = await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('確認'),
//             content: const Text('是否確認刪除?'),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.pop(context, false);
//                   },
//                   child: const Text('否')),
//               TextButton(
//                   onPressed: () async {
//                     // await model.deleteEvent();                         // TODO: delete event
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
//             Consumer<EventSettingViewModel>(builder: (context, model, child) {
//           return StreamBuilder<DateTime>(
//             stream: currentTimeStream,
//             builder: (context, snapshot) => GestureDetector(
//               onTap: () {
//                 FocusScope.of(context).unfocus();
//               },
//               child: Hero(
//                 tag: "${model.eventModel.id}",
//                 child: Scaffold(
//                   appBar: AppBar(
//                     backgroundColor: Theme.of(context).colorScheme.surface,
//                     elevation: 2,
//                     leading: IconButton(
//                       onPressed: () {
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
//                               getEventDescriptionDisplay(model),
//                               GetTimeBlock(
//                                   callBack: model.updateStartTime,
//                                   blockTitle: '開始時間',
//                                   oldTime: model.startTime),
//                               GetTimeBlock(
//                                   callBack: model.updateEndTime,
//                                   blockTitle: '結束時間',
//                                   oldTime: model.endTime),
//                               // getStartTimeBlock(model),
//                               // getEndTimeBlock(model),
//                               getContributorBlock(model),
//                               // generateContentDisplayBlock(
//                               //     '子任務', const Text('沒有子任務')),
//                               // // relation note
//                               // generateContentDisplayBlock(
//                               //     '關聯筆記', const Text('沒有關聯筆記')),
//                               // // relation message
//                               // generateContentDisplayBlock(
//                               //     '關聯話題', const Text('沒有關聯話題')),
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
