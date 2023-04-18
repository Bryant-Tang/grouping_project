import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouping_project/VM/state.dart';
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
  TagEditMode tagEditMode = TagEditMode.create;
  int maximunTagNumber = 4;

  void onPageChange(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

  void updateRealName(String realName) {
    profile.name = realName;
    notifyListeners();
  }

  void updateUserName(String userName) {
    profile.name = userName;
    notifyListeners();
  }

  void updateSlogan(String slogan) {
    profile.slogan = slogan;
    notifyListeners();
  }

  void updateIntroduction(String introduction) {
    profile.introduction = introduction;
    notifyListeners();
  }

  void updateTags(List<ProfileTag> tags) {
    profile.tags = tags;
    notifyListeners();
  }

  void createNewTag(ProfileTag tag) {
    profile.tags = (profile.tags ?? [])..add(tag);
    notifyListeners();
  }

  void editTag(ProfileTag? newTag, int index) {
    if (newTag != null) {
      profile.tags![index] = newTag;
      notifyListeners();
    }
  }

  void deleteTag(int index) {
    profile.tags!.removeAt(index);
    notifyListeners();
  }

  void updateProfileImage(File imageFile) {
    debugPrint(imageFile.path);
    profile.photo = imageFile;
    notifyListeners();
  }

  void switchTagEditMode(TagEditMode mode) {
    tagEditMode = mode;
    notifyListeners();
  }

  bool toggleSelected(bool value, int index) {
    debugPrint(value.toString());
    isSelected[index] = value;
    int count = isSelected.where((e) => e == true).length;
    debugPrint(count.toString());
    if (count > 4) {
      isSelected[index] = !value;
      notifyListeners();
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  bool isTagSelected(String value) {
    return isSelected[labelTags.indexOf(value)];
  }

  void init() {
    isSelected = List.generate(labelTags.length, (index) => false);
    notifyListeners();
  }

  Future<void> createGroup() async {
    isLoading = true;
    notifyListeners();
    try {
      await DataController().createGroup(groupProfile: profile).then((value) {
        debugPrint('$value 小組建立成功');
      }).catchError((error) {
        debugPrint(error.toString());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}
