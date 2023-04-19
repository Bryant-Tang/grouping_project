import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/VM/workspace_dashboard_view_model.dart';
import 'package:grouping_project/View/profile_edit_view.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/components/personal_detail_template.dart';
import 'package:provider/provider.dart';

class ProfileDispalyPageView extends StatefulWidget {
  const ProfileDispalyPageView({super.key});
  @override
  State<ProfileDispalyPageView> createState() => ProfileDispalyPageViewState();
}

class ProfileDispalyPageViewState extends State<ProfileDispalyPageView> {
  // late ProfileModel profile;
  List<CustomLabel> allProfileTag(List<AccountTag>? tags) {
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
    return Consumer<WorkspaceDashboardViewModel>(
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
                                    name: model.realName,
                                    nickName: model.userName,
                                    imageShot: model.profile.photo.isNotEmpty
                                        ? Image.file(
                                            File.fromRawPath(model.profileImage))
                                        : Image.asset(
                                            'assets/images/profile_male.png'),
                                    motto: model.slogan),
                                CustomLabel(
                                    title: '自我介紹',
                                    information: model.introduction),
                              ] +
                              allProfileTag(model.tags),
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
                    onPressed: () async {
                      debugPrint('edit');
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ProfileEditPageView(model: ProfileEditViewModel()..profile = model.profile),
                          ));
                      model.getAllData();
                    },
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    child: const Text(
                      'EDIT',
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
