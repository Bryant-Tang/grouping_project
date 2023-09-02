import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/workspace/EditableCard/event_card_view.dart';
import 'package:grouping_project/View/app/workspace/EditableCard/mission_card_view.dart';
import 'package:grouping_project/ViewModel/workspace/workspace_view_model_lib.dart';
import 'package:grouping_project/model/workspace/workspace_model_lib.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarViewModel extends ChangeNotifier {
  late CalendarSource _activitySource;
  late List<EventModel> _events;
  late List<MissionModel> _missions;
  late DateTime _lastSelectedDate;
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

    _lastSelectedDate = defaultSelectedDate.copyWith();

    _lastSelectedDate = DateTime(_lastSelectedDate.year,
        _lastSelectedDate.month, _lastSelectedDate.day, 0, 0, 0);

    isGroup = isItGroup;
  }

  CalendarSource get activitySource => _activitySource;
  DateTime get lastSelectedDate => _lastSelectedDate;
  set selectedDate(DateTime value) => _lastSelectedDate = value;

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
    _lastSelectedDate = controller.selectedDate!;
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
    notifyListeners();
  }

  /// return the activity source for label type calendar
  getActivityByLabel() {
    _activitySource = CalendarSource(
        _events.cast<BaseDataModel>() + _missions.cast<BaseDataModel>());
    _activitySource.getVisibleAppointments(DateTime(2000), '');
    notifyListeners();
  }

  /// return the activity source for dots type calendar
  /// Which is one dot a most in a day
  getActivityByDots() {
    Map<DateTime, List<String>> dayMap = {};
    List<BaseDataModel> oneForAday = [];
    DateTime keyToMapDots;

    for (var element in _missions) {
      element.deadline.hour == 0 && element.deadline.minute == 0
          ? keyToMapDots = DateTime(element.deadline.year,
                  element.deadline.month, element.deadline.day, 12)
              .add(const Duration(days: -1))
          : keyToMapDots = DateTime(element.deadline.year,
              element.deadline.month, element.deadline.day, 12);

      if (!dayMap.containsKey(keyToMapDots)) {
        dayMap[keyToMapDots] = [];
        dayMap[keyToMapDots]!.add(element.ownerAccount.nickname);

        MissionModel toAdd = MissionModel(
          deadline: keyToMapDots.copyWith(hour: 12),
        );
        toAdd.setOwner(ownerAccount: element.ownerAccount);

        oneForAday.add(toAdd);
      } else {
        if (!dayMap[keyToMapDots]!.contains(element.ownerAccount.nickname)) {
          dayMap[keyToMapDots]!.add(element.ownerAccount.nickname);
          MissionModel toAdd = MissionModel(
            deadline: keyToMapDots.copyWith(hour: 12),
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
    notifyListeners();
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
