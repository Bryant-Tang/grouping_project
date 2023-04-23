import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/service_lib.dart';
import 'package:intl/intl.dart';
import 'view_model_lib.dart';

class EventSettingViewModel extends ChangeNotifier {
  // The event model
  // In display mode, call initialzeEventDisplay and pass eventModel to this VM
  // In edit mode, call initialzeNewEvent to create new event model
  // and pass owenr account and crator account to this model
  // Scenario1 -> dispaly (need to be initialize) -> edit
  // Scenario2 -> Create (need to be initialize) -> edit
  EventModel eventModel = EventModel();
  // Event 的擁有者, group or people Account。
  AccountModel owenerAccount = AccountModel();
  // Event 的創建者, 只有在第一次create的時候有用。
  AccountModel creatorAccount = AccountModel();
  // True if ownerAccount id equals to creator Account, otherwise False
  bool forUser = true;
  bool get isforUser => forUser;
  // factory EventSettingViewModel.display(EventModel eventData,) =>
  //     EventSettingViewModel(eventData, SettingMode.displpay);
  // factory EventSettingViewModel.create({required AccountModel accountProfile}) {
  //   EventSettingViewModel model =
  //       EventSettingViewModel(EventModel(), SettingMode.create);
  //   model.updateStartTime(DateTime.now());
  //   model.updateEndTime(DateTime.now().add(const Duration(days: 1)));
  //   model.updateTitle('New Title');
  //   model.updateIntroduction('');
  //   // model.setProfile = accountProfile;
  //   // model.setProfile = profile;
  //   return model;
  // }
  // factory EventSettingViewModel.edit(EventModel eventData) =>
  //     EventSettingViewModel(eventData, SettingMode.edit);
  // EventSettingViewModel(this.eventModel, this.settingMode);

  SettingMode settingMode = SettingMode.create;
  // timeer output format
  DateFormat dataformat = DateFormat('h:mm a, MMM d, y');
  String get formattedStartTime => dataformat.format(startTime);
  String get formattedEndTime => dataformat.format(endTime);

  // getter of eventModel
  String get title => eventModel.title; // Event title
  String get introduction => eventModel.introduction; // Introduction od event
  String get ownerAccountName => eventModel.ownerName; // event owner account name
  DateTime get startTime => eventModel.startTime; // event start time
  DateTime get endTime => eventModel.endTime; // event end time
  Color get color => Color(eventModel.color);
  List<String> get eventContributoIds => eventModel.contributorIds;
  // The list of contributor Account model whom involve in this event
  List<AccountModel> contributorAccountModel = [];
  List<AccountModel> get contributors => contributorAccountModel;
  // The list of contibutor canidatet when we select participant in edit and create mode
  List<AccountModel> get contributorCandidate =>
      forUser ? [] : owenerAccount.associateEntityAccount;
  // get event card Material design  color scheem seed;

  void updateTitle(String newTitle) {
    eventModel.title = newTitle;
    notifyListeners();
  }

  String? titleValidator(value) {
    return title.isEmpty ? '不可為空' : null;
  }

  void updateIntroduction(String newIntro) {
    eventModel.introduction = newIntro;
    notifyListeners();
  }

  String? introductionValidator(value) {
    return introduction.isEmpty ? '不可為空' : null;
  }

  void updateStartTime(DateTime newStart) {
    eventModel.startTime = newStart;
    notifyListeners();
  }

  void updateEndTime(DateTime newEnd) {
    eventModel.endTime = newEnd;
    notifyListeners();
  }

  void addContributors(String newContributorId) {
    eventModel.contributorIds.add(newContributorId);
    notifyListeners();
  }

  void removeContributors(String removedContributorId) {
    eventModel.contributorIds.remove(removedContributorId);
    notifyListeners();
  }

  void initializeNewEvent({
      required AccountModel creatorAccount,
      required AccountModel ownerAccount}) {
    ownerAccount = ownerAccount;
    creatorAccount = creatorAccount;
    forUser = ownerAccount.id! == creatorAccount.id!;
    eventModel = EventModel(
      startTime: DateTime.now(),
      title: '事件名稱',
      introduction: '事件介紹',
    );
  }

  Future<void> initializeDisplayEvent({required EventModel eventModel,
      required AccountModel creatorAccount,
      }) async {
    // ownerAccount = ownerAccount;
    creatorAccount = creatorAccount;
    eventModel = eventModel;
    if (isforUser == false) {
      // get all event contributor account Profile from owner Account model associate list
      // for (AccountModel candidateAccountModel in contributorCandidate) {
      //   if (eventContributoIds.contains(candidateAccountModel.id!)) {
      //     contributorAccountModel.add(candidateAccountModel);
      //   }
      // }
      for(String contributorId in eventContributoIds){
        contributorAccountModel.add(
          await DatabaseService(ownerUid: contributorId).getAccount()
        ); 
      }
    } else {
      contributorAccountModel.add(creatorAccount);
    }
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
      await createEvent();
    } else if (settingMode == SettingMode.edit) {
      await editEvent();
    }
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

  Future<void> createEvent() async {
    // Create event with eventData
    // Add account profile id into contributorIds
    forUser
        ? eventModel.contributorIds.add(owenerAccount.id!)
        : eventModel.contributorIds.add((await DatabaseService(
                    ownerUid: AuthService().getUid(), forUser: true)
                .getAccount())
            .id!);

    await DatabaseService(
            ownerUid: forUser ? AuthService().getUid() : owenerAccount.id!,
            forUser: forUser)
        .setEvent(event: eventModel);
  }

  Future<void> editEvent() async {
    // edit event with eventData
    await DatabaseService(
            ownerUid: forUser ? AuthService().getUid() : owenerAccount.id!,
            forUser: forUser)
        .setEvent(event: eventModel);
  }

  Future<void> deleteEvent() async {
    await DatabaseService(
            ownerUid: forUser ? AuthService().getUid() : owenerAccount.id!,
            forUser: forUser)
        .deleteEvent(eventModel);
    notifyListeners();
  }
}
