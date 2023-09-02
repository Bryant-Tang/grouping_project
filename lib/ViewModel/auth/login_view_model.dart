// import 'package:flutter/material.dart';
// import 'package:grouping_project/View/components/state.dart';
// import 'package:grouping_project/model/auth/auth_model_lib.dart';

// class LoginViewModel extends ChangeNotifier {
//   // final AuthService authService = AuthService();
//   LoginModel passwordLoginModel = LoginModel();

//   String get password => passwordLoginModel.password;
//   String get email => passwordLoginModel.email;
//   bool get isEmailValid => passwordLoginModel.isEmailValid;
//   bool get isPasswordValid => passwordLoginModel.isPasswordValid;
//   bool get isFormValid => passwordLoginModel.isFormValid;
//   bool isLoading = false;
//   LoginState loginState = LoginState.loginFaild;

//   void updateEmail(String value) {
//     passwordLoginModel.validateEmail(value);
//     notifyListeners();
//   }

//   void updatePassword(String value) {
//     passwordLoginModel.validatePassword(value);
//     // debugPrint("Password: $value");
//     notifyListeners();
//   }

//   String? emailValidator(value) {
//     return isEmailValid ? null : "請輸入正確的信箱";
//   }

//   String? passwordValidator(value) {
//     return isPasswordValid ? null : "請輸入正確的密碼";
//   }

//   Future<void> onFormPasswordLogin() async {
//     // debugPrint("登入測試");
//     // debugPrint("Email: $email , Password: $password");
//     try {
//       isLoading = true;
//       notifyListeners();
//       var result = await passwordLoginModel.passwordLogin(email, password);
//       loginState = result;
//       isLoading = false;
//       debugPrint(loginState.toString());
//       notifyListeners();
//     } catch (e) {
//       // Handle any errors that occur during the login process
//       debugPrint(e.toString());
//       loginState = LoginState.loginFaild;
//       isLoading = false;
//       notifyListeners();
//     }
//     // debugPrint(loginState.toString());
//   }

//   Future<void> onThirdPartyLogin(String name) async {
//     // debugPrint("登入測試");
//     // debugPrint("Email: $email , Password: $password");
//     try {
//       isLoading = true;
//       notifyListeners();
//       var result = await passwordLoginModel.thirdPartyLogin(name);
//       loginState = result;
//       isLoading = false;
//       // debugPrint(loginState.toString());
//       notifyListeners();
//     } catch (e) {
//       // Handle any errors that occur during the login process
//       debugPrint(e.toString());
//       loginState = LoginState.loginFaild;
//       isLoading = false;
//       notifyListeners();
//     }
//     // debugPrint(loginState.toString());
//   }
// }
