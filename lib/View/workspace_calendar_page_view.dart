import 'package:grouping_project/VM/calendar_view_model.dart';

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
  CalendarViewModel model = CalendarViewModel();
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
        child: Card(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventAndMission[index].title,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              eventAndMission[index].introduction,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.w400),
            ),
            Row(
              children: [
                Text(
                  eventAndMission[index].startTime != null
                      ? DateFormat('yyyy-MM-dd hh:mm')
                          .format(eventAndMission[index].startTime)
                      : DateFormat('yyyy-MM-dd hh:mm')
                          .format(eventAndMission[index].deadline),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.arrow_right_alt_rounded),
                Text(
                  eventAndMission[index].endTime != null
                      ? DateFormat('yyyy-MM-dd hh:mm')
                          .format(eventAndMission[index].endTime)
                      : eventAndMission[index].state,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        )),
      ));
    }
    debugPrint(
        'length of all the cards are: ${eventAndMissionCards.length.toString()}');
    debugPrint('card content: ${eventAndMissionCards.toString()}');
  }

  /// refresh the page
  Future<void> onRefresh() async {
    model.initData();
    showCards(eventAndMission: model.eventsAndMissionsByDate);
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    model.initData().then((value) {
      showCards(eventAndMission: model.eventsAndMissionsByDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => model,
        child: Consumer<CalendarViewModel>(
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
                          //   // model.getEventsAndMissionsByDate(day);
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
                              model.getEventsAndMissionsByDate(selectedDay);
                              showCards(
                                  eventAndMission:
                                      model.eventsAndMissionsByDate);
                            });
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: eventAndMissionCards.length,
                          itemBuilder: (context, index) {
                            return eventAndMissionCards[index];
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
