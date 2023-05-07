import 'package:flutter/material.dart';
import 'package:googleapis/apigeeregistry/v1.dart';
import 'package:grouping_project/VM/workspace/calendar_view_model.dart';
import 'package:grouping_project/View/workspace/workspace_view.dart';
import 'package:grouping_project/model/data_model.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/VM/workspace/workspace_dashboard_view_model.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/service/database_service.dart';
import 'package:meta/meta.dart';
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
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, workspaceVM, child) => Consumer<CalendarViewModel>(
          builder: (context, calendarVM, child) => Center(
                child: Padding(
                  // TODO: limit calendar height
                  padding: const EdgeInsets.only(bottom: 90),
                  child: SfCalendar(
                    view: CalendarView.month,
                    controller: controller,
                    dataSource: BaseDataModelSource(_getDataSource(workspaceVM,
                        controller.selectedDate ?? DateTime.now())),
                    todayHighlightColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    todayTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    initialSelectedDate: DateTime.now(),
                    // by default the month appointment display mode set as Indicator, we can
                    // change the display mode as appointment using the appointment display
                    // mode property
                    monthViewSettings: const MonthViewSettings(
                      // appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.indicator,
                      // 瑞弟: 顯示點點或 event 的 name(預設 false)
                      showAgenda: true,
                    ),
                    allowedViews: const [CalendarView.day, CalendarView.month],
                    // 瑞弟: this function can customize the view of event
                    appointmentBuilder: (context, calendarAppointmentDetails) {
                      // this is iterator
                      final BaseDataModel model =
                          calendarAppointmentDetails.appointments.first;
                      // the view of event
                      // 如果當前顯示是 day，切換顯示方式
                      if (controller.view == CalendarView.day) {
                        return Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  model.toString() ==
                                          'Instance of \'EventModel\''
                                      ? (model as EventModel).title
                                      : (model as MissionModel).title,
                                  style: TextStyle(
                                    fontSize: calendarAppointmentDetails
                                            .bounds.height *
                                        0.25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                model.toString() == 'Instance of \'EventModel\''
                                    ? (model as EventModel).introduction
                                    : (model as MissionModel).introduction,
                                style: TextStyle(
                                  fontSize:
                                      calendarAppointmentDetails.bounds.height *
                                          0.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                        // 如果當前顯示是 month，切換顯示方式
                      } else if (controller.view == CalendarView.month) {
                        return SimpleCardView(
                            model: model,
                            calendarAppointmentDetails:
                                calendarAppointmentDetails);
                      } else {
                        return const Center(child: Text('error occur'));
                      }
                      // return Center(child: Text(meetings.from.toString()));
                    },
                  ),
                ),
              )),
    );
  }

  // 預設會自動排序，所以不用管加入的 event startTime 順序
  List<BaseDataModel> _getDataSource(
      WorkspaceDashBoardViewModel workspaceVM, DateTime selectedDate) {
    final List<BaseDataModel> activity = <BaseDataModel>[];
    final DateTime today = DateTime.now();
    DateTime selectedDateStart =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0);
    DateTime selectedDateEnd = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 23, 59);
    // TODO: 跨日會爆開
    activity.addAll(workspaceVM.events
        // .where((element) {
        //   return ((selectedDateStart.isBefore(element.startTime) ||
        //           selectedDateStart.isAtSameMomentAs(element.startTime)) &&
        //       (selectedDateEnd.isAfter(element.endTime) ||
        //           selectedDateEnd.isAtSameMomentAs(element.endTime)));
        // })
        );
    activity.addAll(workspaceVM.missions
        // .where((element) {
        //   return ((selectedDateStart.isBefore(element.deadline) ||
        //           selectedDateStart.isAtSameMomentAs(element.deadline)) &&
        //       (selectedDateEnd.isAfter(element.deadline) ||
        //           selectedDateEnd.isAtSameMomentAs(element.deadline)));
        // })
        );
    return activity;
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class BaseDataModelSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  BaseDataModelSource(List<BaseDataModel> source) {
    appointments = source;
  }
  @override
  DateTime getStartTime(int index) {
    return appointments?[index].toString() == 'Instance of \'EventModel\''
        ? (appointments?[index] as EventModel).startTime
        : (appointments?[index] as MissionModel)
            .deadline
            .add(const Duration(minutes: -15));
  }

  @override
  DateTime getEndTime(int index) {
    return appointments?[index].toString() == 'Instance of \'EventModel\''
        ? (appointments?[index] as EventModel).endTime
        : (appointments?[index] as MissionModel).deadline;
  }

  @override
  String getSubject(int index) {
    return appointments?[index].toString() == 'Instance of \'EventModel\''
        ? (appointments?[index] as EventModel).title
        : (appointments?[index] as MissionModel).title;
  }

  @override
  Color getColor(int index) {
    return appointments?[index].toString() == 'Instance of \'EventModel\''
        ? Color((appointments?[index] as EventModel).ownerAccount.color)
        : Color((appointments?[index] as MissionModel).ownerAccount.color);
  }
}

class SimpleCardView extends StatelessWidget {
  late BaseDataModel model;
  late CalendarAppointmentDetails calendarAppointmentDetails;
  SimpleCardView(
      {required this.model, required this.calendarAppointmentDetails});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(children: [
        Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  model.toString() == 'Instance of \'EventModel\''
                      ? DateFormat('hh:mm a')
                          .format((model as EventModel).startTime)
                      : DateFormat('hh:mm a').format((model as MissionModel)
                          .deadline
                          .add(Duration(minutes: -15))),
                  style: TextStyle(
                      fontSize: calendarAppointmentDetails.bounds.height * 0.2),
                ),
                Text(
                  model.toString() == 'Instance of \'EventModel\''
                      ? DateFormat('hh:mm a')
                          .format((model as EventModel).endTime)
                      : DateFormat('hh:mm a')
                          .format((model as MissionModel).deadline),
                  style: TextStyle(
                      fontSize: calendarAppointmentDetails.bounds.height * 0.2),
                ),
              ],
            )),
        Expanded(
            flex: 2,
            child: VerticalDivider(
              color: Theme.of(context).colorScheme.primaryContainer,
            )),
        Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    model.toString() == 'Instance of \'EventModel\''
                        ? (model as EventModel).title
                        : (model as MissionModel).title,
                    style: TextStyle(
                        fontSize:
                            calendarAppointmentDetails.bounds.height * 0.25,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
                Text(
                  model.toString() == 'Instance of \'EventModel\''
                      ? (model as EventModel).introduction
                      : (model as MissionModel).introduction,
                  style: TextStyle(
                      fontSize: calendarAppointmentDetails.bounds.height * 0.2),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )),
      ]),
    );
  }
}
