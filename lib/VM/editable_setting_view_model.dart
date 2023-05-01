import 'package:flutter/material.dart';
import 'package:grouping_project/model/editable_model.dart';
import 'package:grouping_project/model/model_lib.dart';

class MissionSettingViewModel extends ChangeNotifier {
  bool isLoading = true;
  MissionSettingModel? missionSettingModel;
  AccountModel? eidtorAccountCache;
  AccountModel? creatorAccountCache;
  
  String? get isTitleValid => missionSettingModel!.isTitleValid ? null : '不可為空';
  String? get isIntroductionValid => missionSettingModel!.isIntroductionValid ? null : '不可為空';
  set title(String newTitle) => missionSettingModel!.updateTitle(newTitle);
  set introduction(String newIntro) => missionSettingModel!.updateIntroduction(newIntro);
  // set startTime(DateTime newTime) => missionSettingModel!.updateStartTime(newTime);
  set deadlineTime(DateTime newTime) => missionSettingModel!.updateDeadlineTime(newTime);

  MissionSettingViewModel.edit(MissionModel mission){
    missionSettingModel = MissionSettingModel.from(mission: mission);
  }
  MissionSettingViewModel.create(AccountModel creatorAccount, bool forUser){
    missionSettingModel = MissionSettingModel.create(
      ownerAccount: creatorAccount, forUser: forUser
    );
  }
}
