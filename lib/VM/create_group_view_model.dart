// import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:grouping_project/VM/state.dart';
import 'package:grouping_project/model/model_lib.dart';

class CreateGroupViewModel extends ChangeNotifier {
  ProfileModel profile = ProfileModel();
  bool isLoading = false;
  int currentPageIndex = 0;
  String get realName => profile.name ?? "";
  String get userName => profile.nickname = "Unknown";
  String get introduction => profile.introduction ?? "";
  File? get profileImage => profile.photo;
  List<ProfileTag> get tags => profile.tags ?? [];
  // TODO: 需要移動到Model嗎
  final List<String> labelTags = [
    "#社團",
    "#課程",
    "#打工",
    "#工作小組",
    "#程式學習",
    "#專題報告",
    "#讀書會",
    "#期末報告",
    "#其他",
    "#臨時小組"
  ];
  List<bool> isSelected = [];
  List<ProfileTag> selectTag = [];
  int maximunTagNumber = 4;
  void onPageChange(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

  void updateUserName(String userName) {
    profile.name = userName;
    notifyListeners();
  }
  String? groupNameValidator(String? value){
    return value == null || value.isEmpty ? '請輸入小組名稱' : null;
  }
  void updateSlogan(String slogan) {
    profile.slogan = slogan;
    notifyListeners();
  }

  void updateIntroduction(String introduction) {
    profile.introduction = introduction;
    notifyListeners();
  }
  String? groupIntroductionValidator(String? value) {
    return value == null || value.isEmpty ? '請輸入小組介紹' : null;
  }

  void updateProfileImage(File imageFile) {
    profile.photo = imageFile;
    notifyListeners();
  }

  bool toggleSelected(bool value, int index) {
    isSelected[index] = value;
    int count = isSelected.where((e) => e == true).length;
    if (count > 4) {
      isSelected[index] = !value;
      notifyListeners();
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }
  String? groupTagValidator(String? value) {
    return isSelected.where((e) => e == true).isEmpty ? '請至少選則一個標籤' : null;
  }

  void init() {
    isSelected = List.generate(labelTags.length, (index) => false);
    notifyListeners();
  }

  Future<void> createGroup() async {
    isLoading = true;
    notifyListeners();
    try {
      final selectedIndex = isSelected.where((e) => e == true);
      profile.tags = List.generate(
        selectedIndex.length, (index) 
          => ProfileTag(tag: labelTags[index],content: labelTags[index]));
      final groupId = await DataController().createGroup(groupProfile: profile);
      debugPrint('create new group id : $groupId');
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}
