import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/auth_service.dart';

class WorkspaceDashboardViewModel extends ChangeNotifier {
  int _selectedPageIndex = 0;
  int get selectedIndex => _selectedPageIndex;
  int overViewIndex = 0;
  int get overView => overViewIndex;

  ProfileModel profileData = ProfileModel();
  List<MissionModel> missionList = [];
  List<EventModel> eventList = [];

  ProfileModel get profile => profileData;
  List<MissionModel> get missions => missionList;
  List<EventModel> get events => eventList;

  String get userName => profile.nickname ?? "Unknown";
  String get realName => profile.name ?? "Unknown";
  String get slogan => profile.slogan ?? "";
  String get introduction => profile.introduction ?? "";
  File? get profileImage => profile.photo;
  List<ProfileTag> get tags => profile.tags ?? [];

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
    notifyListeners();
    try {
      profileData = await DataController()
          .download(dataTypeToGet: profile, dataId: profile.id!);
      // eventList =
      //     await DataController().downloadAll(dataTypeToGet: EventModel());
      // missionList =
      //     await DataController().downloadAll(dataTypeToGet: MissionModel());
      // debugPrint(profile.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    debugPrint(profileData.associateEntityId.toString());
    notifyListeners();
  }

  Future<void> getAllData() async {
    isLoading = true;
    notifyListeners();
    try {
      profileData = await DataController()
          .download(dataTypeToGet: profile, dataId: profile.id!);
      // for (dynamic groupId in profileData.associateEntityId ?? []) {
      //   ProfileModel groupProfile = await DataController()
      //       .download(dataTypeToGet: ProfileModel(), dataId: groupId);
      //   allGroupProfile.add(groupProfile);
      //   debugPrint(allGroupProfile.first.toString());
      // }
      debugPrint(profileData.associateEntityId.toString());
      eventList =
          await DataController().downloadAll(dataTypeToGet: EventModel());
      debugPrint(eventList.length.toString());
      // yield null;
      missionList =
          await DataController().downloadAll(dataTypeToGet: MissionModel());
      debugPrint(missionList.length.toString());
      // yield null;
    } catch (e) {
      debugPrint(e.toString());
    }
    // 傳送資料
    isLoading = false;
    notifyListeners();
  }
}
