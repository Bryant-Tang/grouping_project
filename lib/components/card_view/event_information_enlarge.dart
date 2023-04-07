import 'package:flutter/material.dart';
import 'package:grouping_project/components/card_view/enlarge_fragment_body.dart';
import 'package:grouping_project/components/card_view/enlarge_context_template.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/components/card_view/event_edit.dart';

class EventInformationEnlarge extends StatefulWidget {
  /// (未完成!!)
  /// 這個 class 實現了 event 放大時要展現的資訊
  /// 藉由創建時得到的資料來回傳一個 Container 回去
  /// ps. 需與 cardViewTemplate 一起使用
  const EventInformationEnlarge({super.key, required this.eventModel});

  final EventModel eventModel;

  @override
  State<EventInformationEnlarge> createState() =>
      _EventInformationEnlargeState();
}

class _EventInformationEnlargeState extends State<EventInformationEnlarge> {
  @override
  Widget build(BuildContext context) {
    // String group = eventModel.ownerName;
    // String title = eventModel.title ?? 'unknown';
    // String descript = eventModel.introduction ?? 'unknown';
    // DateTime startTime = eventModel.startTime ?? DateTime(0);
    // DateTime endTime = eventModel.endTime ?? DateTime(0);
    // List<String> contributorIds = eventModel.contributorIds ?? [];
    // Color color = Color(eventModel.color);
    // String eventId = eventModel.id!;

    String group = 'personal';
    String title = 'Test Title';
    String descript = 'This is a test information text.';
    DateTime startTime = DateTime.now().subtract(const Duration(days: 1));
    DateTime endTime = DateTime.now().add(const Duration(days: 1));
    List<String> contributorIds = [];
    Color color = Colors.amber;

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
                        debugPrint('go to edit page');
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventEditPage(
                                    eventModel: widget.eventModel)));
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                      )),
                  IconButton(
                      onPressed: () {
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
            color: Color.fromARGB(255, 170, 170, 170),
          ),
          TitleDateOfEvent(
              title: title,
              startTime: startTime,
              endTime: endTime,
              group: group,
              color: color),
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
              contextOfTitle: Text(
                descript,
                style: const TextStyle(
                  fontSize: 15,
                ),
                softWrap: true,
                maxLines: 5,
              )),
          const SizedBox(
            height: 2,
          ),
          const EnlargeObjectTemplate(
            title: '相關任務',
            // contextOfTitle: Container(
            //   height: 50,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(5),
            //       border: Border.all(color: Colors.black)),
            // ),
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
    );
  }
}
