import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';


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
              if(state == 0){
                _start = DateTime(show.year, show.month, show.day, time.hour, time.minute);
              }
              else if(state == 1){
                _end = DateTime(show.year, show.month, show.day, time.hour, time.minute);
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