import 'package:grouping_project/model/user_model.dart';
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
  final AuthService _authService = AuthService();

  String _error = '';
  String _email = '';
  String _password = '';

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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        decoration: const InputDecoration(
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
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: MaterialButton(
                          onPressed: () {
                            _authService.setEmail(_email);
                          },
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.amber, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: const Text(
                            "Continue with email",
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ],
              ),
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
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value) {
              print(value);
              if (value == "quan" || value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          MaterialButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Processing Data')),
                // );
              }
            },
            shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.amber, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: const Text(
              "Continue with email",
              style: TextStyle(
                  color: Colors.amber,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

// class EmailTextField extends StatefulWidget {
//   const EmailTextField({super.key});

//   @override
//   State<EmailTextField> createState() => _EmailTextFieldState();
// }

// class _EmailTextFieldState extends State<EmailTextField> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisSize: MainAxisSize.max,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
//           child: TextFormField(),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
//           child:
//         ),
//       ],
//     );
//   }
// }

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
    );
  }
}
