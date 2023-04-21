import 'package:flutter/material.dart';
import 'package:grouping_project/View/card_enlarge_view.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/VM/mission_card_view_model.dart';

import 'package:intl/intl.dart';

// anti-label pass color data?
// this is for shrink card
class MissionInformationShrink extends StatelessWidget {
  /// 這個 class 實現了 mission 縮小時要展現的資訊
  /// 藉由創建時得到的資料來回傳一個 Container 回去
  /// ps. 需與 cardViewTemplate 一起使用
  const MissionInformationShrink({super.key, required this.missionModel});

  final MissionModel missionModel;

  @override
  Widget build(BuildContext context) {
    MissionCardViewModel missionCardViewModel = MissionCardViewModel(missionModel);

    String group = missionCardViewModel.group;
    String title = missionCardViewModel.title;
    String descript = missionCardViewModel.descript;
    // MissionStage missionStage = missionCardViewModel.missionStage;
    // String stateName = missionCardViewModel.stateName;
    DateTime deadline = missionCardViewModel.deadline;
    Color color = missionCardViewModel.color;

    DateFormat parseDate = DateFormat('h:mm a, MMM d, yyyy');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
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
            descript.split('\n').length > 1
                ? '${descript.split('\n')[0]}...'
                : descript,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(
            height: 1,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('deadline: ${parseDate.format(deadline)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
            // StateOfMission(
            //   stage: missionStage,
            //   stateName: stateName,
            // )
          ])
        ],
      ),
    );
  }
}
