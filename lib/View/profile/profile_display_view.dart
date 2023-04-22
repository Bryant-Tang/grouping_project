import 'package:flutter/material.dart';

import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/View/profile/profile_edit_view.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/View/testing/qr_code_view.dart';

import 'package:provider/provider.dart';

class ProfileDispalyPageView extends StatefulWidget {
  const ProfileDispalyPageView({super.key});
  @override
  State<ProfileDispalyPageView> createState() => ProfileDispalyPageViewState();
}

class ProfileDispalyPageViewState extends State<ProfileDispalyPageView> {
  bool isProfile = true;
  bool isScanner = false; 

  Widget getContent(
      {required bool isProfile, required WorkspaceDashBoardViewModel model}) {
    List tags = List.from(model.tags);
    List tagWithoutTitles = tags;

    if (model.introduction != "unknown") {
      if (model.isPersonalAccount) {
        tags.insert(0, AccountTag(tag: "自我介紹", content: model.introduction));
      } else {
        debugPrint('It\'s a group account');
        tags.insert(0, AccountTag(tag: "小組簡介", content: model.introduction));
      }
    }
    if (model.slogan != "unknown") {
      if (model.isPersonalAccount) {
        tags.insert(0, AccountTag(tag: "座右銘", content: model.slogan));
      } else {
        debugPrint('It\'s a group account');
        tags.insert(0, AccountTag(tag: "小組口號", content: model.slogan));
      }
    }
    if (isProfile & !isScanner) {
      if (model.isPersonalAccount) {
        return Column(children: [
          const HeadShot(),
          Column(
              children: tags
                  .map((accountTag) => CustomLabel(
                      title: accountTag.tag, information: accountTag.content))
                  .toList())
        ]);
      } else {
        return Column(children: [
          const HeadShot(),
          Column(
              children: tags.map((accountTag) {
            if ((accountTag.tag == "小組簡介") || (accountTag.tag == "小組口號")) {
              return CustomLabel(
                  title: accountTag.tag, information: accountTag.content);
            } else {
              return Container();
            }
          }).toList()),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: tagWithoutTitles.map((accountTag) {
                if ((accountTag.tag == "小組簡介") || (accountTag.tag == "小組口號")) {
                  return Container();
                } else {
                  return CustomLabel(
                    title: accountTag.tag,
                    information: '',
                    forGroupTags: true,
                  );
                }
              }).toList()),
        ]);
      }
    }
    else if(isScanner){
      return const QrCodeScannerTesting();
    } 
    else {
      return ShowQRCodeView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
        builder: (context, model, child) {
      return SafeArea(
        child: Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.fromLTRB(3, 3, 3, 0),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 12,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  getContent(isProfile: isProfile, model: model),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfileEditPageView(
                                        model: ProfileEditViewModel()
                                          ..profile = model.accountProfile),
                              ));
                          await model.getAllData();
                        },
                        child: Icon(
                          Icons.edit,
                          size: 15,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          isProfile = !isProfile;
                          setState(() {});
                          // showModalBottomSheet(
                          //     context: context,
                          //     shape: const RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.only(
                          //             topLeft: Radius.circular(20),
                          //             topRight: Radius.circular(20))),
                          //     builder: (context) =>
                          //         ChangeNotifierProvider.value(
                          //           value: model,
                          //           child: ShowQRCodeView(),
                          //         ));
                          debugPrint("QR code share");
                        },
                        child: Icon(
                          isProfile ? Icons.share : Icons.group,
                          size: 15,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          isScanner = !isScanner;
                          setState(() {
                            
                          });
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             ChangeNotifierProvider.value(
                          //               value: model,
                          //               child: QrCodeScanner(),
                          //             )));
                          // debugPrint("Scan QR code");
                        },
                        child: Icon(
                          Icons.qr_code_scanner,
                          size: 15,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      );
    });
  }
}

class CustomLabel extends StatelessWidget {
  CustomLabel(
      {super.key,
      required this.title,
      required this.information,
      this.forGroupTags = false});

  final String title;
  final String information;
  bool forGroupTags;

  @override
  Widget build(BuildContext context) {
    if (!forGroupTags) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              information,
              style: Theme.of(context).textTheme.labelMedium,
              softWrap: true,
              maxLines: 5,
            ),
            Divider(
              thickness: 1.5,
              color: Theme.of(context).colorScheme.secondary,
              height: 20,
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 18, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      );
    }
  }
}

class HeadShot extends StatelessWidget {
  // bool forGroupProfile;
  const HeadShot({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, model, child) => Center(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(model.workspaceName,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                  const SizedBox(height: 1),
                  model.realName != "unkonwn"
                      ? model.isPersonalAccount
                          ? Text(model.realName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold))
                          : const SizedBox()
                      : const SizedBox()
                ],
              ),
              CircleAvatar(
                radius: 60,
                backgroundImage: model.profileImage.isNotEmpty
                    ? Image.memory(model.profileImage).image
                    : Image.asset("assets/images/profile_male.png").image,
              )
            ],
          ),
        ],
      )),
    );
  }
}
