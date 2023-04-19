import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/home/home_page/base_page.dart';
import 'package:grouping_project/components/card_view/event_information.dart';
import 'package:grouping_project/ViewModel/enlarge_edit_viewmodel.dart';
import 'package:grouping_project/ViewModel/event_card_view_model.dart';

/*
* this file is used to create event or edit existed event 
*/

class EventEditPage extends StatefulWidget {
  const EventEditPage({super.key, this.eventModel});

  final EventModel? eventModel;

  @override
  State<EventEditPage> createState() => _EventEditPageState();
}

class _EventEditPageState extends State<EventEditPage> {
  late TextEditingController titleController;
  late TextEditingController descriptController;
  late String group;
  late DateTime startTime, endTime;
  late Color color;
  late List<String> contributorIds;

  late EventCardViewModel eventCardViewModel;

  @override
  void initState() {
    super.initState();
    if (widget.eventModel == null) {
      titleController = TextEditingController(text: '');
      descriptController = TextEditingController(text: '');
      // TODO: check is group or personal
      group = 'personal';
      startTime = DateTime.now();
      endTime = DateTime.now().add(const Duration(days: 1));
      color = const Color(0xFFFCBF49);
      contributorIds = [];
    } else {
      eventCardViewModel = EventCardViewModel(widget.eventModel!);

      titleController = TextEditingController(text: eventCardViewModel.title);
      descriptController =
          TextEditingController(text: eventCardViewModel.descript);
      group = eventCardViewModel.group;
      startTime = eventCardViewModel.startTime;
      endTime = eventCardViewModel.endTime;
      color = eventCardViewModel.color;
      contributorIds = eventCardViewModel.contributorIds;
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptController.dispose();
  }

  // TODO: move to viewModel without creating redundent eventModel
  void createEvent() async {
    await DataController().upload(
        uploadData: EventModel(
            title: titleController.text,
            introduction: descriptController.text,
            startTime: startTime,
            endTime: endTime,
            contributorIds: contributorIds));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      debugPrint('back');
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel)),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          debugPrint('remove');
                          if (widget.eventModel != null) {
                            eventCardViewModel.removeEvent();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const BasePage()),
                                (route) => false);
                          } else {
                            showDialog(
                                context: context,
                                builder: ((context) {
                                  return const AlertDialog(
                                    content: Text(
                                        "You can't delete the event which is not existed yet."),
                                  );
                                }));
                          }
                        },
                        icon: const Icon(Icons.delete)),
                    IconButton(
                        onPressed: () {
                          if (titleController.text.isNotEmpty &&
                              descriptController.text.isNotEmpty &&
                              startTime.isBefore(endTime)) {
                            // debugPrint('Done');
                            if (widget.eventModel != null) {
                              eventCardViewModel.updateEvent(titleController, descriptController, startTime, endTime, contributorIds);
                            } else {
                              createEvent();
                            }
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const BasePage()),
                                (route) => false);
                          } else {
                            debugPrint('error occur');
                          }
                        },
                        icon: const Icon(Icons.done)),
                  ],
                )
              ],
            ),
            const Divider(
              thickness: 1.5,
            color: Color(0xFFAAAAAA),
            ),
            TitleDateOfEvent(
                titleController: titleController,
                startTime: startTime,
                endTime: endTime,
                group: group,
                color: color,
                callback: (p0, p1) {
                  startTime = p0;
                  endTime = p1;
                }),
            EnlargeObjectTemplate(
                title: '參與成員',
                contextOfTitle: Contributors(
                  contributorIds: contributorIds,
                  callback: (p0) {
                    contributorIds = p0;
                  },
                )),
            const SizedBox(
              height: 1,
            ),
            EnlargeObjectTemplate(
              title: '敘述',
              contextOfTitle: Descript(descriptController: descriptController,)
            ),
            const SizedBox(
              height: 2,
            ),
            // TODO: connect event and mission
            const EnlargeObjectTemplate(
              title: '相關任務',
              contextOfTitle: CollabMissons(),
            ),
            const SizedBox(
              height: 2,
            ),
            // TODO: connect note and event
            const EnlargeObjectTemplate(
                title: '相關共筆', contextOfTitle: CollabNotes()),
            const SizedBox(
              height: 2,
            ),
            // TODO: connect event and meeting
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
