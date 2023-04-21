import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/service_lib.dart';

import 'view_model_lib.dart';

class EventSettingViewModel extends ChangeNotifier {
  EventModel eventData = EventModel();
  AccountModel profile = AccountModel();
  SettingMode settingMode = SettingMode.create;
  WorkspaceMode workspaceMode = WorkspaceMode.personal;

  String get introduction => eventData.introduction;
  String get title => eventData.title;
  DateTime get startTime => eventData.startTime;
  DateTime get endTime => eventData.endTime;
  List<AccountModel> contributorProfile = [];
  List<AccountModel> get contributors => contributorProfile;
  List<AccountModel> get groupMember => profile.associateEntityAccount;
  Color get color => Color(eventData.color);

  EventSettingViewModel(this.eventData, this.settingMode);

  factory EventSettingViewModel.display(EventModel eventData) =>
      EventSettingViewModel(eventData, SettingMode.displpay);
  factory EventSettingViewModel.create() {
    EventSettingViewModel model = EventSettingViewModel(EventModel(), SettingMode.create);
    model.updateStartTime(DateTime.now());
    model.updateEndTime(DateTime.now().add(const Duration(days: 1)));
    model.updateTitle('newTitle');
    model.updateIntroduction('new Introduction');
    // model.setProfile = profile;
    return model;
  }
  factory EventSettingViewModel.edit(EventModel eventData) =>
      EventSettingViewModel(eventData, SettingMode.edit);

  set setModel(EventModel newModel) {
    eventData = newModel;
    notifyListeners();
  }

  void updateTitle(String newTitle) {
    eventData.title = newTitle;
    notifyListeners();
  }

  String? titleValidator() {
    return title.isEmpty ? '不可為空' : null;
  }

  void updateIntroduction(String newIntro) {
    eventData.introduction = newIntro;
    notifyListeners();
  }

  String? introductionValidator() {
    return introduction.isEmpty ? '不可為空' : null;
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
    if (settingMode == SettingMode.create) {
      await DatabaseService(ownerUid: AuthService().getUid()).setEvent(event: eventData);
      // Create Event
    } else if (settingMode == SettingMode.edit) {
      DatabaseService(ownerUid: profile.id!).setEvent(event: eventData);
      // Edit Event
    } else {}
  }

  void removeEvent() {
    // DatabaseService(ownerUid: profile.id!).
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
