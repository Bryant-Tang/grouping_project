import 'package:flutter/material.dart';
import 'package:grouping_project/View/event_setting_view.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () async {
        debugPrint('create event');
        await Navigator.push(context,
            MaterialPageRoute(builder: ((context) => EventSettingPageView.create())));
        setState(() {});
      },
      splashFactory: InkRipple.splashFactory,
      child: Card(
        child: Container(
          width: 190,
          height: 300,
          color: const Color(0xFFD9EDFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/Event.png'),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: const Text(
                  '事件 EVENT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    '開啟一個meeting或設立某些重大事件，確保組員們都空出時間。',
                    softWrap: true,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
