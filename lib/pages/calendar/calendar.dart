import 'package:grouping_project/ViewModel/calendar_view_model.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_event_page.dart';
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
    showEvents();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => model,
        child: Consumer<CalendarViewModel>(
          builder: (context, model, child) {
            return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () => model.getEventsByDate(DateTime.now()),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TableCalendar(
                          // center Header Title,
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          availableCalendarFormats: _calendarFormat,
                          daysOfWeekHeight: 20,
                          calendarStyle: CalendarStyle(
                            // Decoration for today
                            todayDecoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                width: 2,
                              ),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // Decoration for weekend
                            weekendDecoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // Decoration for outside days
                            outsideDecoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // Decoration for default day
                            defaultDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // Decoration for selected day
                            selectedDecoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            selectedTextStyle: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  fontWeight: FontWeight.w500,
                                ),
                            todayTextStyle: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
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
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: model.eventCards.length,
                          itemBuilder: (context, index) {
                            return model.eventCards[index];
                            // Column(
                            //   children: [
                            //     ListTile(
                            //       title: Text(
                            //         model.eventsByDate[index].title.toString(),
                            //         style: Theme.of(context)
                            //             .textTheme
                            //             .labelLarge!
                            //             .copyWith(fontWeight: FontWeight.w500),
                            //       ),
                            //       subtitle: Text(
                            //         model.eventsByDate[index].introduction
                            //             .toString(),
                            //         style: Theme.of(context)
                            //             .textTheme
                            //             .labelLarge!
                            //             .copyWith(
                            //                 fontWeight: FontWeight.normal),
                            //       ),
                            //     ),
                            //     // Text(model.eventsByDate.length.toString())
                            //   ],
                            // );
                          },
                        ),
                      ),
                    ],
                  ),
                ));
          },
        ));
  }
}
