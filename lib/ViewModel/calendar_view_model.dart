import 'package:flutter/material.dart';
import 'package:grouping_project/model/data_controller.dart';
import 'package:grouping_project/model/event_model.dart';
import 'package:grouping_project/components/card_view/event_information_shrink.dart';
import 'package:grouping_project/components/card_view/event_information_enlarge.dart';
import 'package:grouping_project/components/card_view/card_view_template.dart';

import 'package:table_calendar/table_calendar.dart';

class CalendarViewModel extends ChangeNotifier {
  final DataController dataController = DataController();
  List<EventModel> events = [];
  List<EventModel> eventsByDate = [];
  List<Widget> eventCards = [];
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  CalendarViewModel() {
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    getEvents();
  }

  DateTime? get selectedDay => _selectedDay;
  DateTime? get focusedDay => _focusedDay;
  CalendarFormat get calendarFormat => _calendarFormat;

  /// This is the function used for getting all event data from the database, backend only
  Future<void> getEvents() async {
    events = await dataController.downloadAll(dataTypeToGet: EventModel());
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
    showEvents();
    notifyListeners();
  }

  /// This is the function used for expanding the event card
  Future<void> showEvents() async {
    eventCards = [];
    for (int index = 0; index < eventsByDate.length; index++) {
      debugPrint(index.toString());
      eventCards.add(const SizedBox(
        height: 10,
      ));
      EventInformationShrink shrink =
          EventInformationShrink(eventModel: eventsByDate[index]);
      EventInformationEnlarge enlarge =
          EventInformationEnlarge(eventModel: eventsByDate[index]);

      eventCards.add(
          EventCardViewTemplate(detailShrink: shrink, detailEnlarge: enlarge));
    }
  }
}
