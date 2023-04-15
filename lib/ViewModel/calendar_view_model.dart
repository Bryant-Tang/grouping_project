import 'package:flutter/material.dart';
import 'package:grouping_project/model/data_controller.dart';
import 'package:grouping_project/model/event_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarViewModel extends ChangeNotifier {
  final DataController dataController = DataController();
  List<EventModel> events = [];
  List<EventModel> eventsByDate = [];
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

  Future<void> getEvents() async {
    events = await dataController.downloadAll(dataTypeToGet: EventModel());
    notifyListeners();
  }

  void getEventsByDate(DateTime date) async {
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
    notifyListeners();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    getEventsByDate(selectedDay);
  }
}
