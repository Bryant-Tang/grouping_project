import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';

import 'package:grouping_project/pages/profile/profile_edit_page.dart';
import 'package:grouping_project/components/personal_detail_template.dart';
import 'package:grouping_project/service/auth_service.dart';

class CardEditDone extends StatefulWidget {
  const CardEditDone({super.key});
  @override
  State<CardEditDone> createState() => CardEditDoneState();
}

class CardEditDoneState extends State<CardEditDone> {

  final AuthService _authService = AuthService();
  ProfileModel profile = ProfileModel();

  @override
  void initState() {
    super.initState();
    DataController()
        .download(dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!)
        .then((value) {
      setState(() {
        profile = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            // TODO: Get User Name from data package
            profile.name ?? 'Unknown',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                debugPrint('switch to personal Intro.');
                Navigator.pop(context);
              },
              icon: const Icon(Icons.circle),
            ),
          ],
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          Expanded(
            flex: 10,
            child: Container(
              margin: const EdgeInsets.all(5),
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
                  const Positioned(
                    top: 25,
                    right: 5,
                    child: Icon(Icons.edit_document),
                  ),
                  Positioned(
                      top: 20,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 380,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            HeadShot(name: profile.name ?? 'unknown', nickName: profile.nickname ?? 'None', imageShot: Image.asset('assets/images/logo.png'), motto: profile.slogan ?? 'None'),
                            CustomLabel(title: '自我介紹', information: profile.introduction ?? 'No Introduction'),
                            // const CustomLabel(title: '系級', information: 'Never Care You 歷史系 5 年級'),
                            // const CustomLabel(title: '專長', information: '擅長去尋常各個學校不在乎你的歷史'),
                          ] + allProfileTag(profile.tags),
                        ),
                      ))
                ],
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                                  const EditPersonalProfilePage()));
                      // DataController()
                      //     .download(dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!)
                      //     .then((value) {
                      //   setState(() {
                      //     profile = value;
                      //   });
                      // });
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
                      MaterialPageRoute(
                        builder: (context) => const EditPersonalProfilePage(),
                      );
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
        ]));
  }
}

List<StatelessWidget> allProfileTag(List<ProfileTag>? tags){
  List<StatelessWidget> datas = [];
  int len = tags?.length ?? 0;
  for(int i = 0; i < len; i++){
    datas.add(CustomLabel(title: tags![i].tag, information: tags[i].content));
  }
  return datas;
}
