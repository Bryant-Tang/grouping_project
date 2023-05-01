import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/View/auth/login_view.dart';
import 'package:grouping_project/View/profile/create_group_view.dart';
import 'package:grouping_project/components/color_tag_chip.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SwitchWorkSpaceSheet extends StatefulWidget {
  const SwitchWorkSpaceSheet({Key? key}) : super(key: key);

  @override
  State<SwitchWorkSpaceSheet> createState() => _SwitchWorkSpaceSheetState();
}

class _SwitchWorkSpaceSheetState extends State<SwitchWorkSpaceSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, model, child) => SafeArea(
        child: SingleChildScrollView(
          child: Container(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.fromLTRB(3, 3, 3, 0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 12,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                      child: Text('WORKSPACE',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Divider(thickness: 2, indent: 20, endIndent: 20),
                  Column(
                    children: List.generate(
                        model.allGroupProfile.length, (index) => GroupSwitcherView(
                          accountModel: model.allGroupProfile.elementAt(index))),
                  ),
                  MaterialButton(
                      onPressed: () async {
                        // debugPrint("create group");
                        final res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CreateWorkspacePage()));
                        if (context.mounted) {
                          Navigator.of(context).pop(res);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            size: 25,
                            Icons.add_box_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(width: 10),
                          Text("創建新的工作小組",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(fontWeight: FontWeight.bold))
                        ],
                      )),
                  MaterialButton(
                      // color: Theme.of(context).colorScheme.errorContainer,
                      onPressed: () async {
                        await model.signOut();
                        if (context.mounted) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            size: 25,
                            Icons.logout_outlined,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: 10),
                          Text("登出此帳號",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.error))
                        ],
                      )),
                ]),
          ),
        ),
      ),
    );
  }
}

class GroupSwitcherView extends StatelessWidget {
  final AccountModel accountModel;
  const GroupSwitcherView({Key? key, required this.accountModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(builder: (context, themeVM, child) {
      ThemeData themeData = ThemeData(
          colorSchemeSeed: Color(accountModel.color),
          brightness: themeVM.brightness);
      return Consumer<WorkspaceDashBoardViewModel>(
          builder: (context, model, child) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: Card(
                  color: accountModel.id != model.accountProfileData.id 
                    ? themeData.colorScheme.surface
                    : themeData.colorScheme.surfaceVariant,
                  child: MaterialButton(
                    onPressed: () {
                      themeVM.updateColorSchemeSeed(Color(accountModel.color));
                      model.switchGroup(accountModel);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(accountModel.color),
                              backgroundImage: accountModel.photo.isNotEmpty
                                  ? Image.memory(accountModel.photo).image
                                  : Image.asset("assets/images/profile_male.png")
                                      .image,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(accountModel.nickname,
                                        style: themeData.textTheme.titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold)),
                                    accountModel.id == model.personalprofileData.id ? const SizedBox() :
                                    Text(accountModel.introduction,
                                        style: themeData.textTheme.titleSmall!
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ))
                                  ],
                                ),
                                const SizedBox(height: 5),
                                accountModel.id == model.personalprofileData.id ? const SizedBox()
                                : Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: (accountModel.tags)
                                      .map((tag) => ColorTagChip(
                                          tagString: tag.tag,
                                          color: themeData.colorScheme.primary))
                                      .toList(),
                                )
                              ],
                            )
                          ]),
                    ),
                  ),
                ),
              ));
    });
  }
}
