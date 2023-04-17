import 'package:flutter/material.dart';
import 'package:grouping_project/VM/enlarge_viewmodel.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/VM/event_card_view_model.dart';

import 'package:intl/intl.dart';

class EventInformationShrink extends StatelessWidget {
  const EventInformationShrink({super.key, required this.eventModel});

  final EventModel eventModel;

  @override
  Widget build(BuildContext context) {
    EventCardViewModel eventCardViewModel = EventCardViewModel(eventModel);
    
    String group = eventCardViewModel.group;
    String title = eventCardViewModel.title;
    String descript = eventCardViewModel.descript;
    DateTime startTime = eventCardViewModel.startTime;
    DateTime endTime = eventCardViewModel.endTime;
    Color color = eventCardViewModel.color;

    DateFormat parseDate = DateFormat('h:mm a, MMM d, yyyy');

    // TODO: use Padding
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      // height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntiLabel(
            group: group,
            color: color,
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            descript.split('\n').length > 1 ? '${descript.split('\n')[0]}...' : descript,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(
            height: 1,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Text(
                  parseDate.format(startTime),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.arrow_right_alt,
                  size: 20,
                  color: color,
                ),
                Text(
                  parseDate.format(endTime),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ])
        ],
      ),
    );
  }
}
