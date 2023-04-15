import 'package:flutter/material.dart';
import 'package:grouping_project/model/data_controller.dart';
import 'package:grouping_project/model/event_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Future<void> _dataFuture;
  List<EventModel> _events = [];
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _dataFuture = refresh();
  }

  Future<void> refresh() async {
    await DataController()
        .downloadAll(dataTypeToGet: EventModel())
        .then((value) {
      setState(() {
        _events = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: TableCalendar(
          firstDay: DateTime(2019, 1, 1),
          lastDay: DateTime(2030, 12, 31),
          focusedDay: DateTime.now(),
          daysOfWeekHeight: 20,
          selectedDayPredicate: (day) {
            // Use `selectedDayPredicate` to determine which day is currently selected.
            // If this returns true, then `day` will be marked as selected.

            // Using `isSameDay` is recommended to disregard
            // the time-part of compared DateTime objects.
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
          },
          availableCalendarFormats: {CalendarFormat.month: 'month'},
          onPageChanged: (focusedDay) {
            // No need to call `setState()` here
            _focusedDay = focusedDay;
          },
        ));
  }
}
