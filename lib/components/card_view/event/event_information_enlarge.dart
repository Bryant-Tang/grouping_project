import 'package:flutter/material.dart';
import 'package:grouping_project/VM/event_setting_view_model.dart';
import 'package:grouping_project/View/card_enlarge_view.dart';
import 'package:grouping_project/View/event_setting_view.dart'
    show EventSettingPageView;
import 'package:grouping_project/components/card_view/enlarge_context_template.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/components/card_view/event_information.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  late EventSettingViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = EventSettingViewModel.display(widget.eventModel);
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
    return ChangeNotifierProvider<EventSettingViewModel>.value(
      value: viewModel,
      builder: (context, child) => Consumer<EventSettingViewModel>(
        builder: (context, model, child) => Padding(
          padding: const EdgeInsets.all(2),
          child: SizedBox(
            // width: MediaQuery.of(context).size.width - 30,
            // height: MediaQuery.of(context).size.height,
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
                                      builder: (context) =>
                                          EventSettingPageView(
                                              model: EventSettingViewModel.edit(
                                                  widget.eventModel))));
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
                const TitleDateOfEvent(),
                CardViewTitle(title: '參與成員', child: Container()
                    // child: Contributors(
                    //   contributorIds: model.contributors,
                    // ),
                    ),
                const SizedBox(
                  height: 1,
                ),
                const CardViewTitle(title: '敘述', child: IntroductionBlock()),
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
          ),
        ),
      ),
    );
  }
}

class TitleDateOfEvent extends StatelessWidget {
  const TitleDateOfEvent({super.key});

  @override
  Widget build(BuildContext context) {
    DateFormat parseDate = DateFormat('h:mm a, MMM d, yyyy');

    return Consumer<EventSettingViewModel>(
      builder: (context, model, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntiLabel(group: 'not setting yet', color: model.color),
          Text(
            model.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text(
                parseDate.format(model.startTime),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.arrow_right_alt,
                size: 20,
                // color will be a variable
                color: model.color,
              ),
              Text(
                parseDate.format(model.endTime),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          ),
          // Row(
          //   children: [
          //     Icon(
          //       Icons.access_time,
          //       size: 20,
          //       color: model.color,
          //     ),
          //     Text(
          //       model.diffTimeFromNow(),
          //       style: TextStyle(
          //           fontSize: 15,
          //           fontWeight: FontWeight.bold,
          //           color: model.color),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}

class IntroductionBlock extends StatelessWidget {

  const IntroductionBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventSettingViewModel>(
      builder: (context, model, child) => Text(
        model.introduction,
        style: const TextStyle(
          fontSize: 15,
        ),
        softWrap: true,
        maxLines: 5,
      ),
    );
  }
}
