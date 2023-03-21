import 'package:grouping_project/components/component_lib.dart';
import 'package:grouping_project/pages/templates/sing_up_page_template.dart';
import 'package:grouping_project/pages/home/home_page.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpDataModel {
  String password = "";
  String userName = "";
  String email = "";
  SignUpDataModel({this.email = "", this.password = "", this.userName = ""});
}

class SignUpPageModel extends InheritedWidget {
  final SignUpDataModel data;
  const SignUpPageModel({
    Key? key,
    required this.data,
    required child,
  }) : super(key: key, child: child);

  static SignUpPageModel? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SignUpPageModel>();
  }

  @override
  bool updateShouldNotify(SignUpPageModel oldWidget) {
    return oldWidget.data != data;
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return const _SignUpHomePage();
  }
}

class _SignUpHomePage extends StatelessWidget {
  const _SignUpHomePage();
  final headLineText = "歡迎加入 Grouping";
  final content = "此信箱還未被註冊過\n用此信箱註冊一個新的帳號？\n選擇其他帳號登入?";
  @override
  Widget build(BuildContext context) {
    // debugPrint(SignUpPageModel.of(context)!.data.email);
    return SignUpPageTemplate(
      titleWithContent:
          HeadlineWithContent(headLineText: headLineText, content: content),
      body: const GroupingLogo(),
      toggleBar: NavigationToggleBar(
        goBackButtonText: "使用其他帳號",
        goToNextButtonText: "前往註冊",
        goBackButtonHandler: () {
          Navigator.pop(context);
        },
        goToNextButtonHandler: () {
          final data = SignUpPageModel.of(context)!.data;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUpPageModel(
                      data: data, child: const _UserNameRegisterPage())));
        },
      ),
    );
  }
}

class _UserNameRegisterPage extends StatefulWidget {
  const _UserNameRegisterPage();

  @override
  State<_UserNameRegisterPage> createState() => _UserNameRegisterPageState();
}

class _UserNameRegisterPageState extends State<_UserNameRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final headLineText = "使用者名稱";
  final content = "請輸入此帳號的使用者名稱";
  final inputBox = GroupingInputField(
    labelText: "USERNAME 使用者名稱",
    boxIcon: Icons.people,
    boxColor: Colors.grey,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "使用者名稱請勿留空";
      } else {
        return null;
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return SignUpPageTemplate(
      titleWithContent:
          HeadlineWithContent(headLineText: headLineText, content: content),
      body: Form(key: _formKey, child: inputBox),
      toggleBar: NavigationToggleBar(
        goBackButtonText: "上一步",
        goToNextButtonText: "下一步",
        goBackButtonHandler: () {
          Navigator.pop(context);
        },
        goToNextButtonHandler: () {
          if (_formKey.currentState!.validate()) {
            // debugPrint("input box: ${inputBox.text}\n");
            // debugPrint(SignUpPageModel.of(context).runtimeType.toString());
            final data = SignUpPageModel.of(context)!.data
              ..userName = inputBox.text;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SignUpPageModel(
                        data: data, child: const _UserPasswordRegisterPage())));
          }
        },
      ),
    );
  }
}

class _UserPasswordRegisterPage extends StatefulWidget {
  const _UserPasswordRegisterPage();
  @override
  State<_UserPasswordRegisterPage> createState() =>
      _UserPasswordRegisterPageState();
}

class _UserPasswordRegisterPageState extends State<_UserPasswordRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final headLineText = "使用者密碼";
  final content = "請輸入此帳號的使用者密碼";
  late final GroupingInputField passwordField;
  late final GroupingInputField passwordConfirmField;
  @override
  void initState() {
    super.initState();
    setState(() {
      passwordField = GroupingInputField(
        labelText: "PASSWORD 使用者密碼",
        boxIcon: Icons.password,
        boxColor: Colors.grey,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "密碼請勿留空";
          } else if (value.length <= 6) {
            return "密碼長度必須大於6個字元";
          }
          return null;
        },
      );
      passwordConfirmField = GroupingInputField(
        labelText: "再次輸入密碼",
        boxIcon: Icons.password,
        boxColor: Colors.grey,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "確認欄位請勿留空";
          }
          if (value != passwordField.text) {
            return "兩次密碼輸入不同";
          } else {
            return null;
          }
        },
      );
    });
  }

  void dialog() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('兩次輸入不相符'),
              content: const Text('請確認兩次輸入的密碼是否相同'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('關閉'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SignUpPageTemplate(
      titleWithContent:
          HeadlineWithContent(headLineText: headLineText, content: content),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            passwordField,
            const SizedBox(
              height: 15,
            ),
            passwordConfirmField
          ],
        ),
      ),
      toggleBar: NavigationToggleBar(
          goBackButtonText: "上一步",
          goToNextButtonText: "下一步",
          goBackButtonHandler: () {
            Navigator.pop(context);
          },
          goToNextButtonHandler: () {
            if (_formKey.currentState!.validate()) {
              final data = SignUpPageModel.of(context)!.data
                ..password = passwordField.text;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUpPageModel(
                          data: data, child: const _SignUpFinishPage())));
            }
          }),
    );
  }
}

// class _SignUpPageFour extends StatelessWidget {
//   final String email;
//   final String userName;
//   const _SignUpPageFour({required this.email, required this.userName,});
//   final headLineText = "創建新的小組";
//   final content = "已經有要加入的Group了嗎，透過連結加入小組，或是設立新的Group";
//   @override
//   Widget build(BuildContext context) {
//     return SignUpPageTemplate(
//       titleWithContent:
//           HeadlineWithContent(headLineText: headLineText, content: content),
//       body: const Placeholder(),
//       toggleBar: NavigationToggleBar(
//         goBackButtonText: "稍後設定",
//         goToNextButtonText: "創建我的小組",
//         goBackButtonHandler: () {
//           Navigator.pop(context);
//         },
//         goToNextButtonHandler: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>
//                       _SignUpPageFive(email: email, userName: userName)));
//         },
//       ),
//     );
//   }
// }

class _SignUpFinishPage extends StatefulWidget {
  const _SignUpFinishPage();
  @override
  State<_SignUpFinishPage> createState() => _SignUpFinishPageState();
}

class _SignUpFinishPageState extends State<_SignUpFinishPage> {
  final headLineText = "帳號資訊建立創建完成!";

  final content = "歡迎加入 Grouping 一起與夥伴創造冒險吧";

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

  void _onPress() async {
    String email = SignUpPageModel.of(context)!.data.email;
    String password = SignUpPageModel.of(context)!.data.password;
    AuthService authService = AuthService();
    await authService
        .emailSignUp(email, password)
        .then((value) => debugPrint("Sign Up Successfully"))
        .catchError((error) {
      showErrorDialog(error.code, error.toString());
    });
    debugPrint('註冊信箱: $email\n使用者密碼: $password');
    if (context.mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyHomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignUpPageTemplate(
      titleWithContent:
          HeadlineWithContent(headLineText: headLineText, content: content),
      body: Column(
        children: [
          HeadlineWithContent(
              headLineText: "使用者",
              content: SignUpPageModel.of(context)!.data.userName),
          const Divider(color: Colors.amber),
          HeadlineWithContent(
              headLineText: "帳號",
              content: SignUpPageModel.of(context)!.data.email),
          const Divider(color: Colors.amber),
          HeadlineWithContent(
              headLineText: "密碼",
              content: SignUpPageModel.of(context)!.data.password),
          const Divider(color: Colors.amber),
        ],
      ),
      toggleBar: NavigationToggleBar(
        goBackButtonText: "修改資料",
        goToNextButtonText: "完成註冊",
        goBackButtonHandler: () {
          Navigator.pop(context);
        },
        goToNextButtonHandler: _onPress,
      ),
    );
  }
}
