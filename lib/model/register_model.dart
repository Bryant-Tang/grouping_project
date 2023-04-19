import 'package:flutter/material.dart';
import 'package:grouping_project/VM/state.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/model/user_model.dart';
import 'package:grouping_project/service/auth_service.dart';

class RegisterModel {
  String password = "";
  String passwordConfirm = "";
  String userName = "";
  String email = "";
  bool isPasswordValid = false;
  bool isPasswordConfirmValid = false;
  bool isUserNameValid = false;
  ProfileModel get tempProfile => ProfileModel(
        nickname: userName,
        email: email,
      );
  void updateEmail(String value) {
    email = value;
  }

  void updatePasswordConfirm(String value) {
    passwordConfirm = value;
    isPasswordConfirmValid = password == passwordConfirm;
  }

  void updateUserName(String value) {
    userName = value;
    isUserNameValid = userName.isNotEmpty;
  }

  void updatePassword(String value) {
    password = value;
    isPasswordValid = password.length > 6;
  }

  Future<RegisterState> register(email, password, userName) async {
    try {
      // debugPrint('註冊信箱: $email\n使用者密碼: $password');
      AuthService authService = AuthService();
      await authService.emailSignUp(email, password);
      // debugPrint('註冊信箱: $email\n使用者密碼: $password 註冊成功');
      // final ProfileModel user = ProfileModel(nickname: userName, email: email);
      await DataController()
          .createUser(userProfile: tempProfile)
          .then((value) => {debugPrint('upload successfully')})
          .catchError((error) {
        debugPrint(error.toString());
      });
      return RegisterState.success;
    } catch (error) {
      // debugPrint('註冊信箱: $email\n使用者密碼: $password 註冊失敗');
      // debugPrint(error.toString());
      return RegisterState.faild;
    }
  }
}
