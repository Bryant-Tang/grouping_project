import 'package:flutter/material.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/components/component_lib.dart';
import 'package:provider/provider.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  // final _formKey = GlobalKey<FormState>();
  final headLineText = "個人資訊設定";
  final contextText = "新增全名、暱稱、自我介紹與心情小語，讓大家更快認識你";

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileEditViewModel>(builder: (context, model, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          HeadlineWithContent(headLineText: headLineText, content: contextText),
          const SizedBox(height: 35),
          Form(
            // key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextFormField(
                  initialValue: model.userName,
                  decoration: const InputDecoration(
                    label: Text("使用者名稱 / User Name"),
                    icon: Icon(Icons.person_pin_outlined),
                  ),
                  onChanged: model.updateUserName,
                ),
                TextFormField(
                  initialValue: model.realName,
                  decoration: const InputDecoration(
                    label: Text("本名 / Real Name"),
                    icon: Icon(Icons.person_pin_outlined),
                  ),
                  onChanged: model.updateRealName,
                ),
                TextFormField(
                  initialValue: model.slogan,
                  decoration: const InputDecoration(
                    label: Text("心情小語 / 座右銘"),
                    icon: Icon(Icons.chat),
                  ),
                  onChanged: model.updateSlogan),
                TextFormField(
                  maxLength: 100,
                  initialValue: model.introduction,
                  decoration: const InputDecoration(
                    label: Text("自我介紹"),
                    icon: Icon(Icons.chat),
                  ),
                  onChanged: model.updateIntroduction,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
