import 'package:grouping_project/VM/mission_setting_view_model.dart';
import 'package:grouping_project/VM/workspace/calendar_view_model.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/View/EditableCard/event_card_view.dart';
import 'package:grouping_project/View/EditableCard/mission_card_view.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:intl/intl.dart';
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
  bool isShowing = false;

  // CalendarViewModel model = CalendarViewModel();

  final Map<CalendarFormat, String> _calendarFormat = {
    CalendarFormat.month: 'month'
  };
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<DateTime?> popupDatePicker(BuildContext context) {
    DateTime? selectedDate = DateTime.now();
    return showDialog<DateTime>(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 400,
            // width: 200,
            child: SfDateRangePicker(
              initialSelectedDate: DateTime.now(),
              selectionMode: DateRangePickerSelectionMode.single,
              showActionButtons: true,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                selectedDate = args.value;
              },
              onCancel: () {
                Navigator.pop(context);
              },
              onSubmit: (p0) {
                Navigator.pop(context, selectedDate);
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> onDaySelected(
      {required DateTime selectedDay,
      required DateTime focusedDay,
      required CalendarViewModel model}) async {
    eventAndMissionCards.clear();
    if (selectedDay.year != _focusedDay.year) {
      await model.getEventsAndMissionsByDate(selectedDay);
      await model.toMapAYear(year: selectedDay.year);
    }
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    setState(() {});
  }

  /// This is the function used for showing the event and mission cards
  void showCards({
    required List eventAndMission,
  }) async {
    isShowing = true;

    List<MissionModel> missionOnly = eventAndMission
        .where((element) {
          return element.toString() == 'Instance of \'MissionModel\'';
        })
        .toList()
        .cast();
    eventAndMissionCards.addAll(missionOnly
        .map((missionModel) => Container(
            key: ValueKey(missionModel),
            child: ChangeNotifierProvider<MissionSettingViewModel>(
                create: (context) => MissionSettingViewModel()
                  ..initializeDisplayMission(
                      model: missionModel,
                      user: context
                          .read<WorkspaceDashBoardViewModel>()
                          .personalprofileData),
                child: const MissionCardViewTemplate())))
        .toList());
    List<EventModel> eventsOnly = eventAndMission
        .where((element) {
          return element.toString() == 'Instance of \'EventModel\'';
        })
        .toList()
        .cast();
    eventAndMissionCards.addAll(eventsOnly
        .map((eventModel) => Container(
            key: ValueKey(eventModel),
            child: ChangeNotifierProvider<EventSettingViewModel>(
                create: (context) => EventSettingViewModel()
                  ..initializeDisplayEvent(
                      model: eventModel,
                      user: context
                          .read<WorkspaceDashBoardViewModel>()
                          .personalprofileData),
                child: const EventCardViewTemplate())))
        .toList());
    isShowing = false;
    // debugPrint(
    //     'length of all the cards are: ${eventAndMissionCards.length.toString()}');
    // debugPrint('card content: ${eventAndMissionCards.toString()}');
  }

  /// refresh the page
  Future<void> onRefresh(CalendarViewModel model) async {
    await model.getEventsAndMissionsByDate(_focusedDay);
    showCards(
        eventAndMission: model.eventsMap[DateTime(
                _focusedDay.year, _focusedDay.month, _focusedDay.day)] ??
            []);
    await model.toMapAYear(year: _focusedDay.year);
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   model.initData().whenComplete(
    //     () {
    //       onRefresh();
    //     },
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, workspaceVM, child) => Consumer<CalendarViewModel>(
        builder: (context, calenderVM, child) {
          return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () => onRefresh(calenderVM),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TableCalendar(
                        onCalendarCreated: (pageController) {
                          calenderVM
                              .initData(
                                  eventsList: workspaceVM.events,
                                  missionsList: workspaceVM.missions)
                              .whenComplete(() => onRefresh(calenderVM));
                        },
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
                        eventLoader: (day) {
                          // model.getEventsAndMissionsByDate(day);
                          return calenderVM.eventsMap[
                                  DateTime(day.year, day.month, day.day)] ??
                              [];
                        },
                        onHeaderTapped: (focusedDay) async {
                          DateTime? tempDate = await popupDatePicker(context);
                          if (tempDate != null) {
                            _focusedDay = tempDate;
                            _selectedDay = tempDate;
                            eventAndMissionCards.clear();
                            await onDaySelected(
                                selectedDay: _selectedDay,
                                focusedDay: _focusedDay,
                                model: calenderVM);
                            showCards(
                                eventAndMission: calenderVM.eventsMap[DateTime(
                                        _focusedDay.year,
                                        _focusedDay.month,
                                        _focusedDay.day)] ??
                                    []);
                          }
                        },
                        calendarStyle: CalendarStyle(
                          markerDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
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
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          selectedTextStyle:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                          todayTextStyle:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) async {
                          eventAndMissionCards.clear();
                          await onDaySelected(
                              model: calenderVM,
                              focusedDay: focusedDay,
                              selectedDay: selectedDay);
                          showCards(
                              eventAndMission: calenderVM.eventsMap[DateTime(
                                      _focusedDay.year,
                                      _focusedDay.month,
                                      _focusedDay.day)] ??
                                  []);
                        },
                        onPageChanged: (focusedDay) async {
                          if (focusedDay.year != _focusedDay.year) {
                            _focusedDay = focusedDay;
                            await calenderVM.toMapAYear(
                              year: _focusedDay.year,
                            );
                          }
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
                  ],
                ),
              ));
        },
      ),
    );
  }
}
