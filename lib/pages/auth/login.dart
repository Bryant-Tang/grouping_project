import 'package:grouping_project/model/user_model.dart';
import 'package:grouping_project/pages/auth/verify_code.dart';
import 'package:grouping_project/service/auth_service.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  final headLineText = "登入 / 註冊";
  final content = "已經辦理過 Grouping 帳號了嗎？\n連結其他帳號來取用 Grouping 的服務";
  final buttonUI = {
    "Apple": {"fileName": "apple.png", "name": "apple", "onPress": () {}},
    "Google": {
      "fileName": "google.png",
      "name": "google",
      "onPress": () async {
        AuthService _authService = AuthService();
        await _authService.googleLogin();
      }
    },
    "Github": {"fileName": "github.png", "name": "github", "onPress": () {}},
  };
  List<Widget> buttonBuilder() {
    List<Widget> authButtonList = [];
    for (dynamic button in buttonUI.values) {
      authButtonList.add(AuthButton(
          fileName: button["fileName"],
          name: button["name"],
          onPressed: button["onPress"]));
    }
    return authButtonList;
  }

  @override
  LogInState createState() => LogInState();
}

class LogInState extends State<LoginPage> {
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
              const EmailForm(),
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

class EmailForm extends StatefulWidget {
  const EmailForm({super.key});

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final textController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    textController
        .addListener(() => print("input box: ${textController.text}"));
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    print("input box: ${textController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          child: TextField(
              controller: textController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      gapPadding: 1.0,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.mail),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "電子郵件 GMAIL",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: "NotoSansTC",
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          child: MaterialButton(
            onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('帳號登入'),
                      content: Text('使用${textController.text}進行登入嗎'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            _authService.setEmail(textController.text);
                            Navigator.pop(context, 'OK');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const VerifyCode()));
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    )),
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
  AuthService _authService = AuthService();

  final String fileName;
  final String name;
  final void Function()? onPressed;
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
          onPressed: () {},
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

class HeadlineWithContent extends StatelessWidget {
  final String headLineText;
  final String content;
  final TextStyle headLineStyle = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: Color(0Xff1E1E1E));
  final TextStyle contentStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Color(0Xff717171));
  const HeadlineWithContent(
      {super.key, required this.headLineText, required this.content});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(headLineText, style: headLineStyle),
        Text(content, style: contentStyle),
      ],
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
