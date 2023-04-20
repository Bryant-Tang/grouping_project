import 'package:flutter/material.dart';
import 'package:grouping_project/VM/workspace_dashboard_view_model.dart';
import 'package:grouping_project/components/card_view/event/event_card.dart';
import 'package:grouping_project/components/card_view/mission/mission_card_view.dart';
import 'package:grouping_project/model/data_model.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_event_page.dart';
import 'package:grouping_project/service/service_lib.dart';

class CalendarViewModel extends ChangeNotifier {
  final DatabaseService databaseService =
      DatabaseService(ownerUid: AuthService().getUid());
  List<EventModel> eventsByDate = [];
  List<MissionModel> missionsByDate = [];
  List<BaseDataModel> eventsAndMissionsByDate = [];
  List<Widget> eventAndMissionCards = [];

  /// This is the function used for get the initial data
  void init(WorkspaceDashboardViewModel model) {
    WidgetsBinding.instance.addPostFrameCallback((_) => model.getAllData());
    getEventsAndMissionsByDate(DateTime.now(), model);
  }

  /// make get by date easier
  /// Will return a list of events and missions
  /// - [eventsAndMissionsByDate] is the list of events and missions that will be shown on the calendar but in list of **BaseDataModel** format
  /// - [eventAndMissionCards] is the list of events and missions that will be shown on the calendar but in list of **Widget** format
  Future<void> getEventsAndMissionsByDate(
      DateTime date, WorkspaceDashboardViewModel model) async {
    getEventsByDate(date, model.events);
    getMissinosByDate(date, model.missions);
    // merge two list
    eventsAndMissionsByDate = [];
    eventsAndMissionsByDate.addAll(missionsByDate);
    eventsAndMissionsByDate.addAll(eventsByDate);
    showCards();
    notifyListeners();
  }

  /// This is the function used for get the events by date
  ///
  /// - [eventsbyDate] is the list of events that will be shown on the calendar but in list of **EventModel** format
  /// - [eventCards] is the list of events that will be shown on the calendar but in list of **Widget** format
  Future<void> getEventsByDate(DateTime date, List<EventModel> events) async {
    // debugPrint('The date is: $date');
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
    debugPrint('The events are: $eventsByDate');
    // showCards();
    notifyListeners();
  }

  /// get mission by date
  /// - [missionsByDate] is the list of missions that will be shown on the calendar but in list of **MissionModel** format
  /// - [eventAndMissionCards] is the list of missions and events that will be shown on the calendar but in list of **Widget** format
  Future<void> getMissinosByDate(
      DateTime date, List<MissionModel> missions) async {
    // debugPrint('The date is: $date');
    missionsByDate = missions.where((mission) {
      return (mission.deadline.isBefore(
              DateTime(date.year, date.month, date.day, 23, 59, 59)) &&
          mission.deadline
              .isAfter(DateTime(date.year, date.month, date.day, 0, 0, 0)));
    }).toList();
    debugPrint('The missions are: $missionsByDate');
    // showCards();
    notifyListeners();
  }

  /// This is the function used for showing the event and mission cards
  Future<void> showCards() async {
    eventAndMissionCards = [];
    for (int index = 0; index < missionsByDate.length; index++) {
      // debugPrint(index.toString());
      eventAndMissionCards.add(const SizedBox(
        height: 10,
      ));
      eventAndMissionCards.add(MissionCardViewTemplate(
        missionModel: missionsByDate[index],
      ));
    }
    for (int index = 0; index < eventsByDate.length; index++) {
      // debugPrint(index.toString());
      eventAndMissionCards.add(const SizedBox(
        height: 10,
      ));

      eventAndMissionCards.add(EventCardViewTemplate(
        eventModel: eventsByDate[index],
      ));
    }
  }
}
