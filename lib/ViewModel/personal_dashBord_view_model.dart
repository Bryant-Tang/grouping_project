import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouping_project/model/data_controller.dart';
import 'package:grouping_project/model/profile_model.dart';
import 'package:grouping_project/service/auth_service.dart';

class PersonalDashboardViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  ProfileModel profile = ProfileModel();
  String get userName => profile.nickname ?? "";
  File? get profileImage => profile.photo;
  bool isLoading = false;
  void updateSelectedIndex(int index) {
    debugPrint(index.toString());
    _selectedIndex = index;
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
      profile = await DataController()
          .download(dataTypeToGet: profile, dataId: profile.id!);
      // debugPrint(profile.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}
