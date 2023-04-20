import 'package:flutter/material.dart';
import 'package:grouping_project/VM/enlarge_edit_view_model.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/service_lib.dart';

import 'view_model_lib.dart';

class EventSettingViewModel extends ChangeNotifier {
  EventModel eventData = EventModel();
  AccountModel profile = AccountModel();
  EventSettingMode settingMode = EventSettingMode.create;
  WorkspaceMode workspaceMode = WorkspaceMode.personal;

  String get introduction => eventData.introduction;
  String get title => eventData.title;
  DateTime get startTime => eventData.startTime;
  DateTime get endTime => eventData.endTime;
  List<AccountModel> contributorProfile = [];
  List<AccountModel> get contributors => contributorProfile;
  List<AccountModel> get groupMember => profile.associateEntityAccount;

  set setModel(EventModel newModel) {
    eventData = newModel;
    notifyListeners();
  }

  void updateIntroduction(String newIntro) {
    eventData.introduction = newIntro;
    notifyListeners();
  }

  String? introductionValidator() {
    return introduction.isEmpty ? '不可為空' : null;
  }

  void updateTitle(String newTitle) {
    eventData.title = newTitle;
    notifyListeners();
  }

  void updateStartTime(DateTime newStart) {
    eventData.startTime = newStart;
    notifyListeners();
  }

  void updateEndTime(DateTime newEnd) {
    eventData.endTime = newEnd;
    notifyListeners();
  }

  void addContributors(String newContributorId) {
    eventData.contributorIds.add(newContributorId);
    notifyListeners();
  }

  void removeContributors(String removedContributorId) {
    eventData.contributorIds.remove(removedContributorId);
    notifyListeners();
  }

  Future<void> onSave() async {
    if (settingMode == EventSettingMode.create) {
      // Create Event
    } else if (settingMode == EventSettingMode.edit) {
      // Edit Event
    } else {}
  }

  set setSettingMode(EventSettingMode mode) {
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

  // Future<void> fetchData() async {
    // get data from firebase
    // if (workspaceMode == WorkspaceMode.personal) {
    //   contributorProfile.add(profile);
    // } else {
    //   // TODO: implement group data fetch   
    //   for(String id in eventData.contributorIds){
    //     contributorProfile.add(await DatabaseService(ownerUid: id).getAccount());
    //   }
    // }
  // }

  // DateTime get startTime => _startTime;
  // DateTime get endTime => _endTime;

  // set startTime(DateTime newStart) {
  //   _startTime = newStart;
  //   notifyListeners();
  // }

  // set endTime(DateTime newEnd) {
  //   _endTime = newEnd;
  //   notifyListeners();
  // }
}
