import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/service_lib.dart';

import 'view_model_lib.dart';

class MissionSettingViewModel extends ChangeNotifier {
  MissionModel missionData = MissionModel();
  AccountModel profile = AccountModel();
  SettingMode settingMode = SettingMode.create;
  WorkspaceMode workspaceMode = WorkspaceMode.personal;
  bool isPersonal = true;
  List<MissionStateModel> inProgress = [];
  List<MissionStateModel> pending = [];
  List<MissionStateModel> close = [];

  // String newStateModel

  String get introduction => missionData.introduction;
  String get title => missionData.title;
  String get ownerAccountName => missionData.ownerName;
  DateTime get deadline => missionData.deadline;
  List<AccountModel> contributorProfile = [];
  List<AccountModel> get contributors => contributorProfile;
  List<AccountModel> get groupMember => profile.associateEntityAccount;
  MissionStateModel get stateModel => missionData.state;
  Color get color => Color(missionData.color);
  bool get forUser => isPersonal;
  set isForUser(bool forUser){
    isPersonal = forUser;
    notifyListeners();
  }

  MissionSettingViewModel(this.missionData, this.settingMode);

  factory MissionSettingViewModel.display(MissionModel missionData) =>
      MissionSettingViewModel(missionData, SettingMode.displpay);
  factory MissionSettingViewModel.create({required AccountModel profile}) {
    MissionSettingViewModel model =
        MissionSettingViewModel(MissionModel(), SettingMode.create);
    model.setProfile = profile;
    model.updateDeadline(DateTime.now().add(const Duration(days: 1)));
    model.updateTitle('New Title');
    model.updateIntroduction('');
    model.getAllState();
    return model;
  }
  factory MissionSettingViewModel.edit(MissionModel missionData) =>
      MissionSettingViewModel(missionData, SettingMode.edit);

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

  void updateState(MissionStage newStage, String newStateName) {
    missionData.state.stage = newStage;
    missionData.state.stateName = newStateName;
    notifyListeners();
  }

  void createState(MissionStage newStage, String newStateName) async {
    await DatabaseService(ownerUid: profile.id!).setMissionState(state: MissionStateModel(stage: newStage, stateName: newStateName));
    updateState(newStage, newStateName);
  }

  void getAllState() async {
    var allState = await DatabaseService(ownerUid: profile.id!).getAllMissionState();
    for (int i = 0; i < allState.length; i++) {
      if (allState[i].stage == MissionStage.progress) {
        inProgress.add(allState[i]);
      } else if (allState[i].stage == MissionStage.pending) {
        pending.add(allState[i]);
      } else if (allState[i].stage == MissionStage.close) {
        close.add(allState[i]);
      }
    }
  }

  Future<bool> onSave() async {
    if (title.isEmpty ||
        introduction.isEmpty ||
        deadline.isBefore(DateTime.now())) {
      return false;
    } else if (settingMode == SettingMode.create) {
      // TODO: allow group 
      await DatabaseService(ownerUid: forUser ? AuthService().getUid() : profile.id!, forUser: forUser)
          .setMission(mission: missionData);
      // Create Event
    } else if (settingMode == SettingMode.edit) {
      await DatabaseService(ownerUid: forUser ? AuthService().getUid() : profile.id!, forUser: forUser)
          .setMission(mission: missionData);
      // Edit Event
    } else {}
    return true;
  }

  String errorMessage() {
    if (title.isEmpty) {
      return 'Title 不能為空';
    } else if (introduction.isEmpty) {
      return 'Introduction 不能為空';
    } else if (deadline.isBefore(DateTime.now())) {
      return '截止時間不可在現在時間之前';
    } else {
      return 'unknown error';
    }
  }

  Future<void> deleteEvent() async {
     await DatabaseService(ownerUid: forUser ? AuthService().getUid() : profile.id!, forUser: forUser)
          .deleteMission(missionData);
    notifyListeners();
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
