import 'package:grouping_project/components/component_lib.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/auth/sing_up_page_template.dart';
import 'package:grouping_project/pages/home/home_page.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final String email;
  const SignUpPage({Key? key, required this.email}) : super(key: key);
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return _SignUpHomePage(email: widget.email);
  }
}

class _SignUpHomePage extends StatelessWidget {
  final String email;
  const _SignUpHomePage({required this.email});
  final headLineText = "歡迎加入 Grouping";
  final content = "此信箱還未被註冊過\n用此信箱註冊一個新的帳號？\n選擇其他帳號登入?";
  @override
  Widget build(BuildContext context) {
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => _UserNameRegisterPage(
                        email: email,
                      )));
        },
      ),
    );
  }
}

class _UserNameRegisterPage extends StatefulWidget {
  final String email;
  const _UserNameRegisterPage({required this.email});

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
          // print("input box: ${textController.text}\n");
          if (_formKey.currentState!.validate()) {
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => _UserPasswordRegisterPage(
                  email: widget.email, 
                  userName: inputBox.inputText
                )
              )
            );
          }
          
        },
      ),
    );
  }
}

class _UserPasswordRegisterPage extends StatefulWidget {
  final String email;
  final String userName;
  const _UserPasswordRegisterPage(
      {required this.email, required this.userName});

  @override
  State<_UserPasswordRegisterPage> createState() =>
      _UserPasswordRegisterPageState();
}

class _UserPasswordRegisterPageState extends State<_UserPasswordRegisterPage> {
  final headLineText = "使用者密碼";
  final content = "請輸入此帳號的使用者密碼";
  final password1 = GroupingInputField(
    labelText: "PASSWORD 使用者密碼",
    boxIcon: Icons.password,
    boxColor: Colors.grey,
  );
  final password2 = GroupingInputField(
    labelText: "再次輸入密碼",
    boxIcon: Icons.password,
    boxColor: Colors.grey,
  );
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
      body: Column(
        children: <Widget>[
          password1,
          const SizedBox(
            height: 25,
          ),
          password2,
        ],
      ),
      toggleBar: NavigationToggleBar(
          goBackButtonText: "上一步",
          goToNextButtonText: "下一步",
          goBackButtonHandler: () {
            Navigator.pop(context);
          },
          goToNextButtonHandler: () {
            String passwordText = password1.inputText;
            String passwordConfirmText = password2.inputText;
            if (passwordText == passwordConfirmText) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => _SignUpFinishPage(
                          email: widget.email,
                          userName: widget.userName,
                          password: passwordText)));
            } else {
              debugPrint("password does not match");
              dialog();
            }
          }),
    );
  }
}

// class _SignUpPageThree extends StatelessWidget {
//   final String email;
//   final String userName;
//   const _SignUpPageThree({required this.email, required this.userName});
//   final headLineText = "名片資訊設定";
//   final content = "Grouping 提供精美的名片功能，讓你的小組員能更快認識你，了解你。";
//   @override
//   Widget build(BuildContext context) {
//     return SignUpPageTemplate(
//       titleWithContent:
//           HeadlineWithContent(headLineText: headLineText, content: content),
//       body: const Placeholder(),
//       toggleBar: NavigationToggleBar(
//         goBackButtonText: "稍後設定",
//         goToNextButtonText: "設定名片",
//         goBackButtonHandler: () {
//           Navigator.pop(context);
//         },
//         goToNextButtonHandler: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>
//                       _SignUpPageFour(email: email, userName: userName)));
//         },
//       ),
//     );
//   }
// }

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

class _SignUpFinishPage extends StatelessWidget {
  final String email;
  final String userName;
  final String password;
  const _SignUpFinishPage(
      {required this.email, required this.userName, required this.password});
  final headLineText = "帳號創建完成!";
  final content = "歡迎加入 Grouping 一起與夥伴創造冒險吧";
  @override
  Widget build(BuildContext context) {
    return SignUpPageTemplate(
      titleWithContent:
          HeadlineWithContent(headLineText: headLineText, content: content),
      body: const GroupingLogo(),
      toggleBar: NavigationToggleBar(
        goBackButtonText: "修改資料",
        goToNextButtonText: "前往我的主頁",
        goBackButtonHandler: () {
          Navigator.pop(context);
        },
        goToNextButtonHandler: () async {
          final AuthService authService = AuthService();
          final UserModel user = await authService.emailSignUp(email, password);
          // await setProfileForPerson(
          //     newProfile: UserProfile(
          //         email: email, userName: userName, userId: userModel.uid),
          //     userId: userModel.uid);
          debugPrint('註冊信箱： $email\n使用者名稱$userName');

          if (context.mounted) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyHomePage()));
          }
        },
      ),
    );
  }
}
