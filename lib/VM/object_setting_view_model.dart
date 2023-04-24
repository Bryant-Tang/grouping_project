// import 'package:flutter/material.dart';
// import 'package:grouping_project/model/data_model.dart';
// import 'package:grouping_project/model/model_lib.dart';
// import 'package:grouping_project/service/service_lib.dart';
// import 'package:intl/intl.dart';
// import 'view_model_lib.dart';

// class ObjectSettingViewModel<T extends BaseDataModel<T>> extends ChangeNotifier {
//   // The event model
//   // In display mode, call initialzeEventDisplay and pass eventModel to this VM
//   // In edit mode, call initialzeNewEvent to create new event model
//   // and pass owenr account and crator account to this model
//   // Scenario1 -> dispaly (need to be initialize) -> edit
//   // Scenario2 -> Create (need to be initialize) -> edit
//   BaseDataModel<T>? model;
//   EventModel eventModel = EventModel();
//   // Event 的擁有者, group or people Account。
//   // AccountModel ownerAccount = AccountModel();
//   // Event 的創建者, 只有在第一次create的時候有用。
//   AccountModel creatorAccount = AccountModel();
//   // True if ownerAccount id equals to creator Account, otherwise False
//   bool forUser = true;
//   bool get isforUser => forUser;
//   bool isLoading = false;

//   SettingMode settingMode = SettingMode.create;
//   // timeer output format
//   DateFormat dataformat = DateFormat('h:mm a, MMM d, y');
//   String get formattedStartTime => dataformat.format(startTime);
//   String get formattedEndTime => dataformat.format(endTime);

//   // getter of eventModel
//   get eventOwnerAccount => eventModel.ownerAccount;
//   String get title => eventModel.title; // Event title
//   String get introduction => eventModel.introduction; // Introduction od event
//   String get ownerAccountName =>
//       eventOwnerAccount.name; // event owner account name
//   DateTime get startTime => eventModel.startTime; // event start time
//   DateTime get endTime => eventModel.endTime; // event end time
//   Color get color => Color(eventModel.ownerAccount.color);
//   List<String> get eventContributoIds => eventModel.contributorIds;
//   // The list of contributor Account model whom involve in this event
//   List<AccountModel> contributorAccountModel = [];
//   List<AccountModel> get contributors => contributorAccountModel;
//   // The list of contibutor canidatet when we select participant in edit and create mode
//   List<AccountModel> get contributorCandidate =>
//       forUser ? [] : eventModel.ownerAccount.associateEntityAccount;
//   // get event card Material design  color scheem seed;
//   bool isEventContributor(AccountModel model) {
//     debugPrint(eventModel.contributorIds.contains(model.id).toString());
//     return eventModel.contributorIds.contains(model.id);
//   }

//   void toggleSelcted(AccountModel model) {
//     if (isEventContributor(model)) {
//       // add
//       removeContributors(model);
//     } else {
//       // remove
//       addContributors(model);
//     }
//     contributorAccountModel = [];
//     for (AccountModel candidateAccountModel in contributorCandidate) {
//       if (eventContributoIds.contains(candidateAccountModel.id!)) {
//         contributorAccountModel.add(candidateAccountModel);
//       }
//     }
//     notifyListeners();
//   }

//   void updateTitle(String newTitle) {
//     eventModel.title = newTitle;
//     notifyListeners();
//   }

//   String? titleValidator(value) {
//     return title.isEmpty ? '不可為空' : null;
//   }

//   void updateIntroduction(String newIntro) {
//     eventModel.introduction = newIntro;
//     notifyListeners();
//   }

//   String? introductionValidator(value) {
//     return introduction.isEmpty ? '不可為空' : null;
//   }

//   void updateStartTime(DateTime newStart) {
//     eventModel.startTime = newStart;
//     if (eventModel.startTime.isAfter(eventModel.endTime)) {
//       DateTime temp = eventModel.startTime;
//       eventModel.startTime = eventModel.endTime;
//       eventModel.endTime = temp;
//     }
//     notifyListeners();
//   }

//   void updateEndTime(DateTime newEnd) {
//     eventModel.endTime = newEnd;
//     if (eventModel.startTime.isAfter(eventModel.endTime)) {
//       DateTime temp = eventModel.startTime;
//       eventModel.startTime = eventModel.endTime;
//       eventModel.endTime = temp;
//     }
//     notifyListeners();
//   }

//   void addContributors(AccountModel newContributor) {
//     eventModel.contributorIds.add(newContributor.id!);
//     debugPrint(eventModel.contributorIds.toString());
//     // contributorAccountModel.add(newContributor);
//     notifyListeners();
//   }

//   void removeContributors(AccountModel removedContributor) {
//     eventModel.contributorIds.remove(removedContributor.id!);
//     debugPrint(eventModel.contributorIds.toString());
//     // contributorAccountModel.remove(removedContributor);
//     notifyListeners();
//   }

//   void initializeNewObject(
//       {required AccountModel creatorAccount,
//       required AccountModel ownerAccount}) {
//     // event.ownerAccount = ownerAccount;
//     creatorAccount = creatorAccount;
//     // debugPrint('owner ${this.ownerAccount.id}');
//     debugPrint('ownerAccount al ${ownerAccount.associateEntityAccount.length}');
//     // if(T.runtimeType == EventModel){
//       // model = EventModel(
//       //     startTime: DateTime.now(),
//       //     endTime: DateTime.now().add(const Duration(hours: 1)),
//       //     title: '事件標題',
//       //     introduction: '事件介紹',
//       //     contributorIds: [creatorAccount.id!]);

//     // }
//     if (T.runtimeType == MissionModel) {

//     }
//     eventModel = 
//     contributorAccountModel.add(creatorAccount);
//     eventModel.ownerAccount = ownerAccount;
//     forUser = eventOwnerAccount.id! == creatorAccount.id!;
//     notifyListeners();
//   }

//   Future<void> initializeDisplayEvent(
//       {required EventModel model, required AccountModel user}) async {
//     isLoading = true;
//     eventModel = model;
//     creatorAccount = user;
//     // ownerAccount = eventModel.ownerAccount;
//     forUser = eventOwnerAccount.id! == creatorAccount.id!;
//     notifyListeners();
//     // eventContributoIds.add(eventOwnerAccount.id!);
//     // debugPrint('ownerAccount ${eventModel.ownerAccount.nickname.toString()}');
//     // debugPrint('ownerAccount ${eventModel.ownerAccount.associateEntityId.toString()}');
//     // debugPrint(forUser.toString());
//     // debugPrint(eventModel.associateEntityAccount.toString());
//     // debugPrint(eventModel.contributorIds.toString());
//     eventOwnerAccount.associateEntityAccount = [];
//     if (isforUser == false) {
//       // get all event contributor account Profile from owner Account model associate list
//       for (String associationEntityId
//           in eventModel.ownerAccount.associateEntityId) {
//         eventModel.ownerAccount.associateEntityAccount.add(
//             await DatabaseService(ownerUid: associationEntityId, forUser: false)
//                 .getAccount());
//       }
//       for (AccountModel candidateAccountModel in contributorCandidate) {
//         if (eventContributoIds.contains(candidateAccountModel.id!)) {
//           contributorAccountModel.add(candidateAccountModel);
//         }
//       }
//       debugPrint(contributorAccountModel.length.toString());
//       // for (String contributorId in eventContributoIds) {
//       //   contributorAccountModel
//       //       .add(await DatabaseService(ownerUid: contributorId).getAccount());
//       // }
//     } else {
//       contributorAccountModel.add(creatorAccount);
//       eventOwnerAccount.associateEntityAccount.add(creatorAccount);
//     }
//     isLoading = false;
//     notifyListeners();
//   }

//   Future<bool> onSave() async {
//     debugPrint("setting mode $settingMode");
//     if (title.isEmpty ||
//         introduction.isEmpty ||
//         startTime.isAfter(endTime) ||
//         endTime.isBefore(DateTime.now())) {
//       return false;
//     }
//     if (settingMode == SettingMode.create) {
//       await createEvent();
//     } else if (settingMode == SettingMode.edit) {
//       await editEvent();
//     }
//     return true;
//   }

//   String errorMessage() {
//     if (title.isEmpty) {
//       return 'Title 不能為空';
//     } else if (introduction.isEmpty) {
//       return 'Introduction 不能為空';
//     } else if (startTime.isAfter(endTime)) {
//       return '開始時間在結束時間之後';
//     } else if (endTime.isBefore(DateTime.now())) {
//       return '結束時間不可在現在時間之前';
//     } else {
//       return 'unknown error';
//     }
//   }

//   String getTimerCounter() {
//     // DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
//     // String formatted = formatter.format(DateTime.now());
//     String output = "";
//     Duration duration;
//     // final endDate = DateTime(2023, 4, 18, 9, 30, 0);
//     final currentTime = DateTime.now();
//     if (currentTime.isBefore(startTime)) {
//       output = '即將到來-還有';
//       duration = startTime.difference(currentTime);
//     } else if (currentTime.isAfter(startTime) &&
//         currentTime.isBefore(endTime)) {
//       output = '距離結束-尚餘';
//       duration = endTime.difference(currentTime);
//     } else {
//       return '活動已結束';
//     }
//     final days = duration.inDays.toString();
//     final hours = (duration.inHours % 24).toString();
//     final minutes = (duration.inMinutes % 60).toString();
//     final seconds = (duration.inSeconds % 60).toString();
//     return '$output ${days.padLeft(2, '0')} D ${hours.padLeft(2, '0')} H ${minutes.padLeft(2, '0')} M ${seconds.padLeft(2, '0')} S';
//   }

//   // Stream<DateTime> currentTimeStream = Stream<DateTime>.periodic(
//   //   const Duration(seconds: 1),
//   //   (_) => DateTime.now(),
//   // );
//   Future<void> createEvent() async {
//     // Create event with eventData
//     // Add account profile id into contributorIds
//     // eventModel.contributorIds.add(creatorAccount.id!);
//     debugPrint("on save ${eventModel.contributorIds.toString()}");
//     // debugPrint(eventModel.contributorIds.toString());
//     await DatabaseService(ownerUid: eventOwnerAccount.id!, forUser: false)
//         .setEvent(event: eventModel);
//     notifyListeners();
//   }

//   Future<void> editEvent() async {
//     // edit event with eventData
//     debugPrint("on save ${eventModel.contributorIds.toString()}");
//     await DatabaseService(
//             ownerUid: forUser ? AuthService().getUid() : eventOwnerAccount.id!,
//             forUser: forUser)
//         .setEvent(event: eventModel);
//   }

//   Future<void> deleteEvent() async {
//     await DatabaseService(
//             ownerUid: forUser ? AuthService().getUid() : eventOwnerAccount.id!,
//             forUser: forUser)
//         .deleteEvent(eventModel);
//     notifyListeners();
//   }
// }
