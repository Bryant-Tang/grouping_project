import 'package:flutter/material.dart';
import 'package:grouping_project/View/components/state.dart';
import 'package:grouping_project/exceptions/auth_service_exceptions.dart';
import 'package:grouping_project/service/auth/auth_service.dart';
// import 'package:grouping_project/VM/state.dart';

class LoginModel {
  String email = "";
  String password = "";
  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool get isFormValid => isEmailValid && isPasswordValid;
  // final AuthService authService = AuthService();

  void validateEmail(String value) {
    // isEmailValid = EmailValidator.validate(value);
    isEmailValid = value.isNotEmpty;
    email = value;
  }

  void validatePassword(String value) {
    isPasswordValid = value.length >= 6;
    password = value;
  }

  Future<LoginState> passwordLogin(String email, String password) async {
    try {
      // TODO: add email login method
      AuthService authService = AuthService();
      await authService.signIn(account: email, password: password);

      return LoginState.loginSuccess;
    } catch (error) {
      // debugPrint('In func. passwordLogin: $error');
      switch ((error as AuthServiceException).code) {
        case 'wrong_password':
          debugPrint('wrong_password');
          return LoginState.wrongPassword;
        case 'user_does_not_exist':
          debugPrint('user_does_not_exist');
          return LoginState.userNotFound;
        default:
          debugPrint(error.toString());
          return LoginState.loginFail;
      }
    }
  }

  Future<LoginState> thirdPartyLogin(String name) async {
    try {
      AuthService authService = AuthService();
      await authService.thridPartyLogin(name);
      // TODO: add email login method
    } catch (e) {
      debugPrint(e.toString());
      return LoginState.loginFail;
    }
    // debugPrint("login successfully");
    return LoginState.loginSuccess;
  }
}
