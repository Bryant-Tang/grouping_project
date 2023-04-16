import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';

class MissionCardViewModel extends ChangeNotifier {
  late MissionModel mission;

  MissionCardViewModel(MissionModel missionModel) {
    mission = missionModel;
  }

  String get id => mission.id ?? '0';
  String get group => mission.ownerName;
  String get title => mission.title ?? 'unknown';
  String get descript => mission.introduction ?? 'unknown';
  String get missionStage =>
      stageToString(mission.stage ?? MissionStage.progress);
  String get stateName => mission.stateName ?? 'progress';
  DateTime get deadline => mission.deadline ?? DateTime.now().add(const Duration(days: 1));
  List<String> get contributorIds => mission.contributorIds ?? [];
  Color get color => Color(mission.color);

    void updateMission(TextEditingController titleCrtl, TextEditingController descriptCrtl, DateTime deadline, List<String> contributorIds) async {
      await DataController().upload(
          uploadData: MissionModel(
        id: id,
        title: titleCrtl.text,
        introduction: descriptCrtl.text,
        deadline: deadline,
        contributorIds: contributorIds
      ));
    }

    void removeMission() async {
      await DataController().remove(removeData: mission);
    }
}
