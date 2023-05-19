import 'package:flutter/material.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/VM/workspace/calendar_view_model.dart';
import 'package:grouping_project/model/data_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({super.key});

  @override
  State<CalendarViewPage> createState() => CalendarViewPageState();
}

class CalendarViewPageState extends State<CalendarViewPage> {
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
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) =>
            Consumer<WorkspaceDashBoardViewModel>(
          builder: (context, workspaceVM, child) =>
              ChangeNotifierProvider<CalendarViewModel>(
            create: (context) => CalendarViewModel(workspaceVM),
            child: Consumer<CalendarViewModel>(
              builder: (context, calendarVM, child) {
                calendarVM.getActivityByDots();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  calendarVM.showActivityList(
                      controller: controller, mounted: false);
                });
                return Column(children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: SfCalendar(
                        view: CalendarView.month,
                        controller: controller,
                        dataSource: calendarVM.activitySource,
                        todayHighlightColor:
                            Theme.of(context).colorScheme.primary,
                        todayTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        firstDayOfWeek: 1,
                        initialSelectedDate: DateTime.now(),
                        // by default the month appointment display mode set as Indicator, we can
                        // change the display mode as appointment using the appointment display
                        // mode property
                        onTap: (calendarTapDetails) {
                          if (calendarTapDetails.targetElement ==
                              CalendarElement.header) {
                            calendarVM.popupDatePicker(context, controller);
                          }
                          controller.view = calendarVM.changeView(
                              controller: controller,
                              calendarTapDetails: calendarTapDetails,
                              mounted: mounted);
                        },
                        onSelectionChanged: (calendarSelectionDetails) {
                          if ((calendarSelectionDetails.date != null) &&
                              (calendarSelectionDetails.date !=
                                  calendarVM.selectedDate)) {
                            calendarVM.selectedDate =
                                calendarSelectionDetails.date ??
                                    calendarVM.selectedDate;
                            calendarVM.showActivityList(
                                controller: controller, mounted: mounted);
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
                              MonthAppointmentDisplayMode.indicator,
                          // 瑞弟: 顯示點點或 event 的 name(預設 false)
                        ),
                        // 瑞弟: this function can customize the view of event
                        appointmentBuilder:
                            (context, calendarAppointmentDetails) {
                          // this is iterator
                          final BaseDataModel data =
                              calendarAppointmentDetails.appointments.first;
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
                            return calendarVM.showMonthDotAgendaView(
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
                  calendarVM.activityListView,
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
