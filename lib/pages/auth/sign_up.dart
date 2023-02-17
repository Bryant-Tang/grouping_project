import 'package:grouping_project/components/grouping_logo.dart';
import 'package:grouping_project/components/headline_with_content.dart';
import 'package:grouping_project/components/navigation_toggle_bar.dart';
import 'package:grouping_project/model/user_model.dart';
import 'package:grouping_project/pages/auth/sing_up_page_template.dart';
import 'package:grouping_project/pages/home/home_page.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/service/profile_service.dart';

import 'package:flutter_svg/svg.dart';
// import 'package:grouping_project/pages/auth/cover.dart';
// import 'package:grouping_project/pages/home/home_page.dart';
// import 'package:grouping_project/service/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final String email;
  const SignUpPage({Key? key, required this.email}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return _SignUpPageOne(email: widget.email);
  }
}

class _SignUpPageOne extends StatelessWidget {
  final String email;
  const _SignUpPageOne({super.key, required this.email});
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
                  builder: (context) => _SignUpPageTwo(
                        email: email,
                      )));
        },
      ),
    );
  }
}

class _SignUpPageTwo extends StatefulWidget {
  final String email;
  const _SignUpPageTwo({super.key, required this.email});

  @override
  State<_SignUpPageTwo> createState() => _SignUpPageTwoState();
}

class _SignUpPageTwoState extends State<_SignUpPageTwo> {
  final headLineText = "使用者名稱";
  final content = "請輸入此帳號的使用者名稱";
  final textController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return SignUpPageTemplate(
      titleWithContent:
          HeadlineWithContent(headLineText: headLineText, content: content),
      body: Padding(
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
                    const Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "USERNAME /  使用者名稱",
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
      toggleBar: NavigationToggleBar(
        goBackButtonText: "上一步",
        goToNextButtonText: "下一步",
        goBackButtonHandler: () {
          Navigator.pop(context);
        },
        goToNextButtonHandler: () {
          // print("input box: ${textController.text}\n");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => _SignUpPageThree(
                      email: widget.email, userName: textController.text)));
        },
      ),
    );
  }
}

class _SignUpPageThree extends StatelessWidget {
  final String email;
  final String userName;
  const _SignUpPageThree(
      {super.key, required this.email, required this.userName});
  final headLineText = "名片資訊設定";
  final content = "Grouping 提供精美的名片功能，讓你的小組員能更快認識你，了解你。";
  @override
  Widget build(BuildContext context) {
    return SignUpPageTemplate(
      titleWithContent:
          HeadlineWithContent(headLineText: headLineText, content: content),
      body: const Placeholder(),
      toggleBar: NavigationToggleBar(
        goBackButtonText: "稍後設定",
        goToNextButtonText: "設定名片",
        goBackButtonHandler: () {
          Navigator.pop(context);
        },
        goToNextButtonHandler: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      _SignUpPageFour(email: email, userName: userName)));
        },
      ),
    );
  }
}

class _SignUpPageFour extends StatelessWidget {
  final String email;
  final String userName;
  const _SignUpPageFour(
      {super.key, required this.email, required this.userName});
  final headLineText = "創建新的小組";
  final content = "已經有要加入的Group了嗎，透過連結加入小組，或是設立新的Group";
  @override
  Widget build(BuildContext context) {
    return SignUpPageTemplate(
      titleWithContent:
          HeadlineWithContent(headLineText: headLineText, content: content),
      body: const Placeholder(),
      toggleBar: NavigationToggleBar(
        goBackButtonText: "稍後設定",
        goToNextButtonText: "創建我的小組",
        goBackButtonHandler: () {
          Navigator.pop(context);
        },
        goToNextButtonHandler: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      _SignUpPageFive(email: email, userName: userName)));
        },
      ),
    );
  }
}

class _SignUpPageFive extends StatelessWidget {
  final String email;
  final String userName;
  _SignUpPageFive({super.key, required this.email, required this.userName});
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
          final UserModel userModel =
              await authService.emailSignUp(email, email);
          await setProfile(
              newProfile: UserProfile(
                  email: email, userName: userName, userId: userModel.uid),
              userId: userModel.uid);
          // print('註冊信箱： $email\n使用者名稱$userName');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
        },
      ),
    );
  }
}
