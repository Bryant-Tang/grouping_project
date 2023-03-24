import 'package:flutter/material.dart';
import 'package:grouping_project/model/user_model.dart';

class SignUpDataModel {
  String password = "";
  String userName = "";
  String email = "";
  SignUpDataModel({this.email = "", this.password = "", this.userName = ""});
}

class UserData extends InheritedWidget {
  final UserModel data;
  const UserData({
    Key? key,
    required this.data,
    required child,
  }) : super(key: key, child: child);
  static UserData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserData>();
  }

  @override
  bool updateShouldNotify(UserData oldWidget) {
    return oldWidget.data != data;
  }
}
