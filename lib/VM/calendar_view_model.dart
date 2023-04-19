import 'package:flutter/material.dart';
import 'package:grouping_project/components/card_view/mission/mission_card_view.dart';
import 'package:grouping_project/model/data_model.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/components/card_view/event_information.dart';
import 'package:grouping_project/service/service_lib.dart';

import 'package:table_calendar/table_calendar.dart';

class CalendarViewModel extends ChangeNotifier {
  final DatabaseService databaseService =
      DatabaseService(ownerUid: AuthService().getUid());
  List<EventModel> events = [];
  List<MissionModel> missions = [];
  List<EventModel> eventsByDate = [];
  List<MissionModel> missionsByDate = [];
  List<BaseDataModel> eventsAndMissionsByDate = [];
  List<Widget> eventAndMissionCards = [];
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  CalendarViewModel() {
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    getEvents();
  }

  /// This is the function used for getting all event data from the database, backend only
  Future<void> getEvents() async {
    events = await databaseService.getAllEvent();
    notifyListeners();
  }

  /// This is the function used for get the events by date
  ///
  /// - [eventsbyDate] is the list of events that will be shown on the calendar but in list of **EventModel** format
  /// - [eventCards] is the list of events that will be shown on the calendar but in list of **Widget** format
  Future<void> getEventsByDate(DateTime date) async {
    await getEvents();
    debugPrint('The date is: $date');
    eventsByDate = events.where((event) {
      // TODO: Make time of a day for checking to be midnight or else it will only check show those events that goes the whole
      return (event.startTime != null &&
          event.endTime != null &&
          (event.startTime!.isBefore(
                  DateTime(date.year, date.month, date.day, 23, 59, 59)) ||
              event.startTime!.isAtSameMomentAs(
                  DateTime(date.year, date.month, date.day, 23, 59, 59))) &&
          (event.endTime!.isAfter(
                  DateTime(date.year, date.month, date.day, 0, 0, 0)) ||
              event.endTime!.isAtSameMomentAs(
                  DateTime(date.year, date.month, date.day, 0, 0, 0))));
    }).toList();
    debugPrint('The events are: $eventsByDate');
    // showCards();
    notifyListeners();
    getMissinosByDate(date);
  }

  /// get all missions
  Future<void> getMissions() async {
    missions = await databaseService.getAllMission();
    notifyListeners();
  }

  /// get mission by date
  Future<void> getMissinosByDate(DateTime date) async {
    await getMissions();
    debugPrint('The date is: $date');
    missionsByDate = missions.where((mission) {
      return (mission.deadline != null &&
          mission.deadline!.isBefore(
              DateTime(date.year, date.month, date.day, 23, 59, 59)) &&
          mission.deadline!
              .isAfter(DateTime(date.year, date.month, date.day, 0, 0, 0)));
    }).toList();
    debugPrint('The missions are: $missionsByDate');
    // merge two list
    eventsAndMissionsByDate = [];
    eventsAndMissionsByDate.addAll(missionsByDate);
    eventsAndMissionsByDate.addAll(eventsByDate);
    showCards();
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
