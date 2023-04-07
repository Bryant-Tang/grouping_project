//import 'package:grouping_project/components/card_view.dart';
import 'package:grouping_project/model/model_lib.dart';

import 'package:grouping_project/components/card_view/event_information.dart';
import 'package:grouping_project/components/card_view/card_view_template.dart';

import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});
  @override
  State<EventPage> createState() => EventPageState();
}

List<Widget> eventCards = [];

class EventPageState extends State<EventPage> {
  @override
  void initState() async {
    super.initState();
    await showEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
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
  var allDatas =
      await DataController().downloadAll(dataTypeToGet: EventModel());

  eventCards = [];
  for (int index = 0; index < allDatas.length; index++) {
    var event = allDatas[index];
    eventCards.add(const SizedBox(
      height: 2,
    ));
    EventInformationShrink shrink = EventInformationShrink(eventModel: event);
    EventInformationEnlarge enlarge =
        EventInformationEnlarge(eventModel: event);

    eventCards
        .add(CardViewTemplate(detailShrink: shrink, detailEnlarge: enlarge));
  }
}
