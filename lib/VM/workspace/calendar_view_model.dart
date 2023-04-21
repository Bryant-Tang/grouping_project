import 'package:flutter/material.dart';
import 'package:grouping_project/VM/workspace/workspace_dashboard_view_model.dart';
import 'package:grouping_project/model/data_model.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_event_page.dart';
import 'package:grouping_project/service/service_lib.dart';

class CalendarViewModel extends ChangeNotifier {
  final DatabaseService databaseService =
      DatabaseService(ownerUid: AuthService().getUid());
  bool isLoaded = true;
  bool isMapping = true;

  List<EventModel> events = [];
  List<MissionModel> missions = [];

  // List<BaseDataModel> eventsAndMissionsByDate = [];
  Map<DateTime, List> eventsMap = {};

  List<int> daysPerMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  /// This is the function used for get the initial data
  Future<void> initData(
      {required List<EventModel> eventsList,
      required List<MissionModel> missionsList}) async {
    isLoaded = true;
    // debugPrint('Init data: $events, $missions');
    try {
      events = eventsList;
      missions = missionsList;
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoaded = false;
  }

  Future<void> toMapAMonth({required int year, required int month}) async {
    isMapping = true;
    eventsMap = {};
    for (int i = 0; i < daysPerMonth[month - 1]; i++) {
      DateTime date = DateTime(year, month, i + 1);
      await getEventsAndMissionsByDate(date);
    }
    // debugPrint('The map is: $eventsMap');
    isMapping = false;
    // debugPrint('The map is: $eventsMap');
    notifyListeners();
  }

  /// make get by date easier
  /// Will return a list of events and missions
  /// - [eventsAndMissionsByDate] is the list of events and missions that will be shown on the calendar but in list of **BaseDataModel** format
  /// - [eventAndMissionCards] is the list of events and missions that will be shown on the calendar but in list of **Widget** format
  Future<void> getEventsAndMissionsByDate(DateTime date) async {
    List eventsAndMissionsByDate = [];
    notifyListeners();
    List<EventModel> eventsByDate = await getEventsByDate(date);
    List<MissionModel> missionsByDate = await getMissinosByDate(date);
    // merge two list
    eventsAndMissionsByDate.addAll(missionsByDate);
    eventsAndMissionsByDate.addAll(eventsByDate);
    eventsMap[DateTime(date.year, date.month, date.day)] =
        eventsAndMissionsByDate;
    // debugPrint('Total thing at the date: $eventsAndMissionsByDate');
    // showCards();
    notifyListeners();
  }

  /// This is the function used for get the events by date
  ///
  /// - [eventsbyDate] is the list of events that will be shown on the calendar but in list of **EventModel** format
  /// - [eventCards] is the list of events that will be shown on the calendar but in list of **Widget** format
  Future<List<EventModel>> getEventsByDate(DateTime date) async {
    // debugPrint('The date is: $date');
    List<EventModel> eventsByDate = [];
    notifyListeners();
    eventsByDate = events.where((event) {
      return ((event.startTime.isBefore(
                  DateTime(date.year, date.month, date.day, 23, 59, 59)) ||
              event.startTime.isAtSameMomentAs(
                  DateTime(date.year, date.month, date.day, 23, 59, 59))) &&
          (event.endTime.isAfter(
                  DateTime(date.year, date.month, date.day, 0, 0, 0)) ||
              event.endTime.isAtSameMomentAs(
                  DateTime(date.year, date.month, date.day, 0, 0, 0))));
    }).toList();
    // debugPrint('The events are: $events');
    // debugPrint('The events by date are: $eventsByDate');
    // showCards();
    return eventsByDate;
  }

  /// get mission by date
  /// - [missionsByDate] is the list of missions that will be shown on the calendar but in list of **MissionModel** format
  /// - [eventAndMissionCards] is the list of missions and events that will be shown on the calendar but in list of **Widget** format
  Future<List<MissionModel>> getMissinosByDate(DateTime date) async {
    // debugPrint('The date is: $date');
    List<MissionModel> missionsByDate = [];
    notifyListeners();
    missionsByDate = missions.where((mission) {
      return (mission.deadline.isBefore(
              DateTime(date.year, date.month, date.day, 23, 59, 59)) &&
          mission.deadline
              .isAfter(DateTime(date.year, date.month, date.day, 0, 0, 0)));
    }).toList();
    // debugPrint('The missions are: $missions');
    // debugPrint('The missions by date are: $missionsByDate');
    // showCards();
    return missionsByDate;
  }
}
