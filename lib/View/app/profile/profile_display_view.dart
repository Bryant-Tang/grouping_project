import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/profile/profile_edit_view.dart';
import 'package:grouping_project/ViewModel/profile/profile_view_model_lib.dart';

// import 'package:grouping_project/View/profile/profile_edit_view.dart';
import 'package:grouping_project/ViewModel/workspace/workspace_view_model_lib.dart';
import 'package:grouping_project/model/auth/account_model.dart';
// import 'package:grouping_project/model/model_lib.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class ProfileDispalyPageView extends StatefulWidget {
  const ProfileDispalyPageView({super.key});
  @override
  State<ProfileDispalyPageView> createState() => ProfileDispalyPageViewState();
}

class ProfileDispalyPageViewState extends State<ProfileDispalyPageView> {
  /// get the switched buttom sheet content
  Widget getContent(
      {required QRViewModel model,
      required WorkspaceDashBoardViewModel value}) {
    if (!model.isShare && !model.isScanner) {
      List tags = List.from(value.tags);
      List tagWithoutTitles = tags;

      if (value.introduction != "unknown") {
        if (value.isPersonalAccount) {
          tags.insert(0, AccountTag(tag: "自我介紹", content: value.introduction));
        } else {
          debugPrint('It\'s a group account');
          tags.insert(0, AccountTag(tag: "小組簡介", content: value.introduction));
        }
      }
      if (value.slogan != "unknown") {
        if (value.isPersonalAccount) {
          tags.insert(0, AccountTag(tag: "座右銘", content: value.slogan));
        } else {
          debugPrint('It\'s a group account');
          tags.insert(0, AccountTag(tag: "小組口號", content: value.slogan));
        }
      }
      if (value.isPersonalAccount) {
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
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: value.accountProfileData.associateEntityAccount
                  .map(
                    (account) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                    backgroundImage: account.photo.isEmpty
                                        ? Image.asset(
                                                'assets/images/profile_male.png')
                                            .image
                                        : Image.memory(account.photo).image),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  account.nickname,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Divider(
                              thickness: 1.5,
                              color: Theme.of(context).colorScheme.secondary,
                              height: 20,
                            ),
                          ],
                        )),
                  )
                  .toList()),
        ]);
      }
    } else if (model.isShare) {
      return ChangeNotifierProvider<WorkspaceDashBoardViewModel>.value(
        value: value,
        child: const ShowQRCodeView(),
      );
    } else {
      return ChangeNotifierProvider<WorkspaceDashBoardViewModel>.value(
        value: value,
        child: const QrCodeScanner(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, value, child) => ChangeNotifierProvider<QRViewModel>(
          create: (context) =>
              QRViewModel()..setShareIndicator(targetIndicator: false),
          builder: (context, child) => Consumer<QRViewModel>(
                builder: (context, model, child) {
                  return SafeArea(
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      margin: const EdgeInsets.fromLTRB(3, 3, 3, 0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
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
                              getContent(model: model, value: value),
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
                                                    model:
                                                        ProfileEditViewModel()
                                                          ..profile = value
                                                              .accountProfile),
                                          ));
                                      await value.getAllData();
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          model.setShareIndicator();
                                          debugPrint("QR code share");
                                        },
                                        child: Icon(
                                          model.isShare
                                              ? Icons.group
                                              : Icons.share,
                                          size: 15,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        model.setScannerIndicator();
                                        debugPrint("Scan QR code");
                                      },
                                      child: Icon(
                                        model.isScanner
                                            ? Icons.group
                                            : Icons.qr_code_scanner,
                                        size: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ]),
                      ),
                    ),
                  );
                },
              )),
    );
  }
}

class CustomLabel extends StatelessWidget {
  CustomLabel(
      {super.key,
      required this.title,
      required this.information,
      this.forGroupTags = false});

  Widget? child;
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

class ShowQRCodeView extends StatefulWidget {
  const ShowQRCodeView({
    super.key,
  });

  @override
  State<ShowQRCodeView> createState() => _ShowQRCodeViewState();
}

class _ShowQRCodeViewState extends State<ShowQRCodeView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, value, child) => ChangeNotifierProvider<QRViewModel>(
        create: (_) => QRViewModel(),
        builder: (context, child) => Consumer<QRViewModel>(
          builder: (context, qrcodeVM, child) {
            debugPrint('Trying to show QR code');
            if (value.isPersonalAccount == false) {
              debugPrint('Printing group id, ${value.accountProfile.id}');
              qrcodeVM.showGroupId(value.accountProfile.id);
              qrcodeVM.updateWelcomeMessage(
                  'Welcome to ${value.accountProfile.name}!');
            } else {
              debugPrint('It\'s personal account');
              qrcodeVM.showGroupId('https://reurl.cc/EG3gy1');
              qrcodeVM.updateWelcomeMessage('You should not be here!');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrImage(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  data: qrcodeVM.stringToShow,
                  version: QrVersions.auto,
                  size: 200,
                  gapless: false,
                ),
                Text(qrcodeVM.welcomeMessage,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                // Padding(
                //     padding: const EdgeInsets.only(top: 20),
                //     child: ElevatedButton(
                //       onPressed: () => Navigator.pop(context),
                //       child: const Text('Go Back'),
                //     )),
              ],
            );
          },
        ),
      ),
    );
  }
}

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerrState();
}

class _QrCodeScannerrState extends State<QrCodeScanner> {
  MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, value, child) => ChangeNotifierProvider(
        create: (context) => QRViewModel(),
        builder: (context, child) => Consumer<QRViewModel>(
          builder: (context, qrcodeVM, child) {
            qrcodeVM.setPersonalModel(value.personalprofileData);
            return SizedBox(
              height: MediaQuery.of(context).size.width * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
              child: MobileScanner(
                controller: controller,
                onDetect: (capture) async {
                  qrcodeVM.updateBarcode(capture.barcodes[0].rawValue ?? '');
                  controller.stop();
                  await qrcodeVM.setGroupModel();
                  // debugPrint(
                  //     '=> Barcode detected: ${model.code}');
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                            '您已被邀請加入${qrcodeVM.groupAccountModel.nickname}'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('取消')),
                          TextButton(
                              onPressed: () async {
                                // model.addAssociation();
                                await value.addGroupViaQR(
                                    qrcodeVM.code, qrcodeVM.groupAccountModel);
                                if (mounted) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('確認'))
                        ],
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
