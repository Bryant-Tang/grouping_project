// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:grouping_project/model/auth/account_model.dart';
// import 'package:grouping_project/model/workspace/workspace_model_lib.dart';
// import 'package:grouping_project/service/auth/auth_service.dart';
// // import 'package:grouping_project/model/model_lib.dart';
// // import 'package:grouping_project/service/service_lib.dart';

// class WorkspaceDashBoardViewModel extends ChangeNotifier {
//   // Page View Switch
//   int _selectedPageIndex = 0;
//   int overViewIndex = 0;
//   int get selectedIndex => _selectedPageIndex;
//   int get overView => overViewIndex;
//   bool get isPersonalAccount => personalprofileData.id == accountProfileData.id;
//   // Account model data from uid
//   AccountModel personalprofileData = AccountModel(accountId: "-1");
//   // Account model data from account
//   AccountModel accountProfileData = AccountModel(accountId: "-1");
//   List<MissionModel> dashboardMissionList = [];
//   List<EventModel> dashboardEventList = [];
//   AccountModel get accountProfile => accountProfileData;
//   AccountModel get userProfile => personalprofileData;
//   List<EventModel> get events {
//     if (isPersonalAccount) {
//       // debugPrint('get my event, user ${personalprofileData.id}');
//       // for (EventModel event in dashboardEventList) {
//       //   debugPrint(event.title);
//       //   debugPrint(event.contributorIds.toString());
//       // }
//       return List.from(dashboardEventList.where(
//           (event) => event.contributorIds.contains(personalprofileData.id)));
//     }
//     // debugPrint(dashboardEventList.length.toString());
//     return dashboardEventList;
//   }

//   List<MissionModel> get missions {
//     // debugPrint(dashboardMissionList.length.toString());
//     if (isPersonalAccount) {
//       // debugPrint('get my missions, user ${personalprofileData.id}');
//       // for (MissionModel mission in dashboardMissionList) {
//       //   debugPrint(mission.title);
//       //   debugPrint(mission.contributorIds.toString());
//       // }
//       return List.from(dashboardMissionList.where(
//           (mission) => mission.contributorIds.contains(personalprofileData.id)));
//       // for()
//       // // debugPrint(dashboardMissionList.length.toString());
//       // return List.generate(
//       //     indexs.length, (index) => dashboardMissionList[index]);
//     }
//     // debugPrint(dashboardMissionList.length.toString());
//     return dashboardMissionList;
//   }

//   int get dashboardEventNumber {
//     if (isPersonalAccount) {
//       final indexs = dashboardEventList.where(
//           (event) => event.contributorIds.contains(personalprofileData.id));
//       // debugPrint(dashboardEventList.length.toString());
//       return indexs.length;
//     }
//     // debugPrint(dashboardEventList.length.toString());
//     return dashboardEventList.length;
//   }

//   int get dashboardeMissionNumber {
//     if (isPersonalAccount) {
//       final indexs = dashboardMissionList.where(
//           (event) => event.contributorIds.contains(personalprofileData.id));
//       // debugPrint(dashboardEventList.length.toString());
//       return indexs.length;
//     }
//     // debugPrint(dashboardEventList.length.toString());
//     return dashboardMissionList.length;
//   }

//   String get workspaceName => accountProfileData.nickname;
//   String get introduction => accountProfileData.introduction;
//   String get slogan => accountProfileData.slogan;
//   String get realName => accountProfileData.name;
//   Uint8List get profileImage => accountProfileData.photo;
//   List<AccountTag> get tags => accountProfileData.tags;

//   bool isLoading = false;
//   List<AccountModel> get allGroupProfile =>
//       List.from(personalprofileData.associateEntityAccount)
//         ..insert(0, personalprofileData);

//   void switchGroup(AccountModel profile) {
//     // debugPrint("SWITCH");
//     accountProfileData = profile;
//     _selectedPageIndex = 0;
//     overViewIndex = 0;
//     getAllData();
//     notifyListeners();
//   }

//   void updateSelectedIndex(int index) {
//     // debugPrint(index.toString());
//     _selectedPageIndex = index;
//     notifyListeners();
//   }

//   void updateOverViewIndex(int index) {
//     // debugPrint(index.toString());
//     overViewIndex = index;
//     notifyListeners();
//   }

//   Future<void> signOut() async {
//     isLoading = true;
//     notifyListeners();
//     await AuthService().signOut();
//     isLoading = false;
//     notifyListeners();
//   }

//   Future<void> addGroupViaQR(
//       String qrCode, AccountModel groupAccountModel) async {
//     if (qrCode != "") {
//       // accountProfileData.addEntity(qrCode);
//       personalprofileData.addEntity(qrCode);
//       isLoading = true;
//       notifyListeners();
//       debugPrint(groupAccountModel.id);
//       groupAccountModel.addEntity(personalprofileData.id!);
//       await DatabaseService(ownerUid: qrCode, forUser: false)
//           .setAccount(account: groupAccountModel);
//       await DatabaseService(ownerUid: AuthService().getUid(), forUser: true)
//           .setAccount(account: personalprofileData);
//       if (isPersonalAccount) {
//         accountProfileData = personalprofileData;
//       }
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> updateUserAccount() async {
//     isLoading = true;
//     notifyListeners();
//     personalprofileData =
//         await DatabaseService(ownerUid: AuthService().getUid(), forUser: true)
//             .getAccount();
//     if (isPersonalAccount) {
//       accountProfileData = personalprofileData;
//     }
//     isLoading = false;
//     notifyListeners();
//   }

//   Future<void> getAllData() async {
//     isLoading = true;
//     notifyListeners();
//     debugPrint("is Persoanl worksapce $isPersonalAccount");
//     try {
//       if (accountProfileData.id == "-1") {
//         final personalDatabase =
//             DatabaseService(ownerUid: AuthService().getUid());
//         personalprofileData = await personalDatabase.getAccount();
//         accountProfileData = personalprofileData;
//         debugPrint(
//             personalprofileData.associateEntityAccount.length.toString());
//       }
//       final accountDatabase = DatabaseService(
//           ownerUid: isPersonalAccount
//               ? AuthService().getUid()
//               : accountProfileData.id as String,
//           forUser: isPersonalAccount);
//       accountProfileData = await accountDatabase.getAccount();
//       debugPrint(
//           'associateEntityAccount ${accountProfileData.associateEntityAccount.length}');
//       // personalprofileData = await personalDatabase.getAccount()
//       dashboardEventList = [];
//       dashboardMissionList = [];
//       dashboardEventList = await accountDatabase.getAllEvent();
//       dashboardMissionList = await accountDatabase.getAllMission();
//       if (isPersonalAccount) {
//         personalprofileData = accountProfileData;
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     } // 傳送資料
//     isLoading = false;
//     notifyListeners();
//   }
// }