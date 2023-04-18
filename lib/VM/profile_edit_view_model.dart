import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouping_project/VM/state.dart';
import 'package:grouping_project/model/model_lib.dart';

class ProfileEditViewModel extends ChangeNotifier {
  ProfileModel profile = ProfileModel();
  bool isLoading = false;
  int currentPageIndex = 0;
  String get realName => profile.name ?? "";
  String get userName => profile.nickname = "Unknown";
  String get slogan => profile.slogan ?? "";
  String get introduction => profile.introduction ?? "";
  File? get profileImage => profile.photo;

  List<ProfileTag> get tags => profile.tags ?? [];
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

  void toggleEditMode() {
    tagEditMode = tagEditMode == TagEditMode.create
        ? TagEditMode.edit
        : TagEditMode.create;
    notifyListeners();
  }

  Future<void> init() async {
    isLoading = true;
    notifyListeners();
    profile = await DataController()
        .download(dataTypeToGet: profile, dataId: profile.id!);
    isLoading = false;
    notifyListeners();
  }

  Future<void> upload() async {
    isLoading = true;
    notifyListeners();
    try {
      await DataController().upload(uploadData: profile);
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}
