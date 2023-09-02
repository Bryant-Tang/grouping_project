// import 'package:day_night_time_picker/day_night_time_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:grouping_project/View/components/activity_components/event_components.dart';
// // import 'package:googleapis/apigeeregistry/v1.dart';
// import 'package:grouping_project/View/components/color_tag_chip.dart';
// import 'package:grouping_project/ViewModel/workspace/event_view_model.dart';
// import 'package:path/path.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// class EventCardComponent {
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

//   _generateContentDisplayBlock(
//       String blockTitle, Widget child, BuildContext context) {
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

//   _showTimePicker(
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
//                 onSubmit: (value) {
//                   debugPrint(value.toString());
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
//                 initialSelectedDate: initialTime,
//                 showActionButtons: true,
//               ),
//             ),
//           );
//         }));
//   }

//   Widget getInformationDisplay(
//       EventSettingViewModel model, BuildContext context) {
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
//       EventSettingViewModel model, BuildContext context) {
//     TextStyle textStyle = Theme.of(context)
//         .textTheme
//         .titleMedium!
//         .copyWith(fontWeight: FontWeight.bold, fontSize: 16);
//     return _generateContentDisplayBlock(
//         '事件介紹',
//         TextFormField(
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
//         ),
//         context);
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
//       EventSettingViewModel model, BuildContext context) {
//     return _generateContentDisplayBlock('參與者', MaterialButton(
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
//     ), context);
//   }


// }
