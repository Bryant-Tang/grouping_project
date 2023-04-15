import 'package:grouping_project/ViewModel/calendar_view_model.dart';
import 'package:grouping_project/theme/color_schemes.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDay = DateTime.now();
  late DateTime _focusedDay = DateTime.now();
  late List _eventToday;
  List eventsToday = [];
  CalendarViewModel model = CalendarViewModel();
  final Map<CalendarFormat, String> _calendarFormat = {
    CalendarFormat.month: 'month'
  };
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => model.getEventsByDate(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => model,
        child: Consumer<CalendarViewModel>(
          builder: (context, model, child) {
            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () => model.getEvents(),
              child: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    availableCalendarFormats: _calendarFormat,
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: lightColorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(color: Colors.white),
                      todayDecoration: BoxDecoration(
                        color: lightColorScheme.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: const TextStyle(color: Colors.white),
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        model.getEventsByDate(selectedDay);
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: model.eventsByDate.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Card(
                              child: ListTile(
                                title: Text(
                                    model.eventsByDate[index].title.toString()),
                                subtitle: Text(model
                                    .eventsByDate[index].introduction
                                    .toString()),
                              ),
                            ),
                            // Text(model.eventsByDate.length.toString())
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
