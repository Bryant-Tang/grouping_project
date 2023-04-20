import 'package:grouping_project/VM/calendar_view_model.dart';
import 'package:grouping_project/VM/workspace_dashboard_view_model.dart';
import 'package:grouping_project/model/data_model.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/service_lib.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDay = DateTime.now();
  late DateTime _focusedDay = DateTime.now();
  late List<Widget> eventAndMissionCards = [];
  CalendarViewModel calendarViewModel = CalendarViewModel();
  WorkspaceDashboardViewModel model = WorkspaceDashboardViewModel();
  final Map<CalendarFormat, String> _calendarFormat = {
    CalendarFormat.month: 'month'
  };
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<DateTime?> selectDay() async {
    return await showDatePicker(
      context: context,
      initialDate: _focusedDay,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
      // locale: const Locale('zh', 'TW'),
      // TODO: Color of the calendar need to be changed
      builder: (context, child) {
        return Theme(
            data: ThemeData(
              primaryColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: child!);
      },
    );
  }

  /// This is the function used for showing the event and mission cards
  Future<void> showCards({required List eventAndMission}) async {
    eventAndMissionCards = [];
    for (int index = 0; index < eventAndMission.length; index++) {
      // debugPrint(index.toString());
      eventAndMissionCards.add(Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Text(eventAndMission[index].title),
                  Text(eventAndMission[index].startTime != null
                      ? DateFormat('yyyy-MM-dd hh:mm')
                          .format(eventAndMission[index].startTime)
                      : DateFormat('yyyy-MM-dd hh:mm')
                          .format(eventAndMission[index].deadline)),
                  Text(eventAndMission[index].endTime != null
                      ? DateFormat('yyyy-MM-dd hh:mm')
                          .format(eventAndMission[index].endTime)
                      : eventAndMission[index].state),
                ],
              ))));
    }
    debugPrint(
        'length of all the cards are: ${eventAndMissionCards.length.toString()}');
  }

  /// refresh the page
  Future<void> onRefresh() async {
    calendarViewModel.init(model);
    showCards(eventAndMission: calendarViewModel.eventsAndMissionsByDate);
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    calendarViewModel.init(model);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => model,
        child: Consumer<WorkspaceDashboardViewModel>(
          builder: (context, model, child) {
            return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: onRefresh,
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
                          locale: 'zh_TW',
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          availableCalendarFormats: _calendarFormat,
                          daysOfWeekHeight: 20,
                          // eventLoader: (day) {
                          //   return model.eventsAndMissionsByDate;
                          // },
                          onHeaderTapped: (focusedDay) async {
                            focusedDay = await selectDay() ?? focusedDay;
                          },
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
                              calendarViewModel.getEventsAndMissionsByDate(
                                  selectedDay, model);
                              showCards(
                                  eventAndMission: calendarViewModel
                                      .eventsAndMissionsByDate);
                            });
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              calendarViewModel.eventAndMissionCards.length,
                          itemBuilder: (context, index) {
                            showCards(
                                    eventAndMission:
                                        calendarViewModel.eventAndMissionCards)
                                .then((value) {
                              return eventAndMissionCards[index];
                            });
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
                      // ElevatedButton(
                      //     onPressed: () async {
                      //       // await DatabaseService(
                      //       //         ownerUid: AuthService().getUid())
                      //       //     .setEvent(
                      //       //         event: EventModel(
                      //       //   title: 'test event title',
                      //       //   startTime: DateTime.now(),
                      //       //   endTime:
                      //       //       DateTime.now().add(const Duration(days: 7)),
                      //       //   introduction: 'test event introduction',
                      //       // ));
                      //       await DatabaseService(
                      //               ownerUid: AuthService().getUid())
                      //           .setMission(
                      //               mission: MissionModel(
                      //                   title: 'test mission title',
                      //                   deadline: DateTime.now()
                      //                       .add(const Duration(days: 7)),
                      //                   state: MissionStateModel
                      //                       .defaultProgressState,
                      //                   introduction:
                      //                       'test mission introduction'));
                      //     },
                      //     child: const Text('Test add'))
                    ],
                  ),
                ));
          },
        ));
  }
}
