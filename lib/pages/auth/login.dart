import 'package:grouping_project/model/data_controller.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/model/user_model.dart';
import 'package:grouping_project/pages/auth/sign_up.dart';
import 'package:grouping_project/pages/auth/user.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_dashboard_page.dart';
import 'package:grouping_project/pages/home/home_page/base_page.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  final headLineText = "登入";
  final content = "已經辦理過 Grouping 帳號了嗎？\n連結其他帳號來取用 Grouping 的服務";
  final buttonUI = {
    "Facebook": {"fileName": "apple.png", "name": "facebook"},
    "Google": {"fileName": "google.png", "name": "google"},
    "Github": {"fileName": "github.png", "name": "github"},
  };
  List<Widget> buttonBuilder(BuildContext context) {
    List<Widget> authButtonList = [];
    for (dynamic button in buttonUI.values) {
      authButtonList.add(AuthButton(
          fileName: button["fileName"],
          name: button["name"],
          onPressed: () async {
            AuthService authService = AuthService();
            await authService.thridPartyLogin(button["name"]).then((value) {
              if (value != null) {
                // debugPrint("${value.uid}\n");
                // DataController d = DataController();
                // d.download(dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!).onError((error, stackTrace){
                //   // if(error is ){
                //     Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => RecommendPage(forward: () {  },)));
                //   // }
                // });
                // TODO: check if user has profile
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const BasePage()));
              }
            });
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.fromLTRB(30.0, 120.0, 30.0,0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                child: Column(children: widget.buttonBuilder(context)),
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
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final emailInputBox = GroupingInputField(
    labelText: "Email",
    boxIcon: Icons.mail,
    boxColor: Colors.grey,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Email不得為空";
      } else {
        return null;
      }
    },
  );
  final passwordInputBox = GroupingInputField(
    labelText: "password",
    boxIcon: Icons.password,
    boxColor: Colors.grey,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "密碼請勿留空";
      } else {
        return null;
      }
    },
  );
  String userInputEmail = "";
  String userInputPassword = "";
  bool isInputFormatCorrect = true;
  UserModel? user;
  void _onPress() async {
    setState(() {
      // when user press continue with email button, program first check the vaildation of input by calling all the validator in the form
      // next call call userLogin from service API
      isInputFormatCorrect = _formKey.currentState!.validate();
      if (isInputFormatCorrect) {
        // debugPrint("登入測試");
        userInputEmail = emailInputBox.text;
        userInputPassword = passwordInputBox.text;
        // debugPrint("Email: $userInputEmail , Password: $userInputPassword");
      }
    });
    if (isInputFormatCorrect) {
      checkUserInput(userInputEmail, userInputPassword);
    }
  }

  void checkUserInput(String email, String password) async {
    await authService
        .emailLogIn(userInputEmail, userInputPassword)
        .then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  UserData(data: value, child: const HomePage())));
    }).catchError((error) {
      // debugPrint(error.toString());
      switch (error.code) {
        case 'invalid-email':
          debugPrint('invalid-email');
          showErrorDialog('信箱格式錯誤', '請使用正確的信箱登入');
          break;
        case 'user-disabled':
          debugPrint('user-disabled');
          showErrorDialog('帳號認證錯誤', '無法使用$userInputEmail登入Grouping服務');
          break;
        case 'user-not-found':
          debugPrint('user-not-found');
          SignUpDataModel data = SignUpDataModel(email: email);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignUpPage(data: data)));
          break;
        case 'wrong-password':
          showErrorDialog('密碼錯誤', '請確認帳號$userInputEmail密碼是否正確');
          break;
        default:
          debugPrint(error.toString());
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          emailInputBox,
          passwordInputBox,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
            child: MaterialButton(
              onPressed: _onPress,
              color: Colors.amber,
              shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.amber, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const Text(
                "Continue with email",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
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
