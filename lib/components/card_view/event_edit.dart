import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
// import 'package:grouping_project/components/card_view/event_information.dart';
import 'package:grouping_project/components/card_view/enlarge_context_template.dart';
import 'package:grouping_project/components/card_view/edit_enlarge_fragment_body.dart';

class EventEditPage extends StatefulWidget {
  const EventEditPage({super.key});

  @override
  State<EventEditPage> createState() => _EventEditPageState();
}

class _EventEditPageState extends State<EventEditPage> {



  @override
  Widget build(BuildContext context) {
    
    String group = 'personal';
    String title = 'Test Title';
    String descript = 'This is a test information text.';
    DateTime startTime = DateTime(0);
    DateTime endTime = DateTime.now().add(const Duration(days: 1));
    List<String> contributorIds = [];
    Color color = Colors.amber;
    TextEditingController titleContorller = TextEditingController(text: title);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            debugPrint('back');
            Navigator.pop(context);
          }, icon: const Icon(Icons.cancel)),
          IconButton(onPressed: (){
            if(titleContorller.text.isNotEmpty){
              debugPrint('Done');
              Navigator.pop(context);
            }
            else {debugPrint('error occur');}
          }, icon: const Icon(Icons.done))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width - 30,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            const Divider(
              thickness: 1.5,
              color: Color.fromARGB(255, 170, 170, 170),
            ),
            TitleDateOfEvent(
              titleController: titleContorller,
                startTime: startTime,
                endTime: endTime,
                group: group,
                color: color,
                callback: (p0, p1){
                  startTime = p0;
                  endTime = p1;
                }),
            EnlargeObjectTemplate(
                title: '參與成員',
                contextOfTitle: Contributors(
                  contributorIds: contributorIds,
                )),
            const SizedBox(
              height: 1,
            ),
            EnlargeObjectTemplate(
                title: '敘述',
                contextOfTitle: Text(
                  descript,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  softWrap: true,
                  maxLines: 5,
                )),
            const SizedBox(
              height: 2,
            ),
            const EnlargeObjectTemplate(
              title: '相關任務',
              // contextOfTitle: Container(
              //   height: 50,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(5),
              //       border: Border.all(color: Colors.black)),
              // ),
              contextOfTitle: CollabMissons(),
            ),
            const SizedBox(
              height: 2,
            ),
            const EnlargeObjectTemplate(
                title: '相關共筆', contextOfTitle: CollabNotes()),
            const SizedBox(
              height: 2,
            ),
            const EnlargeObjectTemplate(
              title: '相關會議',
              contextOfTitle: CollabMeetings(),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSetWidget extends StatefulWidget {
  /// this is the temporal class, it will be deleted when event edit page is complete.
  const TimeSetWidget({super.key});

  @override
  State<TimeSetWidget> createState() => _StartEndState();
}

class _StartEndState extends State<TimeSetWidget> {
  DateTime _start = DateTime(0);
  DateTime _end = DateTime.now();

  @override
  Widget build(BuildContext context) {
    void timePickerDialog(DateTime show, int state) {
      Time tmp = Time(hour: 0, minute: 0);
      Navigator.of(context).push(
        showPicker(
          value: tmp,
          onChange: (time) {
            setState(() {
              if (state == 0) {
                _start = DateTime(
                    show.year, show.month, show.day, time.hour, time.minute);
              } else if (state == 1) {
                _end = DateTime(
                    show.year, show.month, show.day, time.hour, time.minute);
              }
            });
          },
        ),
      );
    }

    void startConfirmChange(Object? value) {
      DateTime tmp = DateTime(0);
      if (value is DateTime) {
        tmp = value;
      }
      Navigator.pop(context);
      timePickerDialog(tmp, 0);
    }

    void endConfirmChange(Object? value) {
      DateTime tmp = DateTime(0);
      if (value is DateTime) {
        tmp = value;
      }
      Navigator.pop(context);
      timePickerDialog(tmp, 1);
    }

    void cancelChange() {
      setState(() {
        Navigator.pop(context);
      });
    }

    DateFormat parseDate = DateFormat('h:mm a, MMM d, yyyy');

    return Scaffold(
      body: Center(
        child: Column(children: [
          Text(
            parseDate.format(_start),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const Icon(
            Icons.arrow_right_alt_outlined,
            size: 13,
          ),
          Text(
            parseDate.format(_end),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: ((BuildContext context) {
                      return AlertDialog(
                        title: const Text('Please select range time'),
                        content: SizedBox(
                            width: 200,
                            height: 400,
                            child: SfDateRangePicker(
                              // onSelectionChanged: _onSelected,
                              onSubmit: startConfirmChange,
                              onCancel: cancelChange,
                              initialSelectedRange: PickerDateRange(
                                  DateTime.now(), DateTime.now()),
                              showActionButtons: true,
                            )),
                      );
                    }));
              },
              child: const Text('change Start Time')),
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: ((BuildContext context) {
                      return AlertDialog(
                        title: const Text('Please select range time'),
                        content: SizedBox(
                            width: 200,
                            height: 400,
                            child: SfDateRangePicker(
                              // onSelectionChanged: _onSelected,
                              onSubmit: endConfirmChange,
                              onCancel: cancelChange,
                              initialSelectedRange: PickerDateRange(
                                  DateTime.now(), DateTime.now()),
                              showActionButtons: true,
                            )),
                      );
                    }));
              },
              child: const Text('change Start Time')),
        ]),
      ),
    );
  }
}
