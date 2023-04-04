import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/profile/personal_profile/profile_edit_page.dart';

class PerosonalProfileSetting extends StatefulWidget {
  PerosonalProfileSetting({super.key});
  ProfileModel profile = ProfileModel();
  @override
  State<PerosonalProfileSetting> createState() =>
      _PerosonalProfileSettingState();
}

class _PerosonalProfileSettingState extends State<PerosonalProfileSetting> {
  final _formKey = GlobalKey<FormState>();
  final userNameEditTextController = TextEditingController();
  final userReallNameEditTextController = TextEditingController();
  final userSlogonEditTextController = TextEditingController();
  final userIntroductioionEditController = TextEditingController();
  late TextFormField userNameField;
  late TextFormField userRealNameField;
  late TextFormField userMottoField;
  late TextFormField userIntroductionField;
  String? userName;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.profile = InheritedProfile.of(context)!.profile;
    userNameEditTextController
      ..text = widget.profile.nickname ?? ""
      ..addListener(() {
        setState(() {
          widget.profile.nickname = userNameEditTextController.text;
        });
      });
    userReallNameEditTextController
      ..text = widget.profile.name ?? ""
      ..addListener(() {
        setState(() {
          widget.profile.name = userReallNameEditTextController.text;
        });
      });
    userSlogonEditTextController
      ..text = widget.profile.slogan ?? ""
      ..addListener(() {
        setState(() {
          widget.profile.slogan = userSlogonEditTextController.text;
        });
      });
    userIntroductioionEditController
      ..text = widget.profile.introduction ?? ""
      ..addListener(() {
        setState(() {
          widget.profile.introduction = userIntroductioionEditController.text;
        });
      });
  }

  @override
  void initState() {
    super.initState();
    userNameField = TextFormField(
      controller: userNameEditTextController,
      decoration: const InputDecoration(
        label: Text("使用者名稱 / User Name"),
        icon: Icon(Icons.person_pin_outlined),
      ),
    );
    userRealNameField = TextFormField(
      // 預設會是UserName
      controller: userReallNameEditTextController,
      decoration: const InputDecoration(
        label: Text("本名 / Real Name"),
        icon: Icon(Icons.person_pin_outlined),
      ),
    );
    userMottoField = TextFormField(
      controller: userSlogonEditTextController,
      decoration: const InputDecoration(
        label: Text("心情小語 / 座右銘"),
        icon: Icon(Icons.chat),
      ),
    );
    userIntroductionField = TextFormField(
      maxLength: 100,
      controller: userIntroductioionEditController,
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
    userSlogonEditTextController.dispose();
    userIntroductioionEditController.dispose();
    super.dispose();
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
