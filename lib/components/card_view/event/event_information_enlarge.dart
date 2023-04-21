import 'package:flutter/material.dart';
import 'package:grouping_project/VM/event_setting_view_model.dart';
import 'package:grouping_project/View/card_enlarge_view.dart';
import 'package:grouping_project/View/event_setting_view.dart' show EventSettingPageView;
import 'package:grouping_project/components/card_view/enlarge_context_template.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/components/card_view/event_information.dart';
import 'package:grouping_project/VM/event_card_view_model.dart';

/*
* this file is used to create event enlarge view
*/

class EventInformationEnlarge extends StatefulWidget {
  const EventInformationEnlarge({super.key, required this.eventModel});

  final EventModel eventModel;

  @override
  State<EventInformationEnlarge> createState() =>
      _EventInformationEnlargeState();
}

class _EventInformationEnlargeState extends State<EventInformationEnlarge> {

  late EventSettingViewModel model;

  @override
  void initState(){
    super.initState();
    model = EventSettingViewModel.display(widget.eventModel);
  }

  @override
  Widget build(BuildContext context) {


    // EventCardViewModel eventCardViewModel =
    //     EventCardViewModel(widget.eventModel);

    // String group = eventCardViewModel.group;
    // String title = eventCardViewModel.title;
    // String descript = eventCardViewModel.descript;
    // DateTime startTime = eventCardViewModel.startTime;
    // DateTime endTime = eventCardViewModel.endTime;
    // List<String> contributorIds = eventCardViewModel.contributorIds;
    // Color color = eventCardViewModel.color;

    // TODO: use Padding
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 20,
                  )),
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventSettingPageView(
                                    model: EventSettingViewModel.edit(widget.eventModel))));
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                      )),
                  IconButton(
                      onPressed: () {
                        // TODO: make notification
                        debugPrint('go to notification page');
                      },
                      icon: const Icon(
                        Icons.notifications,
                        size: 20,
                      )),
                ],
              )
            ],
          ),
          const Divider(
            thickness: 1.5,
            color: Color(0xFFAAAAAA),
          ),
          TitleDateOfEvent(
              title: model.title,
              startTime: model.startTime,
              endTime: model.endTime,
              group: model.profile.name,
              color: model.color),
          CardViewTitle(
              title: '參與成員',
              child: Container()
              // child: Contributors(
              //   contributorIds: model.contributors,
              // ),
              ),
          const SizedBox(
            height: 1,
          ),
          CardViewTitle(
              title: '敘述',
              child: Text(
                model.introduction,
                style: const TextStyle(
                  fontSize: 15,
                ),
                softWrap: true,
                maxLines: 5,
              )),
          const SizedBox(
            height: 2,
          ),
          CardViewTitle(
            title: '相關任務',
            child: Container(),
          ),
          const SizedBox(
            height: 2,
          ),
          CardViewTitle(title: '相關共筆', child: Container()),
          const SizedBox(
            height: 2,
          ),
          CardViewTitle(
            title: '相關會議',
            child: Container(),
          ),
        ],
      ),
    );
  }
}
