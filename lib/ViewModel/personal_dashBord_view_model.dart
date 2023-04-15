import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouping_project/model/data_controller.dart';
import 'package:grouping_project/model/profile_model.dart';

class PersonalDashboardViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  ProfileModel profile = ProfileModel();
  String get userName => profile.nickname ?? "";
  File? get profileImage => profile.photo;
  bool isLoding = false;
  void updateSelectedIndex(int index) {
    debugPrint(index.toString());
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> updateProfile() async {
    isLoding = true;
    notifyListeners();
    try {
      profile = await DataController()
          .download(dataTypeToGet: profile, dataId: profile.id!);
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoding = false;
    notifyListeners();
  }
}
