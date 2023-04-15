import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouping_project/ViewModel/personal_dashBord_view_model.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_dashboard_page.dart';
import 'package:grouping_project/pages/profile/personal_profile/inherited_profile.dart';

import 'package:grouping_project/pages/profile/personal_profile/profile_edit_page.dart';
import 'package:grouping_project/components/personal_detail_template.dart';
import 'package:provider/provider.dart';

class CardEditDone extends StatefulWidget {
  const CardEditDone({super.key});
  @override
  State<CardEditDone> createState() => CardEditDoneState();
}

class CardEditDoneState extends State<CardEditDone> {
  // late ProfileModel profile;
  List<CustomLabel> allProfileTag(List<ProfileTag>? tags) {
    List<CustomLabel> datas = [];
    int len = tags?.length ?? 0;
    for (int i = 0; i < len; i++) {
      datas.add(CustomLabel(title: tags![i].tag, information: tags[i].content));
    }
    return datas;
  }

  @override
  Widget build(BuildContext context) {
    // final profile = InheritedProfile.of(context)!.profile;
    return Consumer<PersonalDashboardViewModel>(
      builder: (context, model, child) => SafeArea(
        bottom: true,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            flex: 10,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              width: 380,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      spreadRadius: 0.5,
                      blurRadius: 2,
                    )
                  ]),
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: 20,
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                    ),
                  ),
                  Positioned(
                      top: 20,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 380,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                                HeadShot(
                                    name: model.profile.name ?? 'unknown',
                                    nickName: model.profile.nickname ?? 'None',
                                    imageShot: model.profile.photo != null ? Image.file(File(model.profile.photo!.path)) : Image.asset('assets/images/profile_male.png'),
                                    motto: model.profile.slogan ?? 'None'),
                                CustomLabel(
                                    title: '自我介紹',
                                    information: model.profile.introduction ??
                                        'No Introduction'),
                              ] +
                              allProfileTag(model.profile.tags),
                        ),
                      ))
                ],
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      debugPrint('share');
                    },
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    child: const Text(
                      'SHARE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint('edit');
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EditPersonalProfilePage(profile: model.profile)))
                          .then((value) {
                        if (value is ProfileModel) {
                          InheritedProfile.of(context)!.updateProfile(value);
                        }
                      });
                    },
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    child: const Text(
                      'EDIT',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint('theme');
                    },
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    child: const Text(
                      'THEME',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ))
        ]),
      ),
    );
  }
}
