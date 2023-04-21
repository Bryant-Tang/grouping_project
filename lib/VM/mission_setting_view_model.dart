import 'package:flutter/material.dart';
import 'package:grouping_project/VM/enlarge_edit_view_model.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/service_lib.dart';

import 'view_model_lib.dart';

class MissionSettingViewModel extends ChangeNotifier {
  MissionModel missionData = MissionModel();
  AccountModel profile = AccountModel();
  SettingMode settingMode = SettingMode.create;
  WorkspaceMode workspaceMode = WorkspaceMode.personal;

  String get introduction => missionData.introduction;
  String get title => missionData.title;
  DateTime get deadline => missionData.deadline;
  List<AccountModel> contributorProfile = [];
  List<AccountModel> get contributors => contributorProfile;
  List<AccountModel> get groupMember => profile.associateEntityAccount;
  Color get color => Color(missionData.color);

  set setModel(MissionModel newModel) {
    missionData = newModel;
    notifyListeners();
  }

  void updateTitle(String newTitle) {
    missionData.title = newTitle;
    notifyListeners();
  }

  String? titleValidator() {
    return title.isEmpty ? '不可為空' : null;
  }

  void updateIntroduction(String newIntro) {
    missionData.introduction = newIntro;
    notifyListeners();
  }

  String? introductionValidator() {
    return introduction.isEmpty ? '不可為空' : null;
  }

  void updateDeadline(DateTime newTime) {
    missionData.deadline = newTime;
    notifyListeners();
  }


  void addContributors(String newContributorId) {
    missionData.contributorIds.add(newContributorId);
    notifyListeners();
  }

  void removeContributors(String removedContributorId) {
    missionData.contributorIds.remove(removedContributorId);
    notifyListeners();
  }

  Future<void> onSave() async {
    if (settingMode == SettingMode.create) {
      // Create Event
    } else if (settingMode == SettingMode.edit) {
      // Edit Event
    } else {}
  }

  set setSettingMode(SettingMode mode) {
    settingMode = mode;
    notifyListeners();
  }

  set setWorkspaceMode(WorkspaceMode mode) {
    workspaceMode = mode;
    notifyListeners();
  }

  set setProfile(AccountModel newProfile) {
    profile = newProfile;
    notifyListeners();
  }
}
