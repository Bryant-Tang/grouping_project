import 'package:flutter/material.dart';
import 'package:grouping_project/ViewModel/enlarge_viewmodel.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/components/card_view/event_information.dart';

/*
* this file is used to create event enlarge view
*/

class EventInformationEnlarge extends StatefulWidget {
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
    String group = widget.eventModel.ownerName;
    String title =  widget.eventModel.title ?? 'unknown';
    String descript =  widget.eventModel.introduction ?? 'unknown';
    DateTime startTime =  widget.eventModel.startTime ?? DateTime(0);
    DateTime endTime =  widget.eventModel.endTime ?? DateTime(0);
    List<String> contributorIds =  widget.eventModel.contributorIds ?? [];
    Color color = Color(widget.eventModel.color);

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
