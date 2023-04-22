import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/service_lib.dart';
import 'package:intl/intl.dart';
import 'view_model_lib.dart';

class EventSettingViewModel extends ChangeNotifier {
  EventModel eventData = EventModel();
  AccountModel profile = AccountModel();

  SettingMode settingMode = SettingMode.create;
  WorkspaceMode workspaceMode = WorkspaceMode.personal;
  bool isPersonal = true;

  String get introduction => eventData.introduction;
  String get title => eventData.title;
  String get ownerAccountName {
    // debugPrint(eventData.ownerName);
    return eventData.ownerName;
  }

  DateTime get startTime => eventData.startTime;
  DateTime get endTime => eventData.endTime;
  List<AccountModel> contributorProfile = [];
  List<AccountModel> get contributors => contributorProfile;
  List<AccountModel> get groupMember => profile.associateEntityAccount;
  Color get color => Color(eventData.color);
  bool get forUser => isPersonal;
  set isForUser(bool forUser) {
    isPersonal = forUser;
    notifyListeners();
  }

  EventSettingViewModel(this.eventData, this.settingMode);

  factory EventSettingViewModel.display(EventModel eventData) =>
      EventSettingViewModel(eventData, SettingMode.displpay);
  factory EventSettingViewModel.create({required AccountModel accountProfile}) {
    EventSettingViewModel model =
        EventSettingViewModel(EventModel(), SettingMode.create);
    model.updateStartTime(DateTime.now());
    model.updateEndTime(DateTime.now().add(const Duration(days: 1)));
    model.updateTitle('New Title');
    model.updateIntroduction('');
    model.setProfile = accountProfile;
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

  String get formattedStartTime =>
      DateFormat('h:mm a, MMM d, y').format(startTime);
  String get formattedEndTime => DateFormat('h:mm a, MMM d, y').format(endTime);
  // String diffTimeFromNow() {
  //   Duration difference = endTime.difference(DateTime.now());

  //   int days = difference.inDays;
  //   int hours = difference.inHours % 24;
  //   int minutes = difference.inMinutes % 60;

  //   return '剩餘 $days D $hours H $minutes M';
  // }

  void addContributors(String newContributorId) {
    eventData.contributorIds.add(newContributorId);
    notifyListeners();
  }

  void removeContributors(String removedContributorId) {
    eventData.contributorIds.remove(removedContributorId);
    notifyListeners();
  }

  Future<bool> onSave() async {
    debugPrint("setting mode $settingMode");
    if (title.isEmpty ||
        introduction.isEmpty ||
        startTime.isAfter(endTime) ||
        endTime.isBefore(DateTime.now())) {
      return false;
    }
    if (settingMode == SettingMode.create) {
      // TODO: allow group
      debugPrint('profile id ${profile.id}');
      await DatabaseService(ownerUid: forUser ? AuthService().getUid() : profile.id!, forUser: forUser)
          .setEvent(event: eventData);
      debugPrint("Create 成功");
      // Create Event
    } else if (settingMode == SettingMode.edit) {
      await DatabaseService(
              ownerUid: forUser ? AuthService().getUid() : profile.id!,
              forUser: forUser)
          .setEvent(event: eventData);
      // Edit Event
    } else {}
    return true;
  }

  String errorMessage() {
    if (title.isEmpty) {
      return 'Title 不能為空';
    } else if (introduction.isEmpty) {
      return 'Introduction 不能為空';
    } else if (startTime.isAfter(endTime)) {
      return '開始時間在結束時間之後';
    } else if (endTime.isBefore(DateTime.now())) {
      return '結束時間不可在現在時間之前';
    } else {
      return 'unknown error';
    }
  }

  Future<void> deleteEvent() async {
     await DatabaseService(ownerUid: forUser ? AuthService().getUid() : profile.id!, forUser: forUser)
          .deleteEvent(eventData);
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
