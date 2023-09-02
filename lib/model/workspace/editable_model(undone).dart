// TODO: unused but perhaps can be reused file
import 'package:flutter/material.dart';
// import 'dart:ui';
// import 'package:grouping_project/service/service_lib.dart';
// import 'package:intl/intl.dart';

// enum SettingState {
//   loading,
//   success,
//   faild,
// }

// abstract class EditableModel {
//   AccountModel ownerAccount = AccountModel();
  
//   List<String> contributorIds = [];
//   bool isLoading = true;
//   SettingState state = SettingState.loading;
//   bool forUser = true;

//   String title = "標題";
//   String introduction = "介紹";
//   bool get isTitleValid => title.isNotEmpty;
//   bool get isIntroductionValid => introduction.isNotEmpty;

//   DateTime startTime = DateTime.now();
//   DateTime deadlineTime = DateTime.now();
//   DateFormat dataformat = DateFormat('h:mm a, MMM d, y');
//   String get formattedStartTime => dataformat.format(startTime);
//   String get formattedDeadlineTime => dataformat.format(deadlineTime);

//   bool onTime() {
//     final currentTime = DateTime.now();
//     return currentTime.isAfter(startTime) && currentTime.isBefore(deadlineTime);
//   }

//   Color color = const Color(0xFFFFFFFF);

//   void updateTitle(String newTitle) {
//     title = newTitle;
//   }

//   void updateIntroduction(String newIntro) {
//     introduction = newIntro;
//   }

//   void updateStartTime(DateTime newTime) {
//     startTime = newTime;
//   }

//   void updateDeadlineTime(DateTime newTime) {
//     deadlineTime = newTime;
//   }

//   bool isContributors(String accountId) {
//     return contributorIds.contains(accountId);
//   }

//   void updateContibutor(String accountId) {
//     isContributors(accountId)
//         ? contributorIds.remove(accountId)
//         : contributorIds.add(accountId);
//   }

//   Future<void> onCreate();
//   Future<void> onSave();
//   Future<void> onDelete();
// }

// class MissionSettingModel extends EditableModel {
//   MissionModel? mission;
//   MissionSettingModel.create({required AccountModel ownerAccount,required bool forUser}) {
//     title = "";
//     introduction = "";
//     startTime = DateTime.now();
//     deadlineTime = DateTime.now().add(const Duration(hours: 1));
//     contributorIds = [ownerAccount.id!];
//     this.ownerAccount = ownerAccount;
//   }
//   MissionSettingModel.from({required MissionModel mission}) {
//     title = mission.title;
//     introduction = mission.introduction;
//     deadlineTime = mission.deadline;
//     ownerAccount = mission.ownerAccount;
//     contributorIds = mission.contributorIds;
//   }

//   @override
//   Future<void> onCreate() async {
//     // who create this mission?
//     final mission = MissionModel(
//       title: title,
//       introduction: introduction,
//       deadline: deadlineTime,
//       ownerAccount: ownerAccount,
//       contributorIds: contributorIds,
//     );
//     await DatabaseService(ownerUid: ownerAccount.id!, forUser: false)
//         .setMission(mission: mission);
//   }

//   @override
//   Future<void> onDelete() async {
//     // it is awere that why I need to delete whole mission by whole MissionModel
//     await DatabaseService(ownerUid: ownerAccount.id!, forUser: false)
//         .deleteMission(mission!);
//   }

//   @override
//   Future<void> onSave() async {
//     mission = MissionModel(
//       title: title,
//       introduction: introduction,
//       deadline: deadlineTime,
//       ownerAccount: ownerAccount,
//       contributorIds: contributorIds,
//     );
//     await DatabaseService(ownerUid: ownerAccount.id!, forUser: false)
//         .setMission(mission: mission!);
//   }
// }
