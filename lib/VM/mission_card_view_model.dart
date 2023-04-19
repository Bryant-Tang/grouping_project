import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';

class MissionCardViewModel extends ChangeNotifier {
  late MissionModel mission;

  MissionCardViewModel(MissionModel missionModel) {
    mission = missionModel;
  }

  String get id => mission.id ?? '0';
  String get group => mission.ownerName;
  String get title => mission.title;
  String get descript => mission.introduction;
  // MissionStage get missionStage => mission.stage ?? MissionStage.progress;
  // String get stateName => mission.stateName ?? 'progress';
  DateTime get deadline => mission.deadline;
  List<String> get contributorIds => mission.contributorIds;
  Color get color => Color(mission.color);

  void updateMission(
      TextEditingController titleCrtl,
      TextEditingController descriptCrtl,
      DateTime deadline,
      List<String> contributorIds,
      MissionStage stage,
      String stateName)async {
        debugPrint(stateName);
    // await DataController().upload(
    //     uploadData: MissionModel(
    //         id: id,
    //         title: titleCrtl.text,
    //         introduction: descriptCrtl.text,
    //         deadline: deadline,
    //         contributorIds: contributorIds,
    //         stage: stage,
    //         stateName: stateName));
  }

  void removeMission() async {
    // await DataController().remove(removeData: mission);
  }
}
