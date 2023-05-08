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
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) =>
          Consumer<WorkspaceDashBoardViewModel>(
        builder: (context, workspaceVM, child) =>
            ChangeNotifierProvider<CalendarViewModel>(
          create: (context) => CalendarViewModel(workspaceVM),
          child: Consumer<CalendarViewModel>(
            builder: (context, calendarVM, child) {
              if (workspaceVM.isPersonalAccount) {
                calendarVM.getActivityByDots();
                calendarVM.showActivityList(
                    controller: controller, mounted: mounted);
              } else {
                calendarVM.getActivityByLabel();
              }
              return Column(children: [
                Center(
                  child: Padding(
                    // TODO: limit calendar height
                    padding: const EdgeInsets.only(bottom: 90),
                    child: SfCalendar(
                      view: CalendarView.month,
                      controller: controller,
                      dataSource: calendarVM.activitySource,
                      todayHighlightColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      todayTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      initialSelectedDate: DateTime.now(),
                      // by default the month appointment display mode set as Indicator, we can
                      // change the display mode as appointment using the appointment display
                      // mode property
                      onTap: (calendarTapDetails) {
                        calendarVM.showActivityList(
                            controller: controller, mounted: mounted);
                      },
                      monthViewSettings: const MonthViewSettings(
                        // appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.indicator,
                        // 瑞弟: 顯示點點或 event 的 name(預設 false)
                      ),
                      allowedViews: const [
                        CalendarView.day,
                        CalendarView.month
                      ],
                      headerHeight: 50,
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
                          return calendarVM.showMonthDotView(
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
    );
  }
}
