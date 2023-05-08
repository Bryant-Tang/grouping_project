import 'package:flutter/material.dart';
import 'package:googleapis/bigquerydatatransfer/v1.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/model/data_model.dart';
import 'package:grouping_project/service/service_lib.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

//TODO: same day conpare is not ok for different month(should compare by int day)
class CalendarViewModel extends ChangeNotifier {
  late CalendarSource _activitySource;
  late List<EventModel> _events;
  late List<MissionModel> _missions;
  late Widget _activityListView;

  CalendarViewModel(WorkspaceDashBoardViewModel workspaceVM) {
    _events = workspaceVM.events;
    _missions = workspaceVM.missions;
  }

  CalendarSource get activitySource => _activitySource;
  Widget get activityListView => _activityListView;

  /// return the activity source for label type calendar
  getActivityByLabel() {
    //TODO:return labels for the group
    _activitySource = CalendarSource(
        (_events as List<BaseDataModel>) + (_missions as List<BaseDataModel>));
  }

  /// return the activity source for dots type calendar
  getActivityByDots() {
    Map<DateTime, List<String>> dayMap = {};
    List<BaseDataModel> oneForAday = [];
    debugPrint('at mission part');
    for (var element in _missions) {
      DateTime key = DateTime(
          element.deadline.year, element.deadline.month, element.deadline.day);
      if (!dayMap.containsKey(key)) {
        debugPrint('not contain key: $key');
        debugPrint('element title: ${element.title}');
        dayMap[key] = [];
        dayMap[key]!.add(element.ownerAccount.nickname);
        oneForAday.add(element);
      } else {
        if (!dayMap[key]!.contains(element.ownerAccount.nickname)) {
          dayMap[key]!.add(element.ownerAccount.nickname);
          oneForAday.add(element);
        }
      }
      // else {
      //   debugPrint('contain key: $key');
      // }
    }
    debugPrint('at event part');
    for (var element in _events) {
      DateTime startTime = DateTime(element.startTime.year,
          element.startTime.month, element.startTime.day);
      DateTime endTime = DateTime(
          element.endTime.year, element.endTime.month, element.endTime.day);
      DateTime currentDay =
          DateTime(startTime.year, startTime.month, startTime.day);
      debugPrint('currentDay: $currentDay');
      while ((currentDay.isBefore(endTime) ||
          currentDay.isAtSameMomentAs(endTime))) {
        if (!dayMap.containsKey(currentDay)) {
          debugPrint('not contain key: $currentDay');
          debugPrint('element title: ${element.title}');
          dayMap[currentDay] = [];
          dayMap[currentDay]!.add(element.ownerAccount.nickname);
          oneForAday.add(element);
        } else {
          if (!dayMap[currentDay]!.contains(element.ownerAccount.nickname)) {
            dayMap[currentDay]!.add(element.ownerAccount.nickname);
            oneForAday.add(element);
          }
        }
        //  else {
        //   debugPrint('contain key: $currentDay');
        // }

        currentDay = currentDay.add(const Duration(days: 1));
      }
    }
    _activitySource = CalendarSource(oneForAday);
  }

  /// onlu for day view in sfCalendar
  showDayView(
      {required BaseDataModel data,
      required BuildContext context,
      required CalendarAppointmentDetails calendarAppointmentDetails,
      required CalendarController controller}) {
    if (data.toString() == 'Instance of \'EventModel\'') {
      data = data as EventModel;
      return data.startTime.day == data.endTime.day
          ? Container(
              //TODO: when time range is very small => overflow occur
              padding: const EdgeInsets.all(5),
              width: calendarAppointmentDetails.bounds.width,
              height: calendarAppointmentDetails.bounds.height,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.title,
                      style: TextStyle(
                        fontSize:
                            (calendarAppointmentDetails.bounds.height * 0.25)
                                .clamp(1, 20),
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis),
                  Text(
                    data.introduction,
                    style: TextStyle(
                      fontSize: (calendarAppointmentDetails.bounds.height * 0.2)
                          .clamp(1, 20),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.only(left: 3),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12)),
              // TODO: VM
              child: Text(
                '${data.title} (${controller.displayDate!.day - data.startTime.day + 1}/${data.endTime.day - data.startTime.day + 1})'
                '  ${data.startTime.day == controller.displayDate!.day ? DateFormat('hh:mm a').format(data.startTime) : ''} ~ '
                '${data.endTime.day == controller.displayDate!.day ? DateFormat('hh:mm a').format(data.endTime) : ''}',
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            );
    } else {
      // TODO:check if the mission look right
      data = data as MissionModel;
      return Container(
        //TODO: when time range is very small => overflow occur
        padding: const EdgeInsets.all(5),
        width: calendarAppointmentDetails.bounds.width,
        height: calendarAppointmentDetails.bounds.height,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.title,
                style: TextStyle(
                  fontSize: (calendarAppointmentDetails.bounds.height * 0.25)
                      .clamp(1, 20),
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis),
            Text(
              data.introduction,
              style: TextStyle(
                fontSize: (calendarAppointmentDetails.bounds.height * 0.2)
                    .clamp(1, 20),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }
  }

  showMonthDotView(
      {required BaseDataModel data,
      required BuildContext context,
      CalendarAppointmentDetails? calendarAppointmentDetails,
      required CalendarController controller}) {
    double height = calendarAppointmentDetails == null
        ? 50
        : calendarAppointmentDetails.bounds.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(children: [
        Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      // TODO: VM
                      data.toString() == 'Instance of \'EventModel\''
                          // Is event
                          ? ((data as EventModel).startTime.day ==
                                  DateTime.now().day
                              ? DateFormat('hh:mm a')
                                  .format((data as EventModel).startTime)
                              : (data as EventModel).startTime.day ==
                                      controller.selectedDate!.day
                                  ? DateFormat('hh:mm a')
                                      .format((data as EventModel).startTime)
                                  : '00:00 AM')
                          // Is mission
                          : ((data as MissionModel)
                                      .deadline
                                      .copyWith()
                                      .add(const Duration(minutes: -15))
                                      .day ==
                                  DateTime.now().day
                              ? DateFormat('hh:mm a').format(
                                  (data as MissionModel)
                                      .deadline
                                      .copyWith()
                                      .add(const Duration(minutes: -15)))
                              : (data as MissionModel)
                                          .deadline
                                          .copyWith()
                                          .add(const Duration(minutes: -15))
                                          .day ==
                                      controller.selectedDate!.day
                                  ? DateFormat('hh:mm a').format(
                                      (data as MissionModel)
                                          .deadline
                                          .copyWith()
                                          .add(const Duration(minutes: -15)))
                                  : '00:00 AM'),
                      style: TextStyle(
                          fontSize: height * 0.2, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      // TODO: VM
                      data.toString() == 'Instance of \'EventModel\''
                          ? ((data as EventModel).endTime.day ==
                                  DateTime.now().day
                              ? DateFormat('hh:mm a')
                                  .format((data as EventModel).endTime)
                              : (data as EventModel).endTime.day ==
                                      controller.selectedDate!.day
                                  ? DateFormat('hh:mm a')
                                      .format((data as EventModel).endTime)
                                  : '23:59 PM')
                          // Is mission
                          : ((data as MissionModel).deadline.day ==
                                  DateTime.now().day
                              ? DateFormat('hh:mm a')
                                  .format((data as MissionModel).deadline)
                              : (data as MissionModel).deadline.day ==
                                      controller.selectedDate!.day
                                  ? DateFormat('hh:mm a')
                                      .format((data as MissionModel).deadline)
                                  : '00:00 AM'),
                      style: TextStyle(
                          fontSize: height * 0.2, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                data.toString() == 'Instance of \'EventModel\''
                    ? ((data as EventModel).startTime.day ==
                            (data as EventModel).endTime.day
                        ? const SizedBox()
                        : Text(
                            '(${controller.selectedDate!.day - (data as EventModel).startTime.day + 1}/${(data as EventModel).endTime.day - (data as EventModel).startTime.day + 1})',
                            style: TextStyle(
                                fontSize: height * 0.2,
                                fontWeight: FontWeight.bold),
                          ))
                    : const SizedBox()
              ],
            )),
        Expanded(
            flex: 1,
            child: VerticalDivider(
              color: Theme.of(context).colorScheme.primaryContainer,
            )),
        Expanded(
            flex: 7,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        data.toString() == 'Instance of \'EventModel\''
                            ? (data as EventModel).title
                            : (data as MissionModel).title,
                        style: TextStyle(
                            fontSize: height * 0.25,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                    Text(
                      data.toString() == 'Instance of \'EventModel\''
                          ? (data as EventModel).introduction
                          : (data as MissionModel).introduction,
                      style: TextStyle(fontSize: height * 0.2),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                //TODO: mission state chip
              ],
            )),
      ]),
    );
  }

  showActivityList(
      {required CalendarController controller, required bool mounted}) {
    List<BaseDataModel> totalList = [];
    totalList.addAll(_events.cast<BaseDataModel>());
    totalList.addAll(_missions.cast<BaseDataModel>());
    debugPrint('totalList length before: ${totalList.length}');
    DateTime theDateStart = DateTime(controller.selectedDate!.year,
        controller.selectedDate!.month, controller.selectedDate!.day, 0, 0, 0);
    DateTime theDateEnd = DateTime(
        controller.selectedDate!.year,
        controller.selectedDate!.month,
        controller.selectedDate!.day,
        23,
        59,
        59);
    List<BaseDataModel> resultList = totalList.where((element) {
      if (element.toString() == 'Instance of \'EventModel\'') {
        element = element as EventModel;
        // debugPrint('theDateStart: $theDateStart');
        // debugPrint('element.title: ${element.title}');
        // debugPrint('element.startTime: ${element.startTime}');
        // debugPrint('element.endTime: ${element.endTime}');
        // debugPrint('theDateEnd: $theDateEnd\n');
        bool result = ((element.startTime.isBefore(theDateEnd) ||
                    element.startTime.isAtSameMomentAs(theDateEnd)) &&
                (element.endTime.isAfter(theDateStart)) ||
            element.endTime.isAtSameMomentAs(theDateStart));
        // debugPrint('${element.title} result: $result');
        return result;
      } else {
        element = element as MissionModel;
        // debugPrint('theDateStart: $theDateStart');
        // debugPrint('element.title: ${element.title}');
        // debugPrint('element.startTime: ${element.deadline}');
        // debugPrint('theDateEnd: $theDateEnd\n');
        bool result = DateTime(controller.selectedDate!.year,
                controller.selectedDate!.month, controller.selectedDate!.day) ==
            DateTime(element.deadline.year, element.deadline.month,
                element.deadline.day);
        // debugPrint('${element.title} result: $result');
        return result;
      }
    }).toList();
    _activityListView = Expanded(
        child: ListView.builder(
      itemCount: resultList.length,
      itemBuilder: (context, index) {
        debugPrint('totalList length after: ${resultList.length}');
        return Container(
          key: ValueKey(resultList[index]),
          child: showMonthDotView(
              data: resultList[index],
              context: context,
              controller: controller),
        );
      },
    ));
    if (mounted) {
      notifyListeners();
    }
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class CalendarSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  CalendarSource(List<BaseDataModel> source) {
    appointments = source;
  }
  @override
  DateTime getStartTime(int index) {
    return appointments?[index].toString() == 'Instance of \'EventModel\''
        ? (appointments?[index] as EventModel).startTime
        : (appointments?[index] as MissionModel)
            .deadline
            .copyWith()
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
