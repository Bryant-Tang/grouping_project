import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class GenerateContentDisplayBlock extends StatelessWidget {
  const GenerateContentDisplayBlock(
      {Key? key, required this.blockTitle, required this.child})
      : super(key: key);
  final String blockTitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    TextStyle blockTitleTextStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.secondary);

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(blockTitle, style: blockTitleTextStyle),
            const Divider(thickness: 3),
            child
          ],
        ));
  }
}

/// (施工中)
/// 尚需增加給予的 model 是要用哪一種 function 以及想調整的時間
/// * callBack 會回傳新時間
class GetTimeBlock extends StatelessWidget {
  const GetTimeBlock(
      {Key? key,
      required this.callBack,
      required this.blockTitle,
      required this.oldTime})
      : super(key: key);

  final String blockTitle;
  // final EventSettingViewModel model; // TODO: 可能以後改成 activity VM 這種父級 VM
  final void Function(DateTime newTime) callBack;
  final DateTime oldTime;

  _showTimePicker(
      Function callBack, DateTime initialTime, BuildContext context) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: const Text('選擇時間'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.height * 0.8,
              child: SfDateRangePicker(
                initialSelectedDate: initialTime,
                showActionButtons: true,
                onSubmit: (value) {
                  debugPrint('選擇的日期: $value');
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    showPicker(
                        is24HrFormat: true,
                        value: Time(
                            hour: initialTime.hour, minute: initialTime.minute),
                        onChange: (newTime) {
                          debugPrint(
                              'SfDateRangePicker 的類型: ${value.runtimeType}');
                          debugPrint('選擇的時間: $newTime');
                          callBack((value as DateTime).copyWith(
                              hour: newTime.hour,
                              minute: newTime.minute,
                              second: 0));
                        }),
                  );
                },
                onCancel: () {
                  Navigator.pop(context);
                },
              ),
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return GenerateContentDisplayBlock(
        blockTitle: blockTitle,
        child: ElevatedButton(
            onPressed: () => _showTimePicker(callBack, oldTime,
                context), // TODO: custom function and time of vm
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 10),
                Text(DateFormat('h:mm a, MMM d, y').format(oldTime)),
                // Text(model.formattedEndTime),
              ],
            )));
  }
}

// class ContributorBlock extends StatelessWidget{
//   const ContributorBlock({super.key, required T})
// }