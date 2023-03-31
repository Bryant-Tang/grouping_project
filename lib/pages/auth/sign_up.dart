import 'package:grouping_project/components/component_lib.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/auth/user.dart';
import 'package:grouping_project/pages/auth/sing_up_page_template.dart';
import 'package:grouping_project/pages/home/personal_dashboard_page.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final SignUpDataModel data;
  const SignUpPage({super.key, required this.data});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _pageController = PageController(keepPage: true);
  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      _SignUpHomePage(
        forward: forward,
        backward: Navigator.of(context).pop,
      ),
      _UserNameRegisterPage(
          forward: forward,
          backward: backward,
          callback: (userName) {
            setState(() => widget.data.userName = userName);
          }),
      _UserPasswordRegisterPage(
          forward: forward,
          backward: backward,
          callback: (password) {
            setState(() => widget.data.password = password);
          }),
      _SignUpFinishPage(
        data: widget.data,
        forward: register,
        backward: backward,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void backward() {
    final pageIndex = _pageController.page!.round();
    debugPrint(pageIndex.toString());
    if (pageIndex > 0) {
      _pageController.animateToPage(pageIndex - 1,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  void forward() {
    final pageIndex = _pageController.page!.round();
    if (pageIndex < _pages.length - 1) {
      _pageController.animateToPage(pageIndex + 1,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  void register() async {
    String email = widget.data.email;
    String password = widget.data.password;
    String userName = widget.data.userName;
    debugPrint('註冊信箱: $email\n使用者密碼: $password');
    AuthService authService = AuthService();
    await authService.emailSignUp(email, password).then((value) {
      if (context.mounted) {
        debugPrint('註冊信箱: $email\n使用者密碼: $password 註冊成功');
        final ProfileModel user = ProfileModel(name: userName, email: email);
        DataController()
            .upload(uploadData: user)
            .then((value) => {debugPrint('upload successfully')})
            .catchError((error) {
          debugPrint(error.toString());
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserData(
                    data: value, child: const PeronalDashboardPage())));
      }
    }).catchError((error) {
      showErrorDialog(error.code, error.toString());
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

  final PageStorageBucket _bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return PageStorage(
        bucket: _bucket,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ));
  }
}

class _SignUpHomePage extends StatelessWidget {
  final void Function() forward;
  final void Function() backward;
  const _SignUpHomePage({required this.forward, required this.backward});
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
        goBackButtonHandler: backward,
        goToNextButtonHandler: forward,
      ),
    );
  }
}

class _UserNameRegisterPage extends StatefulWidget {
  final void Function() forward;
  final void Function() backward;
  final void Function(String) callback;
  const _UserNameRegisterPage(
      {required this.forward, required this.backward, required this.callback});

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
  String userName = "";
  @override
  Widget build(BuildContext context) {
    return SignUpPageTemplate(
      titleWithContent:
          HeadlineWithContent(headLineText: headLineText, content: content),
      body: Form(key: _formKey, child: inputBox),
      toggleBar: NavigationToggleBar(
        goBackButtonText: "上一步",
        goToNextButtonText: "下一步",
        goBackButtonHandler: widget.backward,
        goToNextButtonHandler: () {
          if (_formKey.currentState!.validate()) {
            widget.callback(inputBox.text ?? "");
            widget.forward();
          }
        },
      ),
    );
  }
}

class _UserPasswordRegisterPage extends StatefulWidget {
  final void Function() forward;
  final void Function() backward;
  final void Function(String) callback;
  const _UserPasswordRegisterPage(
      {required this.forward, required this.backward, required this.callback});
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
          goBackButtonHandler: widget.backward,
          goToNextButtonHandler: () {
            if (_formKey.currentState!.validate()) {
              widget.callback(passwordField.text);
              widget.forward();
            }
          }),
    );
  }
}

class _SignUpFinishPage extends StatefulWidget {
  final void Function() forward;
  final void Function() backward;
  final SignUpDataModel data;
  const _SignUpFinishPage(
      {required this.forward, required this.backward, required this.data});
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

  @override
  Widget build(BuildContext context) {
    return SignUpPageTemplate(
      titleWithContent:
          HeadlineWithContent(headLineText: headLineText, content: content),
      body: Column(
        children: [
          HeadlineWithContent(
              headLineText: "使用者", content: widget.data.userName),
          const Divider(color: Colors.amber),
          HeadlineWithContent(headLineText: "帳號", content: widget.data.email),
          const Divider(color: Colors.amber),
          HeadlineWithContent(
              headLineText: "密碼", content: widget.data.password),
          const Divider(color: Colors.amber),
        ],
      ),
      toggleBar: NavigationToggleBar(
        goBackButtonText: "修改資料",
        goToNextButtonText: "完成註冊",
        goBackButtonHandler: widget.backward,
        goToNextButtonHandler: widget.forward,
      ),
    );
  }
}
