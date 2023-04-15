// ignore_for_file: use_build_context_synchronously

import 'package:grouping_project/ViewModel/login_view_model.dart';
import 'package:grouping_project/components/button/auth_button.dart';
import 'package:grouping_project/pages/auth/sign_up.dart';
import 'package:grouping_project/model/password_register_model.dart';
import 'package:grouping_project/pages/home/home_page/base_page.dart';
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
                        .map((name) => 
                              AuthButton(
                                fileName: "$name.png",
                                name: name,
                                onPressed: () async {
                                  await loginViewModel.onThirdPartyLogin(name);
                                  if(loginViewModel.loginState == LoginState.loginSuccess){
                                      Navigator.pushReplacement( context,
                                        MaterialPageRoute( builder: (context) => const BasePage()));
                                  }
                                }
                              ))
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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void showBanner(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(errorMessage),
      duration: const Duration(seconds: 2),
    ));
  }
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
                        showBanner('登入成功');
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BasePage()));
                          break;
                        case LoginState.loginFaild:
                          showBanner('登入失敗');
                          break;
                        case LoginState.userNotFound:
                          showBanner('沒有此帳號');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage(
                                    registeredEmail: loginViewModel.email,
                                  )));
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


