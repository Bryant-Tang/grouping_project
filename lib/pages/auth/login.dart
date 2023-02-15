import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:grouping_project/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  final headLineText = "登入 / 註冊";
  final content = "已經辦理過 Grouping 帳號了嗎？\n連結其他帳號來取用 Grouping 的服務";
  final buttonUI = {
    "Apple": {"fileName": "apple.png", "name": "apple", "onPress": () {}},
    "Google": {"fileName": "google.png", "name": "google", "onPress": () {}},
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
  final AuthService _authService = AuthService();

  String error = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              HeadlineWithContent(
                  headLineText: widget.headLineText, content: widget.content),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            label: Text("EMAIL / 電子郵件",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            prefix: Icon(Icons.email),
                            constraints: BoxConstraints(maxHeight: 45)),
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: const BorderSide(
                            width: 4,
                            color: Color.fromARGB(255, 133, 168, 196),
                          ),
                        )),
                    validator: (value) => value!.length < 6
                        ? 'Enter password longer than 5'
                        : null,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                ],
              ),
              const HintTextWithLine(),
              SizedBox(
                  width: double.infinity,
                  child: Column(children: widget.buttonBuilder()))
            ],
          ),
        ),
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final String fileName;
  final String name;
  final Void? Function() onPressed;
  const AuthButton({
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
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Image.asset("assets/images/$fileName"),
              const SizedBox(width: 10),
              Text(
                "login with $name account",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
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
      fontSize: 16, fontWeight: FontWeight.bold, color: Color(0Xff1E1E1E));
  const HeadlineWithContent(
      {super.key, required this.headLineText, required this.content});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          // head line
          width: double.infinity,
          child: Text(headLineText, style: headLineStyle),
        ),
        SizedBox(
          // content
          width: double.infinity,
          child: Text(content, style: contentStyle),
        )
      ],
    );
  }
}

class HintTextWithLine extends StatelessWidget {
  const HintTextWithLine({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              "OR CONNECT WITH",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff707070),
                fontSize: 12,
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
      ),
    );
  }
}
