import 'package:grouping_project/model/user_model.dart';
import 'package:grouping_project/pages/auth/sign_up.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  final headLineText = "登入";
  final content = "已經辦理過 Grouping 帳號了嗎？\n連結其他帳號來取用 Grouping 的服務";
  final buttonUI = {
    "Apple": {"fileName": "apple.png", "name": "apple"},
    "Google": {"fileName": "google.png", "name": "google"},
    "Github": {"fileName": "github.png", "name": "github"},
  };
  List<Widget> buttonBuilder() {
    List<Widget> authButtonList = [];
    for (dynamic button in buttonUI.values) {
      authButtonList.add(AuthButton(
          fileName: button["fileName"],
          name: button["name"],
          onPressed: () async {
            AuthService authService = AuthService();
            UserModel? _userModel =
                await authService.thridPartyLogin(button["name"]);
          }));
    }
    return authButtonList;
  }

  @override
  State<LoginPage> createState() => _LogInState();
}

class _LogInState extends State<LoginPage> {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.fromLTRB(30.0, 150.0, 30.0, 100.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              HeadlineWithContent(
                  headLineText: widget.headLineText, content: widget.content),
              const SizedBox(height: 50),
              _EmailForm(),
              const SizedBox(height: 50),
              const HintTextWithLine(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(children: widget.buttonBuilder()),
              )
            ],
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
  final AuthService authService = AuthService();
  final emailInputBox = GroupingInputField(
      labelText: "Email", boxIcon: Icons.mail, boxColor: Colors.grey);
  final passwordInputBox = GroupingInputField(
      labelText: "password", boxIcon: Icons.password, boxColor: Colors.grey);
  String userInputEmail = "";
  String userInputPassword = "";
  UserModel? user;
  void updateState() async {
    setState(() {
      debugPrint("登入測試");
      userInputEmail = emailInputBox.inputText;
      userInputPassword = passwordInputBox.inputText;
      debugPrint("Email: $userInputEmail , Password: $userInputPassword");
    });
    user = await authService
        .emailLogIn(userInputEmail, userInputPassword)
        .onError((error, stackTrace) => throw UnimplementedError());
  }

  void _onSubmit() {
    updateState();
    // debugPrint(user.runtimeType.toString());
    if (user != null) {
      debugPrint("Login Successfully");
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SignUpPage(
                    email: userInputEmail,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        emailInputBox,
        passwordInputBox,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          child: MaterialButton(
            onPressed: _onSubmit,
            shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.amber, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: const Text(
              "Continue with email",
              style: TextStyle(
                  color: Colors.amber,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
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
      child: MaterialButton(
          onPressed: () {
            onPressed();
          },
          color: Colors.white,
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(40))),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Image.asset("assets/images/$fileName"),
                const SizedBox(width: 10),
                Text(
                  "${name.toUpperCase()} 帳號登入",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
    );
  }
}

class HintTextWithLine extends StatelessWidget {
  const HintTextWithLine({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xff707070),
                width: 1,
              ),
            ),
          ),
        ),
        const Expanded(
          flex: 3,
          child: Text(
            "連接其他帳號",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff707070),
              fontSize: 14,
              fontFamily: "Noto Sans TC",
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xff707070),
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
