import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/View/workspace_view.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
// import 'package:grouping_project/components/card_view/event_information.dart';
import 'package:grouping_project/components/card_view/enlarge_context_template.dart';
import 'package:grouping_project/components/card_view/edit_enlarge_fragment_body.dart';

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
  // TODO: check color is random or not
  late Color color;

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
    } else {
      titleController = TextEditingController(text: widget.eventModel!.title);
      descriptController =
          TextEditingController(text: widget.eventModel!.introduction);
      group = widget.eventModel!.ownerName;
      startTime = widget.eventModel!.startTime!;
      endTime = widget.eventModel!.endTime!;
      color = Color(widget.eventModel!.color);
    }

    // group = 'personal';
    // startTime = DateTime.now();
    // endTime = DateTime.now().add(const Duration(days: 1));
    // titleController = TextEditingController(text: 'Test Title');
    // descriptController =
    //     TextEditingController(text: 'this is a test introduction');
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String group = 'personal';
    // DateTime startTime = DateTime.now().subtract(const Duration(days: 1));
    // DateTime endTime = DateTime.now().add(const Duration(days: 1));
    List<String> contributorIds = [];

    void createEvent() async {
      await DataController().upload(
          uploadData: EventModel(
        title: titleController.text,
        introduction: descriptController.text,
        startTime: startTime,
        endTime: endTime,
      ));
    }

    void updateEvent() async {
      // TODO: check it's the same event and has been modified to new data
      await DataController().upload(
          uploadData: EventModel(
        id: widget.eventModel!.id,
        title: titleController.text,
        introduction: descriptController.text,
        startTime: startTime,
        endTime: endTime,
      ));
    }

    void removeEvent() async {
      await DataController().remove(removeData: widget.eventModel!);
    }

    return Scaffold(
      // body: Container(
      //   padding: const EdgeInsets.only(left: 10, top: 18),
      //   width: MediaQuery.of(context).size.width - 30,
      //   height: MediaQuery.of(context).size.height,
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
                            removeEvent();
                            // Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => BasePage()),
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
                            debugPrint('Done');
                            // TODO: eventModel isn't null == update the data
                            if (widget.eventModel != null) {
                              updateEvent();
                            }
                            // TODO: eventModel is null == create the data
                            else {
                              createEvent();
                            }
                            // Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => BasePage()),
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
              color: Color.fromARGB(255, 170, 170, 170),
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
                )),
            const SizedBox(
              height: 1,
            ),
            EnlargeObjectTemplate(
              title: '敘述',
              contextOfTitle: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                controller: descriptController,
                onChanged: (value) {
                  descriptController.text = value;
                  descriptController.selection = TextSelection.fromPosition(
                      TextPosition(offset: value.length));
                  // debugPrint(descriptController.text);
                  setState(() {});
                },
                decoration: InputDecoration(
                    hintText: '輸入標題',
                    errorText: descriptController.text.isEmpty ? '不可為空' : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 2),
                    border: const OutlineInputBorder()),
                style: const TextStyle(fontSize: 15),
              ),
              // contextOfTitle: Text(
              //   descript,
              //   style: const TextStyle(
              //     fontSize: 15,
              //   ),
              //   softWrap: true,
              //   maxLines: 5,
              // ),
            ),
            const SizedBox(
              height: 2,
            ),
            const EnlargeObjectTemplate(
              title: '相關任務',
              contextOfTitle: CollabMissons(),
            ),
            const SizedBox(
              height: 2,
            ),
            const EnlargeObjectTemplate(
                title: '相關共筆', contextOfTitle: CollabNotes()),
            const SizedBox(
              height: 2,
            ),
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
