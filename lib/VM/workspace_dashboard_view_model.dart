import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/service_lib.dart';

class WorkspaceDashBoardViewModel extends ChangeNotifier {

  int _selectedPageIndex = 0;
  int overViewIndex = 0;
  int get selectedIndex => _selectedPageIndex;
  int get overView => overViewIndex;

  AccountModel profileData = AccountModel();
  List<MissionModel> dashboardMissionList = [];
  List<EventModel> dashboardEventList = [];
  AccountModel get profile => profileData;
  List<MissionModel> get missions => dashboardMissionList;
  List<EventModel> get events => dashboardEventList;

  String get userName => profile.nickname;
  String get realName => profile.name;
  String get slogan => profile.slogan;
  String get introduction => profile.introduction;
  Uint8List get profileImage => profile.photo;
  List<AccountTag> get tags => profile.tags;

  bool isLoading = false;
  List<AccountModel> get allGroupProfile => profile.associateEntityAccount;
  void switchGroup() {
    debugPrint("SWITCH");
  }

  void updateSelectedIndex(int index) {
    debugPrint(index.toString());
    _selectedPageIndex = index;
    notifyListeners();
  }

  void updateOverViewIndex(int index) {
    debugPrint(index.toString());
    overViewIndex = index;
    notifyListeners();
  }

  Future<void> signOut() async {
    isLoading = true;
    notifyListeners();
    await AuthService().signOut();
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile() async {
    isLoading = true;
    final uid = AuthService().getUid();
    final db = DatabaseService(ownerUid: uid);

    notifyListeners();
    try {
      profileData = await db.getAccount();
      // eventList = await db.getAllEvent();
      // missionList = await db.getAllMission();
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    debugPrint(profileData.associateEntityId.toString());
    notifyListeners();
  }

  Future<void> getAllData() async {
    isLoading = true;
    final uid = AuthService().getUid();
    final db = DatabaseService(ownerUid: uid);
    notifyListeners();
    try {
      profileData = await db.getAccount();
      debugPrint(profile.associateEntityAccount.toString());
      dashboardEventList = await db.getAllEvent();
      dashboardMissionList = await db.getAllMission();
    } catch (e) {
      debugPrint(e.toString());
    } // 傳送資料
    isLoading = false;
    notifyListeners();
  }
}
