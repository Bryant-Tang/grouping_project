import 'package:flutter/material.dart';

import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/View/profile/profile_edit_view.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/View/testing/empty.dart';

import 'package:provider/provider.dart';

class ProfileDispalyPageView extends StatefulWidget {
  const ProfileDispalyPageView({super.key});
  @override
  State<ProfileDispalyPageView> createState() => ProfileDispalyPageViewState();
}

class ProfileDispalyPageViewState extends State<ProfileDispalyPageView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
        builder: (context, model, child) {
      List tags = List.from(model.tags);
      if (model.introduction != "unknown") {
        tags.insert(0, AccountTag(tag: "自我介紹", content: model.introduction));
      }
      if (model.slogan != "unknown") {
        tags.insert(0, AccountTag(tag: "座右銘", content: model.slogan));
      }
      // TODO : 把他寫進 VM 裡面
      // debugPrint(tags.toString());
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
                  const HeadShot(),
                  Column(
                    children: tags
                        .map((accountTag) => CustomLabel(
                            title: accountTag.tag,
                            information: accountTag.content))
                        .toList(),
                  ),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QRView(
                                        workspaceDashBoardViewModel: model,
                                      )));
                          debugPrint("QR code share");
                        },
                        child: Icon(
                          Icons.share,
                          size: 15,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QrCodeScanner(
                                        workspaceDashBoardViewModel: model,
                                      )));
                          debugPrint("Scan QR code");
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
  const CustomLabel(
      {super.key, required this.title, required this.information});

  final String title;
  final String information;

  @override
  Widget build(BuildContext context) {
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
  }
}

class HeadShot extends StatelessWidget {
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
                      ? Text(model.realName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold))
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
