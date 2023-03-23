import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';

class PerosonalProfileSetting extends StatefulWidget {
  PerosonalProfileSetting({super.key});
  Map<String, String?> personalInformation = {};
  Map<String, String?> get content => personalInformation;

  @override
  State<PerosonalProfileSetting> createState() =>
      _PerosonalProfileSettingState();
}

class _PerosonalProfileSettingState extends State<PerosonalProfileSetting> {
  final _formKey = GlobalKey<FormState>();
  final userNameEditTextController = TextEditingController();
  final userReallNameEditTextController = TextEditingController();
  final userMottoEditTextController = TextEditingController();
  final userIntroductioionEditController = TextEditingController();
  late final TextFormField userNameField;
  late final TextFormField userRealNameField;
  late final TextFormField userMottoField;
  late final TextFormField userIntroductionField;
  @override
  void initState() {
    super.initState();
    userNameField = TextFormField(
      // 預設會是UserName
      controller: userNameEditTextController
        ..addListener(() {
          widget.personalInformation = getAllFormContent();
        }),
      //initialValue: "Your User Name",
      decoration: const InputDecoration(
        label: Text("使用者名稱 / User Name"),
        icon: Icon(Icons.person_pin_outlined),
      ),
    );
    userRealNameField = TextFormField(
      // 預設會是UserName
      controller: userReallNameEditTextController
        ..addListener(() {
          widget.personalInformation = getAllFormContent();
        }),
      decoration: const InputDecoration(
        label: Text("本名 / Real Name"),
        icon: Icon(Icons.person_pin_outlined),
      ),
    );
    userMottoField = TextFormField(
      controller: userMottoEditTextController
        ..addListener(() {
          widget.personalInformation = getAllFormContent();
        }),
      decoration: const InputDecoration(
        label: Text("心情小語 / 座右銘"),
        icon: Icon(Icons.chat),
      ),
    );
    userIntroductionField = TextFormField(
      maxLength: 50,
      maxLines: 2,
      controller: userIntroductioionEditController
        ..addListener(() {
          widget.personalInformation = getAllFormContent();
        }),
      decoration: const InputDecoration(
        label: Text("自我介紹"),
        icon: Icon(Icons.chat),
      ),
    );
    widget.personalInformation = getAllFormContent();
  }

  @override
  void dispose() {
    userNameEditTextController.dispose();
    userReallNameEditTextController.dispose();
    userMottoEditTextController.dispose();
    userIntroductioionEditController.dispose();
    super.dispose();
  }

  Map<String, String?> getAllFormContent() {
    return {
      'userName': userNameEditTextController.text,
      'userRealName': userReallNameEditTextController.text,
      'userMotto': userMottoEditTextController.text,
      'userInroduction': userIntroductioionEditController.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const HeadlineWithContent(
            headLineText: "個人資訊設定", content: "新增全名、暱稱、自我介紹與心情小語，讓大家更快認識你"),
        const SizedBox(height: 35),
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              userNameField,
              userRealNameField,
              userMottoField,
              userIntroductionField
            ],
          ),
        )
      ],
    );
  }
}
