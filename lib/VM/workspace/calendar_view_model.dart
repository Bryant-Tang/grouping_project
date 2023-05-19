import 'package:flutter/material.dart';
import 'package:grouping_project/VM/mission_setting_view_model.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/View/EditableCard/event_card_view.dart';
import 'package:grouping_project/View/EditableCard/mission_card_view.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/model/data_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarViewModel extends ChangeNotifier {
  late CalendarSource _activitySource;
  late List<EventModel> _events;
  late List<MissionModel> _missions;
  late DateTime _selectedDate;
  Widget? _activityListView;
  late bool isGroup;
  List<BaseDataModel> activityAtTheDay = [];

  List<MissionStateModel> inProgress = [];
  List<MissionStateModel> pending = [];
  List<MissionStateModel> close = [];
  Map<MissionStage, Color> stageColorMap = {
    MissionStage.progress: Colors.blue,
    MissionStage.pending: Colors.red,
    MissionStage.close: Colors.green,
    // state the color 應該要在後端上面
  };

  CalendarViewModel(
      {required List<EventModel> events,
      required List<MissionModel> missions,
      required DateTime defaultSelectedDate,
      isItGroup = false}) {
    _events = events;
    _missions = missions;
    _selectedDate = defaultSelectedDate.copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    isGroup = isItGroup;
  }

  CalendarSource get activitySource => _activitySource;
  Widget get activityListView => _activityListView ?? const SizedBox();
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime value) => _selectedDate = value;

  /// need to call showActivity after this
  changeView({
    required CalendarController controller,
    bool toMontView = false,
    bool needRefresh = true,
  }) {
    if (!toMontView) {
      controller.view = CalendarView.day;
      if (!isGroup) {
        getActivityByLabel();
      }
      _activitySource.getVisibleAppointments(DateTime(2000), '');
      // TODO: show activity list
    } else {
      controller.view = CalendarView.month;
      if (!isGroup) {
        getActivityByDots();
      } else {
        _activitySource.getVisibleAppointments(DateTime(2000), '');
      }
    }
    if (needRefresh) {
      notifyListeners();
    }
  }

  /// When change date, need to call this
  setDate(CalendarController controller) {
    _selectedDate = controller.selectedDate!;
    activityAtTheDay = [];

    activityAtTheDay.addAll(_events.cast<BaseDataModel>());
    activityAtTheDay.addAll(_missions.cast<BaseDataModel>());

    DateTime theDateStart = DateTime(controller.selectedDate!.year,
        controller.selectedDate!.month, controller.selectedDate!.day, 0, 0, 0);
    DateTime theDateEnd = DateTime(
        controller.selectedDate!.year,
        controller.selectedDate!.month,
        controller.selectedDate!.day,
        23,
        59,
        59);

    activityAtTheDay = activityAtTheDay.where((element) {
      if (element is EventModel) {
        // element = element as EventModel;
        bool result = ((element.startTime.isBefore(theDateEnd) ||
                    element.startTime.isAtSameMomentAs(theDateEnd)) &&
                (element.endTime.isAfter(theDateStart))
            //  || element.endTime.isAtSameMomentAs(theDateStart)
            );
        return result;
      } else {
        element = element as MissionModel;
        bool result = element.deadline.hour == 0 && element.deadline.minute == 0
            ? DateTime(
                    controller.selectedDate!.year,
                    controller.selectedDate!.month,
                    controller.selectedDate!.day) ==
                DateTime(element.deadline.year, element.deadline.month,
                        element.deadline.day)
                    .add(const Duration(days: -1))
            : DateTime(
                    controller.selectedDate!.year,
                    controller.selectedDate!.month,
                    controller.selectedDate!.day) ==
                DateTime(element.deadline.year, element.deadline.month,
                    element.deadline.day);
        return result;
      }
    }).toList();
  }

  /// return the activity source for label type calendar
  getActivityByLabel() {
    //TODO:return labels for the group
    _activitySource = CalendarSource(
        _events.cast<BaseDataModel>() + _missions.cast<BaseDataModel>());
    _activitySource.getVisibleAppointments(DateTime(2000), '');
  }

  /// return the activity source for dots type calendar
  /// Which is one dot a most in a day
  getActivityByDots() {
    Map<DateTime, List<String>> dayMap = {};
    List<BaseDataModel> oneForAday = [];
    DateTime key;
    for (var element in _missions) {
      element.deadline.hour == 0 && element.deadline.minute == 0
          ? key = DateTime(element.deadline.year, element.deadline.month,
                  element.deadline.day, 12)
              .add(const Duration(days: -1))
          : key = DateTime(element.deadline.year, element.deadline.month,
              element.deadline.day, 12);
      if (!dayMap.containsKey(key)) {
        dayMap[key] = [];
        dayMap[key]!.add(element.ownerAccount.nickname);
        MissionModel toAdd = MissionModel(
          deadline: key.copyWith(hour: 12),
        );
        toAdd.setOwner(ownerAccount: element.ownerAccount);
        oneForAday.add(toAdd);
      } else {
        if (!dayMap[key]!.contains(element.ownerAccount.nickname)) {
          dayMap[key]!.add(element.ownerAccount.nickname);
          MissionModel toAdd = MissionModel(
            deadline: key.copyWith(hour: 12),
          );
          toAdd.setOwner(ownerAccount: element.ownerAccount);
          oneForAday.add(toAdd);
        }
      }
    }
    for (var element in _events) {
      DateTime startTime = DateTime(element.startTime.year,
          element.startTime.month, element.startTime.day, 12);
      DateTime endTime = DateTime(
          element.endTime.year, element.endTime.month, element.endTime.day, 12);
      DateTime currentDay = startTime.copyWith();
      while ((currentDay.isBefore(endTime) ||
          currentDay.isAtSameMomentAs(endTime))) {
        if (!dayMap.containsKey(currentDay)) {
          dayMap[currentDay] = [];
          dayMap[currentDay]!.add(element.ownerAccount.nickname);
          MissionModel toAdd = MissionModel(
            deadline: currentDay.copyWith(hour: 12),
          );
          toAdd.setOwner(ownerAccount: element.ownerAccount);
          oneForAday.add(toAdd);
        } else if (!dayMap[currentDay]!
            .contains(element.ownerAccount.nickname)) {
          dayMap[currentDay]!.add(element.ownerAccount.nickname);
          MissionModel toAdd = MissionModel(
            deadline: currentDay.copyWith(hour: 12),
          );
          toAdd.setOwner(ownerAccount: element.ownerAccount);
          oneForAday.add(toAdd);
        }

        currentDay = currentDay.add(const Duration(days: 1));
      }
    }
    _activitySource = CalendarSource(oneForAday);
  }

  /// only for day view in sfCalendar
  showDayView(
      {required BaseDataModel data,
      required BuildContext context,
      required CalendarAppointmentDetails calendarAppointmentDetails,
      required CalendarController controller}) {
    if (data is EventModel) {
      data = data as EventModel;
      return data.startTime.copyWith(hour: 0, minute: 0) ==
              data.endTime.copyWith(hour: 0, minute: 0)
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
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(data.ownerAccount.color))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.title,
                      style: TextStyle(
                        fontSize:
                            (calendarAppointmentDetails.bounds.height * 0.25)
                                .clamp(1, 20),
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.clip),
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
            ),
            Flexible(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                    border: Border.all(color: stageColorMap[data.state.stage]!),
                    borderRadius: BorderRadius.circular(10)
                    // elevation: 4,
                    ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                        backgroundColor: stageColorMap[data.state.stage]!,
                        radius: 5),
                    const SizedBox(width: 5),
                    Text(
                      data.state.stateName,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: stageColorMap[data.state.stage]!),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  /// For seperating the agenda view template, only call it by the show activity func.
  showSingleAgendaViewForDot(
      {required BaseDataModel data,
      required BuildContext context,
      CalendarAppointmentDetails? calendarAppointmentDetails,
      required CalendarController controller}) {
    double height = calendarAppointmentDetails == null
        ? 50
        : calendarAppointmentDetails.bounds.height;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 7,
      ),
      child: Row(children: [
        // Expanded(
        // flex: 3,
        // child:
        // TODO: delete if not used
        Expanded(
          flex: 2,
          child: data is EventModel
              // is Event
              ? data.startTime.day == data.endTime.day
                  ? Column(children: [
                      Text(DateFormat('hh:mm a').format(data.startTime),
                          style: TextStyle(
                              fontSize: height * 0.2,
                              fontWeight: FontWeight.bold)),
                      Text(DateFormat('hh:mm a').format(data.endTime),
                          style: TextStyle(
                              fontSize: height * 0.2,
                              fontWeight: FontWeight.bold))
                    ])
                  // is all-day of event?
                  : controller.selectedDate!.day != data.startTime.day &&
                          controller.selectedDate!.day != data.endTime.day
                      ? Center(
                          child: Text('All-Day',
                              style: TextStyle(
                                  fontSize: height * 0.2,
                                  fontWeight: FontWeight.bold)),
                        )
                      : Column(
                          children:
                              controller.selectedDate!.day == data.startTime.day
                                  ? [
                                      Text(
                                          DateFormat('hh:mm a')
                                              .format(data.startTime),
                                          style: TextStyle(
                                              fontSize: height * 0.2,
                                              fontWeight: FontWeight.bold)),
                                      Text('Start',
                                          style: TextStyle(
                                              fontSize: height * 0.2,
                                              fontWeight: FontWeight.bold))
                                    ]
                                  : [
                                      Text(
                                          DateFormat('hh:mm a')
                                              .format(data.startTime),
                                          style: TextStyle(
                                              fontSize: height * 0.2,
                                              fontWeight: FontWeight.bold)),
                                      Text('End',
                                          style: TextStyle(
                                              fontSize: height * 0.2,
                                              fontWeight: FontWeight.bold))
                                    ],
                        )
              // is Mission
              : Column(
                  children: [
                    Text('Deadline',
                        style: TextStyle(
                            fontSize: height * 0.2,
                            fontWeight: FontWeight.bold)),
                    Text(
                        DateFormat('hh:mm a')
                            .format((data as MissionModel).deadline),
                        style: TextStyle(
                            fontSize: height * 0.2,
                            fontWeight: FontWeight.bold))
                  ],
                ),
        ),
        // ),
        Expanded(
          flex: 1,
          child: SizedBox(
              height: height,
              child: VerticalDivider(
                thickness: 2,
                color: data is EventModel
                    // color: data.toString() == 'Instance of \'EventModel\''
                    ? Color(data.ownerAccount.color)
                    : Color((data as MissionModel).ownerAccount.color),
              )),
        ),
        Expanded(
            flex: 10,
            child: data is EventModel
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.title,
                          style: TextStyle(
                              fontSize: height * 0.25,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis),
                      Text(
                        data.introduction,
                        style: TextStyle(fontSize: height * 0.2),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text((data as MissionModel).title,
                                style: TextStyle(
                                    fontSize: height * 0.25,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis),
                            Text(
                              data.introduction,
                              style: TextStyle(fontSize: height * 0.2),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: stageColorMap[data.state.stage]!),
                              borderRadius: BorderRadius.circular(10)
                              // elevation: 4,
                              ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                  backgroundColor:
                                      stageColorMap[data.state.stage]!,
                                  radius: 5),
                              const SizedBox(width: 5),
                              Text(
                                data.state.stateName,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: stageColorMap[data.state.stage]!),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
      ]),
    );
  }

  showSingleAgendaViewForLabel(
      {required BaseDataModel data,
      required BuildContext context,
      CalendarAppointmentDetails? calendarAppointmentDetails,
      required CalendarController controller}) {
    if (data is EventModel) {
      return Container(
        decoration: BoxDecoration(
          color: Color(data.ownerAccount.color),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          child: Text(
            data.title,
            softWrap: true,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
          ),
        ),
      );
    } else if (data is MissionModel) {
      return Container(
        decoration: BoxDecoration(
          color: Color(data.ownerAccount.color),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          border: Border.all(color: Color(data.ownerAccount.color), width: 2.0),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          child: Text(
            data.title,
            softWrap: true,
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(fontWeight: FontWeight.w500, fontSize: 10),
          ),
        ),
      );
    }
  }

  Future<DateTime?> popupDatePicker(
      BuildContext context, CalendarController controller) {
    DateTime? selectedDate = DateTime.now();
    return showDialog<DateTime>(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 400,
            // width: 200,
            child: SfDateRangePicker(
              initialSelectedDate: DateTime.now(),
              selectionMode: DateRangePickerSelectionMode.single,
              showActionButtons: true,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                controller.selectedDate = args.value;
                controller.displayDate = args.value;
              },
              onCancel: () {
                Navigator.pop(context);
              },
              onSubmit: (p0) {
                Navigator.pop(context, selectedDate);
              },
            ),
          ),
        );
      },
    );
  }

  showActivityList(
      {required CalendarController controller,
      bool needRefresh = true,
      required WorkspaceDashBoardViewModel workspaceVM}) {
    _activityListView = null;
    if (controller.view == CalendarView.day) {
      if (needRefresh) {
        notifyListeners();
      }
    } else {
      activityAtTheDay.sort((a, b) {
        if (a is EventModel && b is EventModel) {
          return a.startTime.compareTo(b.startTime);
        } else if (a is EventModel && b is MissionModel) {
          return 1;
        } else if (a is MissionModel && b is EventModel) {
          return -1;
        } else if (a is MissionModel && b is MissionModel) {
          return a.deadline.compareTo(b.deadline);
        } else {
          return 0;
        }
      });
      _activityListView = Expanded(
        flex: 2,
        child: ListView.builder(
          itemCount: activityAtTheDay.length,
          itemBuilder: (context, index) {
            if (activityAtTheDay.isNotEmpty &&
                activityAtTheDay.length > index) {
              return InkWell(
                key: activityAtTheDay.length == 0
                    ? null
                    : ValueKey(activityAtTheDay[index]),
                onTap: () {
                  activityOnTap(
                      data: activityAtTheDay[index],
                      context: context,
                      workspaceVM: workspaceVM);
                },
                child: showSingleAgendaViewForDot(
                    data: activityAtTheDay[index],
                    context: context,
                    controller: controller),
              );
            }
          },
        ),
      );
    }
    if (needRefresh) {
      notifyListeners();
    }
  }
}

activityOnTap(
    {required BaseDataModel data,
    required BuildContext context,
    required WorkspaceDashBoardViewModel workspaceVM}) {
  if (data is EventModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<WorkspaceDashBoardViewModel>.value(
                value: workspaceVM),
            ChangeNotifierProvider<EventSettingViewModel>(
              create: (context) => EventSettingViewModel()
                ..initializeDisplayEvent(
                  model: data,
                  user: context
                      .read<WorkspaceDashBoardViewModel>()
                      .personalprofileData,
                ),
            )
          ],
          child: const EventEditCardView(),
        ),
      ),
    );
  } else if (data is MissionModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<WorkspaceDashBoardViewModel>.value(
                value: workspaceVM),
            ChangeNotifierProvider<MissionSettingViewModel>(
              create: (context) => MissionSettingViewModel()
                ..initializeDisplayMission(
                  model: data,
                  user: context
                      .read<WorkspaceDashBoardViewModel>()
                      .personalprofileData,
                ),
            )
          ],
          child: const MissionEditCardView(),
        ),
      ),
    );
  } else {
    debugPrint('You seeing this mean there\'s a bug in the type');
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
  List<Appointment> getVisibleAppointments(
      DateTime startDate, String calendarTimeZone,
      [DateTime? endDate]) {
    // TODO: implement getVisibleAppointments
    List<Appointment> result = super.getVisibleAppointments(
        startDate, calendarTimeZone, endDate ?? DateTime(2030));

    return result;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments?[index] is EventModel
        ? (appointments?[index] as EventModel).startTime.hour == 0 &&
                (appointments?[index] as EventModel).startTime.minute == 0
            ? (appointments?[index] as EventModel)
                .startTime
                .copyWith(hour: 0, minute: 1)
            : (appointments?[index] as EventModel).startTime
        : (appointments?[index] as MissionModel)
                    .deadline
                    .copyWith()
                    .add(const Duration(hours: -1))
                    .day !=
                (appointments?[index] as MissionModel).deadline.copyWith().day
            ? (appointments?[index] as MissionModel)
                .deadline
                .copyWith(minute: 1)
            : (appointments?[index] as MissionModel)
                .deadline
                .copyWith()
                .add(const Duration(hours: -1));
  }

  @override
  DateTime getEndTime(int index) {
    return appointments?[index] is EventModel
        ? (appointments?[index] as EventModel).endTime.hour == 0 &&
                (appointments?[index] as EventModel).endTime.minute == 0
            ? (appointments?[index] as EventModel)
                .endTime
                .copyWith(hour: 23, minute: 59)
                .add(const Duration(days: -1))
            : (appointments?[index] as EventModel).endTime
        : (appointments?[index] as MissionModel).deadline.hour == 0 &&
                (appointments?[index] as MissionModel).deadline.minute == 0
            ? (appointments?[index] as MissionModel)
                .deadline
                .copyWith(hour: 23, minute: 59)
                .add(const Duration(days: -1))
            : (appointments?[index] as MissionModel).deadline.copyWith();
  }

  @override
  String getSubject(int index) {
    return appointments?[index] is EventModel
        ? (appointments?[index] as EventModel).title
        : (appointments?[index] as MissionModel).title;
  }

  @override
  Color getColor(int index) {
    return appointments?[index] is EventModel
        ? Color((appointments?[index] as EventModel).ownerAccount.color)
        : Color((appointments?[index] as MissionModel).ownerAccount.color);
  }
}
