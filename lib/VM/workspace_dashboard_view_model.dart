import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/service/service_lib.dart';

class WorkspaceDashboardViewModel extends ChangeNotifier {
  int _selectedPageIndex = 0;
  int get selectedIndex => _selectedPageIndex;
  int overViewIndex = 0;
  int get overView => overViewIndex;
  AccountModel profileData = AccountModel();
  List<MissionModel> missionList = [];
  List<EventModel> eventList = [];
  AccountModel get profile => profileData;
  List<MissionModel> get missions => missionList;
  List<EventModel> get events => eventList;

  String get userName => profile.nickname;
  String get realName => profile.name;
  String get slogan => profile.slogan;
  String get introduction => profile.introduction;
  Uint8List get profileImage => profile.photo;
  List<AccountTag> get tags => profile.tags;

  bool isLoading = false;
  List allGroupProfile = [
    // ProfileModel(
    //     name: "服務學習課程",
    //     color: 0xFF00417D,
    //     introduction: "python 程式教育課程小組",
    //     tags: ["#Python", "#程式基礎教育", "#工作"]
    //         .map((t) => ProfileTag(tag: t, content: t))
    //         .toList()),
    // ProfileModel(
    //     name: "服務學習課程",
    //     color: 0xFF993300,
    //     introduction: "python 程式教育課程小組",
    //     tags: ["#Python", "#程式基礎教育", "#工作"]
    //         .map((t) => ProfileTag(tag: t, content: t))
    //         .toList()),
    // ProfileModel(
    //     name: "服務學習課程",
    //     color: 0xFFFFB782,
    //     introduction: "python 程式教育課程小組",
    //     tags: ["#Python", "#程式基礎教育", "#工作"]
    //         .map((t) => ProfileTag(tag: t, content: t))
    //         .toList()),
  ];

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
      eventList = await db.getAllEvent();
      missionList = await db.getAllMission();
    } catch (e) {
      debugPrint(e.toString());
    }
    // 傳送資料
    isLoading = false;
    notifyListeners();
  }
}
