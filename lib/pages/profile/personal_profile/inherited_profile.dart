import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';

class InheritedProfile extends InheritedWidget {
  final ProfileModel profile;
  // callback function to update profile
  final Function(ProfileModel) updateProfile;
  const InheritedProfile(
      {super.key, required this.profile, required this.updateProfile, required Widget child})
      : super(child: child);

  static InheritedProfile? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedProfile>();
  }

  @override
  bool updateShouldNotify(InheritedProfile oldWidget) {
    return oldWidget.profile != profile;
  }
}
