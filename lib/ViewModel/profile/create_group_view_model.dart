import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:grouping_project/model/auth/account_model.dart';
// import 'package:grouping_project/VM/state.dart';
// import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/service/service_lib.dart';

class CreateGroupViewModel extends ChangeNotifier {
  AccountModel profile = AccountModel();
  bool isLoading = false;
  int currentPageIndex = 0;
  String get realName => profile.name;
  String get userName => profile.nickname;
  String get introduction => profile.introduction;
  Uint8List get profileImage => profile.photo;
  List<AccountTag> get tags => profile.tags;
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
  Color randomColor() {
    final random = Random();
    return Color.fromARGB(
        255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
  }

  List<bool> isSelected = [];
  List<AccountTag> selectTag = [];
  int maximunTagNumber = 4;
  void onPageChange(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

  void updateUserName(String userName) {
    profile.name = userName;
    profile.nickname = userName;
    notifyListeners();
  }

  String? groupNameValidator(String? value) {
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

  void updateProfileImage(Uint8List imageFile) {
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
      final selectedIndex = isSelected.where((e) => e == true);
      profile.tags = List.generate(
          selectedIndex.length,
          (index) =>
              AccountTag(tag: labelTags[index], content: labelTags[index]));
      debugPrint(profile.tags.toString());
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
    final uid = AuthService().getUid(); // outh service uid
    final accountDatabase = DatabaseService(ownerUid: uid); // account db
    notifyListeners();
    try {
      // get user account profile
      final userAccountModel = await accountDatabase.getAccount();
      debugPrint(userAccountModel.associateEntityAccount.length.toString());
      // add user id to group profile entity
      profile.addEntity(userAccountModel.id!);
      debugPrint(profile.associateEntityAccount.length.toString());
      // get new group id
      final groupId = await accountDatabase.createGroupAccount();
      // debugPrint("group Id $groupId");
      // set group profile to group account db
      await DatabaseService(ownerUid: groupId, forUser: false).setAccount(
          account:
              profile.copyWith(accountId: groupId, color: randomColor().value));
      // add group id to user account profile entity
      userAccountModel.addEntity(groupId);
      // upload user account profile to user account db
      await accountDatabase.setAccount(account: userAccountModel);
      debugPrint('create new group id : $groupId');
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}
