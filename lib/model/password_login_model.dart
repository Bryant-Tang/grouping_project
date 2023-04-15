import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/service/service_lib.dart';

class PasswordLoginFormModel {
  String email = "";
  String password = "";
  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool get isFormValid => isEmailValid && isPasswordValid;

  void validateEmail(String value) {
    // isEmailValid = EmailValidator.validate(value);
    isEmailValid = value.isNotEmpty;
    email = value;
  }

  void validatePassword(String value) {
    isPasswordValid = value.length >= 6;
    password = value;
  }

  Future<LoginState> submitLogin(String email, String password) async {
    final AuthService authService = AuthService();

    try {
      await authService.emailLogIn(email, password);
      // debugPrint("login successfully");
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
          return LoginState.loginFaild;
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

enum LoginState { 
  loginSuccess,
  loginFaild, 
  userNotFound, 
  wrongPassword,
}
