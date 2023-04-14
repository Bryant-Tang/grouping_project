import 'package:grouping_project/ViewModel/LoginViewModel.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/model/user_model.dart';
import 'package:grouping_project/pages/auth/sign_up.dart';
import 'package:grouping_project/pages/auth/user.dart';
import 'package:grouping_project/pages/home/home_page/base_page.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';
import 'package:provider/provider.dart';
import 'package:grouping_project/model/password_login_model.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final headLineText = "登入";
  final content = "已經辦理過 Grouping 帳號了嗎？\n連結其他帳號來取用 Grouping 的服務";
  final List<String> authButtonNameList = [
    "google",
    "github",
    "facebook",
  ];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, loginViewModel, _) => Scaffold(
          resizeToAvoidBottomInset: false,
          // backgroundColor: Colors.white,
          body: Container(
            padding: const EdgeInsets.fromLTRB(30.0, 120.0, 30.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                HeadlineWithContent(
                    headLineText: headLineText, content: content),
                const SizedBox(height: 50),
                _EmailForm(),
                const SizedBox(height: 50),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                        flex: 2,
                        child: Divider(
                          thickness: 4,
                        )),
                    Expanded(
                        flex: 3,
                        child: Text(
                          "連接其他帳號",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        )),
                    const Expanded(
                        flex: 2,
                        child: Divider(
                          thickness: 4,
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: authButtonNameList
                        .map((name) => AuthButton(
                            fileName: "$name.png",
                            name: name,
                            onPressed: () async {
                              AuthService authService = AuthService();
                              await authService
                                  .thridPartyLogin(name)
                                  .then((value) {
                                if (value != null) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BasePage()));
                                }
                              });
                            }))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailForm extends StatefulWidget {
  // final registered = false;
  @override
  State<_EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<_EmailForm> {
  final _formKey = GlobalKey<FormState>();
  // final AuthService authService = AuthService();
  // void checkUserInput(String email, String password) async {
  //   await authService
  //       .emailLogIn(userInputEmail, userInputPassword)
  //       .then((value) {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => const BasePage()));
  //   }).catchError((error) {
  //     // debugPrint(error.toString());
  //     switch (error.code) {
  //       case 'invalid-email':
  //         debugPrint('invalid-email');
  //         showErrorDialog('信箱格式錯誤', '請使用正確的信箱登入');
  //         break;
  //       case 'user-disabled':
  //         debugPrint('user-disabled');
  //         showErrorDialog('帳號認證錯誤', '無法使用$userInputEmail登入Grouping服務');
  //         break;
  //       case 'user-not-found':
  //         debugPrint('user-not-found');
  //         SignUpDataModel data = SignUpDataModel(email: email);
  //         Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => SignUpPage(data: data)));
  //         break;
  //       case 'wrong-password':
  //         showErrorDialog('密碼錯誤', '請確認帳號$userInputEmail密碼是否正確');
  //         break;
  //       default:
  //         debugPrint(error.toString());
  //     }
  //   });
  // }

  void showErrorDialog(String errorTitle, String errorMessage) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(errorTitle),
              content: Text(errorMessage),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('確認'),
                ),
              ],
            ));
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) => Form(
        key: _formKey,
        onChanged: () {
          loginViewModel.updateEmail(emailController.text);
          loginViewModel.updatePassword(passwordController.text);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: Theme.of(context).textTheme.labelLarge,
                prefixIcon: const Icon(Icons.mail),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: loginViewModel.emailValidator,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "password",
                labelStyle: Theme.of(context).textTheme.labelLarge,
                errorText: loginViewModel.loginState == LoginState.wrongPassword
                    ? '密碼錯誤'
                    : null,
                prefixIcon: const Icon(Icons.password),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: loginViewModel.passwordValidator,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await loginViewModel.onFormPasswordLogin();
                    if (!loginViewModel.isLoading) {
                      switch (loginViewModel.loginState) {
                        case LoginState.loginSuccess:
                          debugPrint('login successfully');
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BasePage()));
                          break;
                        case LoginState.loginFaild:
                          break;
                        case LoginState.userNotFound:
                          break;
                        case LoginState.wrongPassword:
                          break;
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                ),
                child: loginViewModel.isLoading
                    ? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      )
                    : Text(
                        "用此信箱登入",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                            ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final AuthService authService = AuthService();
  final String fileName;
  final String name;
  final void Function() onPressed;
  AuthButton({
    super.key,
    required this.fileName,
    required this.name,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: ElevatedButton(
          onPressed: () {
            onPressed();
          },
          style: ElevatedButton.styleFrom(
            // foregroundColor: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset(
                    "assets/icons/authIcon/$fileName",
                    width: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${name.toUpperCase()} 帳號登入",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
