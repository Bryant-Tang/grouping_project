//
//  just a testing page to test event service.
//

import 'package:flutter/material.dart';
import 'package:grouping_project/model/user_model.dart';
import '../service/event_service.dart';

class EventDataTestPage extends StatefulWidget {
  const EventDataTestPage({super.key});

  @override
  State<EventDataTestPage> createState() => _TestPageState();
}

class _TestPageState extends State<EventDataTestPage> {
  String? _counter = '0';

  void _incrementCounter() async {
    await createEventData(
      userOrGroupId: 'test_user_1',
      eventId: 'test_event_1',
      title: 'test_title_1',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(days: 3)),
      notifications: [DateTime(2024, 2)],
      contributors: [UserModel(uid: 'test123')],
    );
    final testEvent = await getOneEventData(
        userOrGroupId: 'test_user_1', eventId: 'test_event_1');
    _counter =
        "title:${testEvent?.title}\nstart time:${testEvent?.startTime}\n"
        "state:${testEvent?.state}\nnotifications:${testEvent?.notifications}\n"
        "contributors:${testEvent?.contributors}";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
