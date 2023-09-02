// import 'package:flutter/material.dart';
// import 'package:grouping_project/View/app/workspace/EditableCard/event_card_view.dart';
// import 'package:grouping_project/View/app/workspace/EditableCard/mission_card_view.dart';
// import 'package:grouping_project/ViewModel/workspace/workspace_view_model_lib.dart';
// import 'package:grouping_project/model/workspace/workspace_model_lib.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// class CalendarPersonalViewPage extends StatefulWidget {
//   const CalendarPersonalViewPage({super.key});

//   @override
//   State<CalendarPersonalViewPage> createState() =>
//       _CalendarPersonalViewPageState();
// }

// class _CalendarPersonalViewPageState extends State<CalendarPersonalViewPage> {
//   // TODO: do I really need that?
//   CalendarController controller = CalendarController();

//   @override
//   void initState() {
//     super.initState();
//     controller.view = CalendarView.month;
//     controller.displayDate = DateTime.now().copyWith(
//       hour: 0,
//       minute: 0,
//       second: 0,
//       microsecond: 0,
//       millisecond: 0,
//     );
//     controller.selectedDate = DateTime.now().copyWith(
//       hour: 0,
//       minute: 0,
//       second: 0,
//       microsecond: 0,
//       millisecond: 0,
//     );
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   showActivityList(
//       {required CalendarController controller,
//       required WorkspaceDashBoardViewModel workspaceVM,
//       required CalendarViewModel calendarVM}) {
//     if (controller.view == CalendarView.day) {
//       return const SizedBox();
//     } else {
//       calendarVM.activityAtTheDay.sort((a, b) {
//         if (a is EventModel && b is EventModel) {
//           return a.startTime.compareTo(b.startTime);
//         } else if (a is EventModel && b is MissionModel) {
//           return 1;
//         } else if (a is MissionModel && b is EventModel) {
//           return -1;
//         } else if (a is MissionModel && b is MissionModel) {
//           return a.deadline.compareTo(b.deadline);
//         } else {
//           return 0;
//         }
//       });
//       return Expanded(
//         flex: 2,
//         child: ListView.builder(
//           itemCount: calendarVM.activityAtTheDay.length,
//           itemBuilder: (context, index) {
//             if (calendarVM.activityAtTheDay.isNotEmpty &&
//                 calendarVM.activityAtTheDay.length > index) {
//               return InkWell(
//                 key: calendarVM.activityAtTheDay.isEmpty
//                     ? null
//                     : ValueKey(calendarVM.activityAtTheDay[index]),
//                 onTap: () {
//                   activityOnTap(
//                       data: calendarVM.activityAtTheDay[index],
//                       context: context,
//                       workspaceVM: workspaceVM);
//                 },
//                 child: showSingleAgendaViewForDot(
//                     data: calendarVM.activityAtTheDay[index],
//                     controller: controller,
//                     calendarVM: calendarVM),
//               );
//             }
//             else{
//               return const Center(child: Text('someing wrong at "calendar_personal_calendar_page_view" at 93.'));
//             }
//           },
//         ),
//       );
//     }
//   }

//   /// For seperating the agenda view template, only call it by the show activity func.
//   showSingleAgendaViewForDot(
//       {required BaseDataModel data,
//       required CalendarViewModel calendarVM,
//       CalendarAppointmentDetails? calendarAppointmentDetails,
//       required CalendarController controller}) {
//     double height = calendarAppointmentDetails == null
//         ? 50
//         : calendarAppointmentDetails.bounds.height;
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 5,
//         horizontal: 7,
//       ),
//       child: Row(children: [
//         // Expanded(
//         // flex: 3,
//         // child:
//         // TODO: delete if not used
//         Expanded(
//           flex: 2,
//           child: data is EventModel
//               // is Event
//               ? data.startTime.day == data.endTime.day
//                   ? Column(children: [
//                       Text(DateFormat('hh:mm a').format(data.startTime),
//                           style: TextStyle(
//                               fontSize: height * 0.2,
//                               fontWeight: FontWeight.bold)),
//                       Text(DateFormat('hh:mm a').format(data.endTime),
//                           style: TextStyle(
//                               fontSize: height * 0.2,
//                               fontWeight: FontWeight.bold))
//                     ])
//                   // is all-day of event?
//                   : controller.selectedDate!.day != data.startTime.day &&
//                           controller.selectedDate!.day != data.endTime.day
//                       ? Center(
//                           child: Text('All-Day',
//                               style: TextStyle(
//                                   fontSize: height * 0.2,
//                                   fontWeight: FontWeight.bold)),
//                         )
//                       : Column(
//                           children:
//                               controller.selectedDate!.day == data.startTime.day
//                                   ? [
//                                       Text(
//                                           DateFormat('hh:mm a')
//                                               .format(data.startTime),
//                                           style: TextStyle(
//                                               fontSize: height * 0.2,
//                                               fontWeight: FontWeight.bold)),
//                                       Text('Start',
//                                           style: TextStyle(
//                                               fontSize: height * 0.2,
//                                               fontWeight: FontWeight.bold))
//                                     ]
//                                   : [
//                                       Text(
//                                           DateFormat('hh:mm a')
//                                               .format(data.startTime),
//                                           style: TextStyle(
//                                               fontSize: height * 0.2,
//                                               fontWeight: FontWeight.bold)),
//                                       Text('End',
//                                           style: TextStyle(
//                                               fontSize: height * 0.2,
//                                               fontWeight: FontWeight.bold))
//                                     ],
//                         )
//               // is Mission
//               : Column(
//                   children: [
//                     Text('Deadline',
//                         style: TextStyle(
//                             fontSize: height * 0.2,
//                             fontWeight: FontWeight.bold)),
//                     Text(
//                         DateFormat('hh:mm a')
//                             .format((data as MissionModel).deadline),
//                         style: TextStyle(
//                             fontSize: height * 0.2,
//                             fontWeight: FontWeight.bold))
//                   ],
//                 ),
//         ),
//         // ),
//         Expanded(
//           flex: 1,
//           child: SizedBox(
//               height: height,
//               child: VerticalDivider(
//                 thickness: 2,
//                 color: data is EventModel
//                     // color: data.toString() == 'Instance of \'EventModel\''
//                     ? Color(data.ownerAccount.color)
//                     : Color((data as MissionModel).ownerAccount.color),
//               )),
//         ),
//         Expanded(
//             flex: 10,
//             child: data is EventModel
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(data.title,
//                           style: TextStyle(
//                               fontSize: height * 0.25,
//                               fontWeight: FontWeight.bold),
//                           overflow: TextOverflow.ellipsis),
//                       Text(
//                         data.introduction,
//                         style: TextStyle(fontSize: height * 0.2),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 3,
//                       ),
//                     ],
//                   )
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         flex: 7,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text((data as MissionModel).title,
//                                 style: TextStyle(
//                                     fontSize: height * 0.25,
//                                     fontWeight: FontWeight.bold),
//                                 overflow: TextOverflow.ellipsis),
//                             Text(
//                               data.introduction,
//                               style: TextStyle(fontSize: height * 0.2),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Flexible(
//                         flex: 3,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 3),
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                   color: calendarVM
//                                       .stageColorMap[data.state.stage]!),
//                               borderRadius: BorderRadius.circular(10)
//                               // elevation: 4,
//                               ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               CircleAvatar(
//                                   backgroundColor: calendarVM
//                                       .stageColorMap[data.state.stage]!,
//                                   radius: 5),
//                               const SizedBox(width: 5),
//                               Text(
//                                 data.state.stateName,
//                                 style: TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                     color: calendarVM
//                                         .stageColorMap[data.state.stage]!),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   )),
//       ]),
//     );
//   }

//   /// only for day view in sfCalendar
//   showDayView(
//       {required BaseDataModel data,
//       required CalendarViewModel calendarVM,
//       required CalendarAppointmentDetails calendarAppointmentDetails,
//       required CalendarController controller}) {
//     if (data is EventModel) {
//       return data.startTime.copyWith(hour: 0, minute: 0) ==
//               data.endTime.copyWith(hour: 0, minute: 0)
//           ? Container(
//               //TODO: when time range is very small => overflow occur
//               padding: const EdgeInsets.all(5),
//               width: calendarAppointmentDetails.bounds.width,
//               height: calendarAppointmentDetails.bounds.height,
//               decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.black12)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(data.title,
//                       style: TextStyle(
//                         fontSize:
//                             (calendarAppointmentDetails.bounds.height * 0.25)
//                                 .clamp(1, 20),
//                         fontWeight: FontWeight.bold,
//                       ),
//                       overflow: TextOverflow.ellipsis),
//                   Text(
//                     data.introduction,
//                     style: TextStyle(
//                       fontSize: (calendarAppointmentDetails.bounds.height * 0.2)
//                           .clamp(1, 20),
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             )
//           : Container(
//               padding: const EdgeInsets.only(left: 3),
//               decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.black12)),
//               // TODO: VM
//               child: Text(
//                 '${data.title} (${controller.displayDate!.day - data.startTime.day + 1}/${data.endTime.day - data.startTime.day + 1})'
//                 '  ${data.startTime.day == controller.displayDate!.day ? DateFormat('hh:mm a').format(data.startTime) : ''} ~ '
//                 '${data.endTime.day == controller.displayDate!.day ? DateFormat('hh:mm a').format(data.endTime) : ''}',
//                 style:
//                     const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
//               ),
//             );
//     } else if (data is MissionModel) {
//       // TODO:check if the mission look right
//       return Container(
//         //TODO: when time range is very small => overflow occur
//         padding: const EdgeInsets.all(5),
//         width: calendarAppointmentDetails.bounds.width,
//         height: calendarAppointmentDetails.bounds.height,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: Color(data.ownerAccount.color))),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             FittedBox(
//               alignment: Alignment.centerLeft,
//               child: Text(data.title,
//                   style: TextStyle(
//                     fontSize: (calendarAppointmentDetails.bounds.height * 0.25)
//                         .clamp(1, 20),
//                     fontWeight: FontWeight.bold,
//                   ),
//                   overflow: TextOverflow.clip),
//             ),
//             Flexible(
//               flex: 3,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 3),
//                 decoration: BoxDecoration(
//                     border: Border.all(
//                         color: calendarVM.stageColorMap[data.state.stage]!),
//                     borderRadius: BorderRadius.circular(10)
//                     // elevation: 4,
//                     ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CircleAvatar(
//                         backgroundColor:
//                             calendarVM.stageColorMap[data.state.stage]!,
//                         radius: 5),
//                     const SizedBox(width: 5),
//                     Text(
//                       data.state.stateName,
//                       style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                           color: calendarVM.stageColorMap[data.state.stage]!),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//     } else {
//       return Container();
//     }
//   }

//   Future<DateTime?> popupDatePicker(CalendarController controller) {
//     DateTime? selectedDate = DateTime.now();
//     return showDialog<DateTime>(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           child: SizedBox(
//             height: 400,
//             // width: 200,
//             child: SfDateRangePicker(
//               initialSelectedDate: DateTime.now(),
//               selectionMode: DateRangePickerSelectionMode.single,
//               showActionButtons: true,
//               onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
//                 controller.selectedDate = args.value;
//                 controller.displayDate = args.value;
//               },
//               onCancel: () {
//                 Navigator.pop(context);
//               },
//               onSubmit: (p0) {
//                 Navigator.pop(context, selectedDate);
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: IgnorePointer(
//         //Try to stop taps until build
//         ignoring: !mounted,
//         child: Consumer<WorkspaceDashBoardViewModel>(
//           builder: (context, workspaceVM, child) =>
//               ChangeNotifierProvider<CalendarViewModel>(
//             create: (context) => CalendarViewModel(
//                 events: workspaceVM.events,
//                 missions: workspaceVM.missions,
//                 defaultSelectedDate: DateTime(DateTime.now().year,
//                     DateTime.now().month, DateTime.now().day)),
//             child: Consumer<CalendarViewModel>(
//               builder: (context, calendarVM, child) {
//                 controller.view == CalendarView.month
//                     ? calendarVM.getActivityByDots()
//                     : calendarVM.getActivityByLabel();
//                 return Column(children: [
//                   Expanded(
//                     flex: 3,
//                     child: Center(
//                       child: Padding(
//                         // TODO: limit calendar height
//                         padding: const EdgeInsets.only(
//                             bottom: 10, left: 5, right: 5),
//                         child: SfCalendar(
//                           key: ValueKey(controller.view),
//                           view: controller.view!,
//                           controller: controller,
//                           dataSource: calendarVM.activitySource,
//                           firstDayOfWeek: 1,
//                           todayHighlightColor:
//                               Theme.of(context).colorScheme.primary,
//                           todayTextStyle: TextStyle(
//                             color: Theme.of(context).colorScheme.onSecondary,
//                           ),
//                           initialSelectedDate: DateTime.now(),
//                           // by default the month appointment display mode set as Indicator, we can
//                           // change the display mode as appointment using the appointment display
//                           // mode property
//                           onTap: (calendarTapDetails) {
//                             if (calendarTapDetails.targetElement ==
//                                 CalendarElement.header) {
//                               popupDatePicker(controller);
//                             } else if (((calendarTapDetails.targetElement ==
//                                         CalendarElement.calendarCell) &&
//                                     (controller.selectedDate ==
//                                         calendarVM.lastSelectedDate)) ||
//                                 (calendarTapDetails.targetElement ==
//                                     CalendarElement.viewHeader)) {
//                               calendarVM.changeView(
//                                   controller: controller,
//                                   toMontView:
//                                       controller.view != CalendarView.month);
//                             } else if (calendarTapDetails.targetElement ==
//                                 CalendarElement.appointment) {
//                               if (calendarTapDetails.appointments![0]
//                                   is EventModel) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => MultiProvider(
//                                       providers: [
//                                         ChangeNotifierProvider<
//                                                 WorkspaceDashBoardViewModel>.value(
//                                             value: workspaceVM),
//                                         ChangeNotifierProvider<
//                                             EventSettingViewModel>(
//                                           create: (context) =>
//                                               EventSettingViewModel()
//                                                 ..initializeDisplayEvent(
//                                                   model: calendarTapDetails
//                                                       .appointments![0],
//                                                   user: context
//                                                       .read<
//                                                           WorkspaceDashBoardViewModel>()
//                                                       .personalprofileData,
//                                                 ),
//                                         )
//                                       ],
//                                       child: const EventEditCardView(),
//                                     ),
//                                   ),
//                                 );
//                               } else if (calendarTapDetails.appointments![0]
//                                   is MissionModel) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => MultiProvider(
//                                       providers: [
//                                         ChangeNotifierProvider<
//                                                 WorkspaceDashBoardViewModel>.value(
//                                             value: workspaceVM),
//                                         ChangeNotifierProvider<
//                                                 MissionSettingViewModel>(
//                                             create: (context) =>
//                                                 MissionSettingViewModel()
//                                                   ..initializeDisplayMission(
//                                                       model: calendarTapDetails
//                                                           .appointments![0],
//                                                       user: context
//                                                           .read<
//                                                               WorkspaceDashBoardViewModel>()
//                                                           .personalprofileData))
//                                       ],
//                                       child: const MissionEditCardView(),
//                                     ),
//                                   ),
//                                 );
//                               }
//                             }
//                           },
//                           onSelectionChanged: (calendarSelectionDetails) {
//                             if ((calendarSelectionDetails.date != null) &&
//                                 (calendarSelectionDetails.date !=
//                                     calendarVM.lastSelectedDate)) {
//                               calendarVM.selectedDate =
//                                   calendarSelectionDetails.date ??
//                                       calendarVM.lastSelectedDate;
//                               calendarVM.setDate(controller);
//                             }
//                           },
//                           onViewChanged: (viewChangedDetails) {
//                             controller.view == CalendarView.month
//                                 ? calendarVM.getActivityByDots()
//                                 : calendarVM.getActivityByLabel();
//                           },
//                           // allowViewNavigation: true,
//                           headerStyle: CalendarHeaderStyle(
//                             textStyle: Theme.of(context)
//                                 .textTheme
//                                 .labelLarge!
//                                 .copyWith(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onPrimaryContainer,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                             textAlign: TextAlign.center,
//                             backgroundColor: Colors.transparent,
//                           ),
//                           monthViewSettings: const MonthViewSettings(
//                             // appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
//                             appointmentDisplayMode:
//                                 MonthAppointmentDisplayMode.indicator,
//                             // 瑞弟: 顯示點點或 event 的 name(預設 false)
//                           ),
//                           headerHeight: 50,
//                           // 瑞弟: this function can customize the view of event
//                           appointmentBuilder:
//                               (context, calendarAppointmentDetails) {
//                             // this is iterator
//                             final BaseDataModel data =
//                                 calendarAppointmentDetails.appointments.first;
//                             // debugPrint((data as MissionModel).title);
//                             // the view of event
//                             // 如果當前顯示是 day，切換顯示方式
//                             if (controller.view == CalendarView.day) {
//                               // 如果當前顯示是 month，切換顯示方式
//                               // TODO:place day view
//                               return showDayView(
//                                   data: data,
//                                   calendarVM: calendarVM,
//                                   calendarAppointmentDetails:
//                                       calendarAppointmentDetails,
//                                   controller: controller);
//                             } else if (controller.view == CalendarView.month) {
//                               // debugPrint(calendarAppointmentDetails.bounds.height.toString());
//                               // Note:I only used the origin day view builder
//                               return Placeholder();
//                             } else {
//                               return const Center(child: Text('error occur'));
//                             }
//                             // return Center(child: Text(meetings.from.toString()));
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                   showActivityList(
//                     controller: controller,
//                     calendarVM: calendarVM,
//                     workspaceVM: workspaceVM,
//                   ),
//                 ]);
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
