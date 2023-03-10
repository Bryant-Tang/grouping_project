import 'package:grouping_project/components/headline_with_content.dart';
import 'package:grouping_project/model/user_model.dart';
import 'package:grouping_project/pages/auth/sign_up.dart';
import 'package:grouping_project/pages/home/home_page.dart';
import 'package:grouping_project/service/auth_service.dart';

import 'package:flutter/material.dart';

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

  final String _error = '';
  final String _email = '';

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
  final textController = TextEditingController();
  final AuthService authService = AuthService();
  bool inputEmailLogin = false;
  String userInputMail = "";
  String userInputAuthCode = "";
  List<String> userAccounts = [];

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    textController
        .addListener(() => debugPrint("input box: ${textController.text}"));
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String getFirebaseAuthCode() {
    String code = "123456";
    //String code = (Random().nextInt(99999) + 100000).toString();
    return code;
  }

  void _onSubmit() async {
    final UserModel? userModel =
        await authService.emailLogIn(userInputMail, userInputMail);
    setState(() {
      if (inputEmailLogin == false) {
        inputEmailLogin = true;
        userInputMail = textController.text;
        textController.clear();
        debugPrint("input box: $userInputMail");
      } else {
        // fix this function
        userInputAuthCode = textController.text;
        String firebaseAuthCode = getFirebaseAuthCode();
        debugPrint(firebaseAuthCode);
        if (userInputAuthCode == firebaseAuthCode) {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text('認證成功'),
                    content: Text('使用$userInputMail進行登入'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ));
          if (userModel != null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MyHomePage()));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SignUpPage(email: userInputMail)));
          }
        } else {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text('認證失敗'),
                    content: const Text('驗證碼不匹配'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ));
        }
        // debugPrint("input box: ${widget.userInputAuthCode}");
      }
    });
  }

  void dialog() {
    showDialog<String>(
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
                    Navigator.pop(context, 'OK');
                    setState(() {
                      authService.setEmail(textController.text);
                    });
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (inputEmailLogin == false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
            child: TextField(
                controller: textController,
                decoration: InputDecoration(
                    // isDense 為必要, contentPadding 越大，則 textfield 越大
                    contentPadding: const EdgeInsets.all(15),
                    isDense: true,
                    border: const OutlineInputBorder(
                        gapPadding: 1.0,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          Icons.mail,
                          color: Colors.grey,
                        ),
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
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
            child: Text(
              "Welcome $userInputMail",
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
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
                        const Icon(Icons.password, color: Colors.grey),
                        const SizedBox(width: 10),
                        Text(
                          "驗證碼 auth token",
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
            child: Text(
              "已經寄送驗證碼到信箱 $userInputMail",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.blueGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
            child: MaterialButton(
              onPressed: _onSubmit,
              shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.amber, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const Text(
                "確認驗證碼",
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
