import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({super.key});

  @override
  State<CalendarViewPage> createState() => CalendarViewPageState();
}

class CalendarViewPageState extends State<CalendarViewPage> {
  CalendarController controller = CalendarController();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      // TODO: limit calendar height
      padding: const EdgeInsets.only(bottom: 90),
      child: SfCalendar(
        view: CalendarView.month,
        controller: controller,
        dataSource: MeetingDataSource(_getDataSource()),
        todayHighlightColor: Theme.of(context).colorScheme.primary,
        todayTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        initialSelectedDate: DateTime.now(),
        // by default the month appointment display mode set as Indicator, we can
        // change the display mode as appointment using the appointment display
        // mode property
        monthViewSettings: const MonthViewSettings(
            // appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
            // 瑞弟: 顯示點點或 event 的 name(預設 false)
            showAgenda: true,
            agendaItemHeight: 50),
        allowedViews: const [CalendarView.day, CalendarView.month],
        headerHeight: 50,
        // 瑞弟: this function can customize the view of event
        appointmentBuilder: (context, calendarAppointmentDetails) {
          // this is iterator
          final Meeting meetings =
              calendarAppointmentDetails.appointments.first;
          // the view of event
          // 如果當前顯示是 day，切換顯示方式
          if (controller.view == CalendarView.day) {
            return meetings.from.day == meetings.to.day
                ? Container(
                    //TODO: when time range is very small => overflow occur
                    padding: const EdgeInsets.all(5),
                    width: calendarAppointmentDetails.bounds.width,
                    height: calendarAppointmentDetails.bounds.height,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(meetings.eventName,
                            style: TextStyle(
                              fontSize:
                                  (calendarAppointmentDetails.bounds.height *
                                          0.25)
                                      .clamp(1, 20),
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis),
                        Text(
                          meetings.information,
                          style: TextStyle(
                            fontSize:
                                (calendarAppointmentDetails.bounds.height * 0.2)
                                    .clamp(1, 20),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.only(left: 3),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12)),
                    // TODO: VM
                    child: Text(
                      '${meetings.eventName} (${controller.displayDate!.day - meetings.from.day + 1}/${meetings.to.day - meetings.from.day + 1})'
                      '  ${meetings.from.day == controller.displayDate!.day ? DateFormat('hh:mm a').format(meetings.from) : ''} ~ '
                      '${meetings.to.day == controller.displayDate!.day ? DateFormat('hh:mm a').format(meetings.to) : ''}',
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  );
            // 如果當前顯示是 month，切換顯示方式
          } else if (controller.view == CalendarView.month) {
            // debugPrint(calendarAppointmentDetails.bounds.height.toString());
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Row(children: [
                Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              // TODO: VM
                              meetings.to.day == DateTime.now().day
                                  ? DateFormat('hh:mm a').format(meetings.from)
                                  : meetings.from.day ==
                                          controller.selectedDate!.day
                                      ? DateFormat('hh:mm a')
                                          .format(meetings.from)
                                      : '00:00 AM',
                              style: TextStyle(
                                  fontSize:
                                      calendarAppointmentDetails.bounds.height *
                                          0.2,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              // TODO: VM
                              meetings.to.day == DateTime.now().day
                                  ? DateFormat('hh:mm a').format(meetings.to)
                                  : meetings.to.day ==
                                          controller.selectedDate!.day
                                      ? DateFormat('hh:mm a')
                                          .format(meetings.to)
                                      : '23:59 PM',
                              style: TextStyle(
                                  fontSize:
                                      calendarAppointmentDetails.bounds.height *
                                          0.2,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        meetings.from.day == meetings.to.day
                            ? const SizedBox()
                            : Text(
                                '(${controller.selectedDate!.day - meetings.from.day + 1}/${meetings.to.day - meetings.from.day + 1})',
                                style: TextStyle(
                                    fontSize: calendarAppointmentDetails
                                            .bounds.height *
                                        0.2,
                                    fontWeight: FontWeight.bold),
                              )
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: VerticalDivider(
                      color: Theme.of(context).colorScheme.primary,
                    )),
                Expanded(
                    flex: 7,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(meetings.eventName,
                                style: TextStyle(
                                    fontSize: calendarAppointmentDetails
                                            .bounds.height *
                                        0.25,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis),
                            Text(
                              meetings.information,
                              style: TextStyle(
                                  fontSize:
                                      calendarAppointmentDetails.bounds.height *
                                          0.2),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        //TODO: mission state chip
                      ],
                    )),
              ]),
            );
          } else {
            return const Center(child: Text('error occur'));
          }
          // return Center(child: Text(meetings.from.toString()));
        },
      ),
    ));
  }

  // 預設會自動排序，所以不用管加入的 event startTime 順序
  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    // TODO: 跨日會爆開
    meetings.add(Meeting(
        'Conference 1',
        'infromation',
        startTime,
        endTime.add(const Duration(hours: 24)),
        Theme.of(context).colorScheme.primaryContainer,
        false));
    meetings.add(Meeting(
        'Conference 2',
        'infromation',
        startTime.subtract(const Duration(hours: 3)),
        endTime.subtract(const Duration(hours: 3)),
        Theme.of(context).colorScheme.primaryContainer,
        false));
    meetings.add(Meeting(
        'Conference 3',
        'infromation',
        startTime.add(const Duration(days: 3)),
        endTime.add(const Duration(days: 3)),
        Theme.of(context).colorScheme.primaryContainer,
        false));
    meetings.add(Meeting(
        'Conference 4',
        'infromation',
        startTime,
        startTime.add(const Duration(minutes: 30)),
        Theme.of(context).colorScheme.primaryContainer,
        false));

    return meetings;
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.information, this.from, this.to, this.background,
      this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  String information;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
