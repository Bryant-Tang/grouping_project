//import 'package:grouping_project/components/card_view.dart';
import 'package:grouping_project/model/model_lib.dart';

import 'package:grouping_project/components/card_view/event_information.dart';

import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});
  @override
  State<EventPage> createState() => EventPageState();
}

List<Widget> eventCards = [];

class EventPageState extends State<EventPage> {
  @override
  void initState() {
    super.initState();
    showEvents().then((value) {
      if(mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height - 80,
      child: ListView(
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: eventCards)
        ],
      ),
    );
  }
}

Future<void> showEvents() async {
  // var allDatas =
  //     await DataController().downloadAll(dataTypeToGet: EventModel());

  // eventCards = [];
  // for (int index = 0; index < allDatas.length; index++) {
  //   var event = allDatas[index];
  //   eventCards.add(const SizedBox(
  //     height: 10,
  //   ));
  //   eventCards.add(EventCardViewTemplate(eventModel: event));
  // }
}
