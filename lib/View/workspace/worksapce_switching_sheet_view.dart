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
                    child: Text('WOKSPACE',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                ),
                const Divider(thickness: 2, indent: 20, endIndent: 20),
                ListView.builder(
                  clipBehavior: Clip.hardEdge,
                  itemBuilder: (context, index) {
                    return GroupSwitcherView(
                        groupProfile: model.allGroupProfile.elementAt(index));
                  },
                  itemCount: model.allGroupProfile.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                ),
                MaterialButton(
                    onPressed: () async {
                      // debugPrint("create group");
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreateWorkspacePage()));
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}

class GroupSwitcherView extends StatelessWidget {
  // TODO : 將 color 抽離出來
  final AccountModel groupProfile;
  const GroupSwitcherView({Key? key, required this.groupProfile})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
        builder: (context, model, child) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: MaterialButton(
                onPressed: model.switchGroup,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    // implement shadow Border
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(groupProfile.color),
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
                                Text(groupProfile.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontWeight: FontWeight.bold)),
                                Text(groupProfile.introduction,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ))
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: (groupProfile.tags)
                                  .map((tag) => ColorTagChip(
                                      tagString: tag.tag,
                                      color: Color(groupProfile.color)))
                                  .toList(),
                            )
                          ],
                        )
                      ]),
                ),
              ),
            ));
  }
}
