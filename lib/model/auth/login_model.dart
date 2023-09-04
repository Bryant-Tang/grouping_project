import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/View/components/state.dart';
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
      // debugPrint(error.toString());
      switch ((error as FirebaseAuthException).code) {
        case 'wrong-password':
          debugPrint('user-not-found');
          return LoginState.wrongPassword;
        case 'user-not-found':
          debugPrint('user-not-found');
          return LoginState.userNotFound;
        default:
          debugPrint(error.toString());
          return LoginState.loginFail;
      }
    }
  }

  Future<LoginState> thirdPartyLogin(String name) async {
    try {
      // final result = await authService.thridPartyLogin(name);
      // TODO: add email login method
      final result = null;
      if (result == null) {
        return LoginState.loginFail;
      }
    } catch (e) {
      debugPrint(e.toString());
      return LoginState.loginFail;
    }
    // debugPrint("login successfully");
    return LoginState.loginSuccess;
  }
}
