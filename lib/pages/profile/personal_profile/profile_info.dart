import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';
import 'package:grouping_project/model/profile_model.dart';
import 'package:grouping_project/pages/profile/personal_profile/inherited_profile.dart';

class PerosonalProfileSetting extends StatefulWidget {
  const PerosonalProfileSetting({super.key});
  @override
  State<PerosonalProfileSetting> createState() =>
      _PerosonalProfileSettingState();
}

class _PerosonalProfileSettingState extends State<PerosonalProfileSetting> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final profile = InheritedProfile.of(context)!.profile;
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
              TextFormField(
                initialValue: profile.nickname,
                decoration: const InputDecoration(
                  label: Text("使用者名稱 / User Name"),
                  icon: Icon(Icons.person_pin_outlined),
                ),
                onChanged: (value) {
                  InheritedProfile.of(context)!.updateProfile(profile
                      .copyWith(nickname: value));
                },
              ),
              TextFormField(
                initialValue: profile.name,
                decoration: const InputDecoration(
                  label: Text("本名 / Real Name"),
                  icon: Icon(Icons.person_pin_outlined),
                ),
                onChanged: (value) {
                  InheritedProfile.of(context)!.updateProfile(profile
                      .copyWith(name: value));
                },
              ),
              TextFormField(
                initialValue: profile.slogan,
                decoration: const InputDecoration(
                  label: Text("心情小語 / 座右銘"),
                  icon: Icon(Icons.chat),
                ),
                onChanged: (value) {
                  InheritedProfile.of(context)!.updateProfile(profile
                      .copyWith(slogan: value));
                },
              ), 
              TextFormField(
                maxLength: 100,
                initialValue: profile.introduction,
                decoration: const InputDecoration(
                  label: Text("自我介紹"),
                  icon: Icon(Icons.chat),
                ),
                onChanged: (value) {
                  InheritedProfile.of(context)!.updateProfile(
                      profile.copyWith(
                          introduction: value));
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
