import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';
// import 'package:grouping_project/model/profile_model.dart';
import 'package:grouping_project/pages/profile/profile_edit_page.dart';

class PerosonalProfileSetting extends StatefulWidget {
  // final void Function(Map<String, String?> content) callback;
  PerosonalProfileSetting({super.key});
  Map<String, String?>? content;

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
  TextFormField? userNameField;
  TextFormField? userRealNameField;
  TextFormField? userMottoField;
  TextFormField? userIntroductionField;
  String? userName;
  @override
  void initState() {
    super.initState();
    userNameField = TextFormField(
      controller: userNameEditTextController
        ..addListener(() {
          widget.content = getAllFormContent();
        }),
      decoration: const InputDecoration(
        label: Text("使用者名稱 / User Name"),
        icon: Icon(Icons.person_pin_outlined),
      ),
    );
    userRealNameField = TextFormField(
      // 預設會是UserName
      controller: userReallNameEditTextController
        ..addListener(() {
          widget.content = getAllFormContent();
        }),
      decoration: const InputDecoration(
        label: Text("本名 / Real Name"),
        icon: Icon(Icons.person_pin_outlined),
      ),
    );
    userMottoField = TextFormField(
      controller: userMottoEditTextController
        ..addListener(() {
          widget.content = getAllFormContent();
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
          widget.content = getAllFormContent();
        }),
      decoration: const InputDecoration(
        label: Text("自我介紹"),
        icon: Icon(Icons.chat),
      ),
    );
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
              userNameField!
                ..controller!.text =
                    ProfileInherited.of(context)!.profile.name ?? "Unknown",
              userRealNameField!
                ..controller!.text =
                    ProfileInherited.of(context)!.profile.nickname ?? "",
              userMottoField!
                ..controller!.text =
                    ProfileInherited.of(context)!.profile.slogan ?? "",
              userIntroductionField!
                ..controller!.text =
                    ProfileInherited.of(context)!.profile.introduction ?? ""
            ],
          ),
        )
      ],
    );
  }
}
