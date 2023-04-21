import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:grouping_project/VM/state.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/service_lib.dart';

class ProfileEditViewModel extends ChangeNotifier {
  AccountModel profile = AccountModel();
  bool isLoading = false;
  int currentPageIndex = 0;
  String get realName => profile.name;
  String get userName => profile.nickname;
  String get slogan => profile.slogan;
  String get introduction => profile.introduction;
  Uint8List get profileImage => profile.photo;
  List<AccountTag> get tags => profile.tags;
  TagEditMode tagEditMode = TagEditMode.create;
  int maximunTagNumber = 4;

  set accountModel(AccountModel profile){
    profile = AccountModel();
  }

  void onPageChange(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

  void updateRealName(String realName) {
    profile.name = realName;
    notifyListeners();
  }

  void updateUserName(String userName) {
    profile.nickname = userName;
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

  void createNewTag(AccountTag tag) {
    profile.tags.add(tag);
    notifyListeners();
  }

  void editTag(AccountTag? newTag, int index) {
    if (newTag != null) {
      profile.tags[index] = newTag;
      notifyListeners();
    }
  }

  void deleteTag(int index) {
    profile.tags.removeAt(index);
    notifyListeners();
  }

  void updateProfileImage(Uint8List imageFile) {
    debugPrint(imageFile.toString());
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

  // Future<void> init() async {
  //   isLoading = true;
  //   final uid = AuthService().getUid();
  //   final db = DatabaseService(ownerUid: uid);
  //   notifyListeners();
  //   profile = await db.getAccount();
  //   isLoading = false;
  //   notifyListeners();
  // }

  Future<void> upload() async {
    isLoading = true;
    // final uid = AuthService().getUid();
    final db = DatabaseService(ownerUid: profile.id as String);
    notifyListeners();
    try {
      await db.setAccount(account: profile);
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}
