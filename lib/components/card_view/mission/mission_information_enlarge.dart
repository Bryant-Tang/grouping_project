import 'package:flutter/material.dart';
import 'package:grouping_project/components/card_view/enlarge_viewModel.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/components/card_view/mission_information.dart';

/*
* this file is used to create mission enlarge view
*/

class MissionInformationEnlarge extends StatefulWidget {
  /// 這個 class 實現了 mission 放大時要展現的資訊
  /// 藉由創建時得到的資料來回傳一個 Container 回去
  /// ps. 需與 cardViewTemplate 一起使用
  const MissionInformationEnlarge({super.key, required this.missionModel});

  final MissionModel missionModel;


  @override
  State<MissionInformationEnlarge> createState() =>
      _MissionInformationEnlargeState();
}

class _MissionInformationEnlargeState extends State<MissionInformationEnlarge> {
  @override
  Widget build(BuildContext context) {
    String group = widget.missionModel.ownerName;
    String title =  widget.missionModel.title ?? 'unknown';
    String descript =  widget.missionModel.introduction ?? 'unknown';
    DateTime deadline =  widget.missionModel.deadline ?? DateTime(0);
    List<String> contributorIds =  widget.missionModel.contributorIds ?? [];
    String missionStage =
        stageToString(widget.missionModel.stage ?? MissionStage.progress);
    String stateName = widget.missionModel.stateName ?? 'progress';
    Color color = Color(widget.missionModel.color);

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
                                builder: (context) => MissionEditPage(
                                    missionModel: widget.missionModel)));
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
          TitleDateOfMission(
              title: title,
              deadline: deadline,
              group: group,
              color: color,
              stage: missionStage,
              stateName: stateName,),
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
