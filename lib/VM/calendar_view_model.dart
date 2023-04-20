import 'package:flutter/material.dart';
import 'package:grouping_project/VM/workspace_dashboard_view_model.dart';
import 'package:grouping_project/model/data_model.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_event_page.dart';
import 'package:grouping_project/service/service_lib.dart';

class CalendarViewModel extends ChangeNotifier {
  final DatabaseService databaseService =
      DatabaseService(ownerUid: AuthService().getUid());
  List<EventModel> events = [];
  List<MissionModel> missions = [];
  List<EventModel> eventsByDate = [];
  List<MissionModel> missionsByDate = [];
  List<BaseDataModel> eventsAndMissionsByDate = [];

  /// This is the function used for get the initial data
  Future<void> initData() async {
    events = await databaseService.getAllEvent();
    missions = await databaseService.getAllMission();

    // debugPrint('${model.events} ${model.missions}');
    await getEventsAndMissionsByDate(DateTime.now());
  }

  /// make get by date easier
  /// Will return a list of events and missions
  /// - [eventsAndMissionsByDate] is the list of events and missions that will be shown on the calendar but in list of **BaseDataModel** format
  /// - [eventAndMissionCards] is the list of events and missions that will be shown on the calendar but in list of **Widget** format
  Future<void> getEventsAndMissionsByDate(DateTime date) async {
    notifyListeners();
    getEventsByDate(date);
    getMissinosByDate(date);
    // merge two list
    eventsAndMissionsByDate = [];
    eventsAndMissionsByDate.addAll(missionsByDate);
    eventsAndMissionsByDate.addAll(eventsByDate);
    debugPrint('Total thing at the date: $eventsAndMissionsByDate');
    // showCards();
    notifyListeners();
  }

  /// This is the function used for get the events by date
  ///
  /// - [eventsbyDate] is the list of events that will be shown on the calendar but in list of **EventModel** format
  /// - [eventCards] is the list of events that will be shown on the calendar but in list of **Widget** format
  Future<void> getEventsByDate(DateTime date) async {
    // debugPrint('The date is: $date');
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
    notifyListeners();
  }

  /// get mission by date
  /// - [missionsByDate] is the list of missions that will be shown on the calendar but in list of **MissionModel** format
  /// - [eventAndMissionCards] is the list of missions and events that will be shown on the calendar but in list of **Widget** format
  Future<void> getMissinosByDate(DateTime date) async {
    // debugPrint('The date is: $date');
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
    notifyListeners();
  }
}
