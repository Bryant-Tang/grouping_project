import 'package:flutter/material.dart';
import 'package:grouping_project/VM/mission_setting_view_model.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/VM/workspace/calendar_view_model.dart';
import 'package:grouping_project/View/EditableCard/event_card_view.dart';
import 'package:grouping_project/View/EditableCard/mission_card_view.dart';
import 'package:grouping_project/model/data_model.dart';
import 'package:grouping_project/model/editable_model.dart';
import 'package:grouping_project/model/event_model.dart';
import 'package:grouping_project/model/mission_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class CalendarGroupViewPage extends StatefulWidget {
  const CalendarGroupViewPage({super.key});

  @override
  State<CalendarGroupViewPage> createState() => _CalendarGroupViewPageState();
}

class _CalendarGroupViewPageState extends State<CalendarGroupViewPage> {
  CalendarController controller = CalendarController();

  @override
  void initState() {
    super.initState();
    controller.view = CalendarView.month;
    controller.displayDate = DateTime.now();
    controller.selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IgnorePointer(
        //Try to stop taps until build
        ignoring: !mounted,
        child: Consumer<WorkspaceDashBoardViewModel>(
          builder: (context, workspaceVM, child) =>
              ChangeNotifierProvider<CalendarViewModel>(
            create: (context) => CalendarViewModel(
                events: workspaceVM.events,
                missions: workspaceVM.missions,
                defaultSelectedDate: DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day),
                isItGroup: true),
            child: Consumer<CalendarViewModel>(
              builder: (context, calendarVM, child) {
                calendarVM.getActivityByLabel();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  calendarVM.showActivityList(
                      controller: controller,
                      needRefresh: false,
                      workspaceVM: workspaceVM);
                });
                debugPrint('Called build()');
                return Flex(direction: Axis.horizontal, children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child:
                          // TODO: limit calendar height
                          SfCalendar(
                        key: ValueKey(controller.view),
                        view: controller.view!,
                        controller: controller,
                        dataSource: calendarVM.activitySource,
                        todayHighlightColor:
                            Theme.of(context).colorScheme.primary,
                        todayTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        initialSelectedDate: DateTime.now(),
                        // by default the month appointment display mode set as Indicator, we can
                        // change the display mode as appointment using the appointment display
                        // mode property
                        onTap: (calendarTapDetails) {
                          debugPrint(
                              'onTap: ${calendarTapDetails.targetElement}');
                          if (calendarTapDetails.targetElement ==
                              CalendarElement.header) {
                            calendarVM.popupDatePicker(context, controller);
                          }
                          if (((calendarTapDetails.targetElement ==
                                      CalendarElement.calendarCell) &&
                                  (calendarTapDetails.date ==
                                      calendarVM.selectedDate)) ||
                              (calendarTapDetails.targetElement ==
                                  CalendarElement.viewHeader)) {
                            debugPrint('Group onTap');
                            controller.view = calendarVM.changeView(
                              controller: controller,
                              toMontView: controller.view != CalendarView.month,
                            );
                          } else if (calendarTapDetails.targetElement ==
                              CalendarElement.appointment) {
                            debugPrint(
                                'Say my name: ${calendarTapDetails.appointments![0] is EventModel ? (calendarTapDetails.appointments![0] as EventModel).title : (calendarTapDetails.appointments![0] as MissionModel).title}');
                            if (calendarTapDetails.appointments![0]
                                is EventModel) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider<
                                              WorkspaceDashBoardViewModel>.value(
                                          value: workspaceVM),
                                      ChangeNotifierProvider<
                                          EventSettingViewModel>(
                                        create: (context) =>
                                            EventSettingViewModel()
                                              ..initializeDisplayEvent(
                                                model: calendarTapDetails
                                                    .appointments![0],
                                                user: context
                                                    .read<
                                                        WorkspaceDashBoardViewModel>()
                                                    .personalprofileData,
                                              ),
                                      )
                                    ],
                                    child: const EventEditCardView(),
                                  ),
                                ),
                              );
                            } else if (calendarTapDetails.appointments![0]
                                is MissionModel) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider<
                                              WorkspaceDashBoardViewModel>.value(
                                          value: workspaceVM),
                                      ChangeNotifierProvider<
                                              MissionSettingViewModel>(
                                          create: (context) =>
                                              MissionSettingViewModel()
                                                ..initializeDisplayMission(
                                                    model: calendarTapDetails
                                                        .appointments![0],
                                                    user: context
                                                        .read<
                                                            WorkspaceDashBoardViewModel>()
                                                        .personalprofileData))
                                    ],
                                    child: const MissionEditCardView(),
                                  ),
                                ),
                              );
                            }
                          }
                          if (mounted) {
                            calendarVM.showActivityList(
                                controller: controller,
                                workspaceVM: workspaceVM);
                          }
                        },
                        onSelectionChanged: (calendarSelectionDetails) {
                          if ((calendarSelectionDetails.date != null) &&
                              (calendarSelectionDetails.date !=
                                  calendarVM.selectedDate)) {
                            calendarVM.selectedDate =
                                calendarSelectionDetails.date ??
                                    calendarVM.selectedDate;
                            calendarVM.setDate(controller);
                            if (mounted) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                calendarVM.showActivityList(
                                    controller: controller,
                                    workspaceVM: workspaceVM);
                              });
                            }
                          }
                        },
                        onViewChanged: (viewChangedDetails) {
                          controller.view == CalendarView.month
                              ? calendarVM.getActivityByDots()
                              : calendarVM.getActivityByLabel();
                          if (mounted) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              calendarVM.showActivityList(
                                  controller: controller,
                                  workspaceVM: workspaceVM);
                            });
                          }
                        },
                        // allowViewNavigation: true,
                        headerStyle: CalendarHeaderStyle(
                          textStyle:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.center,
                          backgroundColor: Colors.transparent,
                        ),
                        monthViewSettings: const MonthViewSettings(
                          // appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.appointment,
                          // 瑞弟: 顯示點點或 event 的 name(預設 false)
                        ),
                        headerHeight: 50,
                        // 瑞弟: this function can customize the view of event
                        appointmentBuilder:
                            (context, calendarAppointmentDetails) {
                          // this is iterator
                          final BaseDataModel data =
                              calendarAppointmentDetails.appointments.first;
                          // debugPrint((data as MissionModel).title);
                          // the view of event
                          // 如果當前顯示是 day，切換顯示方式
                          if (controller.view == CalendarView.day) {
                            // 如果當前顯示是 month，切換顯示方式
                            // TODO:place day view
                            return calendarVM.showDayView(
                                data: data,
                                context: context,
                                calendarAppointmentDetails:
                                    calendarAppointmentDetails,
                                controller: controller);
                          } else if (controller.view == CalendarView.month) {
                            // debugPrint(calendarAppointmentDetails.bounds.height.toString());
                            return calendarVM.showSingleAgendaViewForLabel(
                                data: data,
                                context: context,
                                calendarAppointmentDetails:
                                    calendarAppointmentDetails,
                                controller: controller);
                          } else {
                            return const Center(child: Text('error occur'));
                          }
                          // return Center(child: Text(meetings.from.toString()));
                        },
                      ),
                    ),
                  ),
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
