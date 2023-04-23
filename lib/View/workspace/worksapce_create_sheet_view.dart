import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouping_project/VM/event_setting_view_model.dart';
import 'package:grouping_project/VM/mission_setting_view_model.dart';
import 'package:grouping_project/VM/workspace/workspace_dashboard_view_model.dart';
import 'package:grouping_project/View/event_setting_view.dart';
import 'package:grouping_project/View/mission_setting_view.dart';
import 'package:grouping_project/components/card_view/event/event_card.dart';
import 'package:provider/provider.dart';

class CreateButton extends StatefulWidget {
  const CreateButton({super.key});

  @override
  State<CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> {
  // TODO: make every widget to stateful widget
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, model, child) => FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              // isScrollControlled: true,
              context: context,
              barrierColor: Colors.black.withOpacity(0.2),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              builder: (BuildContext context) {
                return ChangeNotifierProvider<
                    WorkspaceDashBoardViewModel>.value(
                  value: model,
                  child: const CreateButtonSheetView(),
                );
              });
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}

class CreateButtonTemplate extends StatelessWidget {
  final String title;
  final String descroption;
  final String assestPath;
  final void Function() onTap;
  // final Widget child;
  const CreateButtonTemplate({
    super.key,
    required this.title,
    required this.descroption,
    required this.assestPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              // backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 6,
              // primary: color,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            // borderRadius: BorderRadius.circular(5),
            ),
            onPressed: onTap,
            // splashFactory: InkRipple.splashFactory,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) => SizedBox(
                      width: constraints.maxWidth,
                      child: Image.asset(assestPath),
                      )
                  ),
                  Text(title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    descroption,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateButtonSheetView extends StatelessWidget {
  const CreateButtonSheetView({Key? key}) : super(key: key);
  void createEvent(
      WorkspaceDashBoardViewModel model, BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider<WorkspaceDashBoardViewModel>.value(
                      value: model,
                    ),
                    ChangeNotifierProvider<EventSettingViewModel>(
                      create: (context) => EventSettingViewModel()
                      ..initializeNewEvent (
                          creatorAccount: model.personalprofileData,
                          ownerAccount: model.accountProfileData,
                      )
                    ),
                  ],
                  child: const EditCardView(),
                ))));
    // Implement data refreash
    // await model.getAllData();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void createMission(
      WorkspaceDashBoardViewModel model, BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => MultiProvider(
                  providers: [
                    // ChangeNotifierProvider<
                    //     WorkspaceDashBoardViewModel>.value(
                    //   value: model,
                    // ),
                    ChangeNotifierProvider<MissionSettingViewModel>(
                      create: (context) => MissionSettingViewModel.create(
                          accountProfile: model.accountProfileData)
                        ..isForUser = model.isPersonalAccount,
                    ),
                  ],
                  child: const MissionSettingPageView(),
                ))));
    // Implement data refreash
    await model.getAllData();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void createTopic(WorkspaceDashBoardViewModel model, BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('此功能施工中盡請期待'),
      ),
    );
  }

  void createNote(WorkspaceDashBoardViewModel model, BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('此功能施工中盡請期待'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, model, child) => SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
          child: Column(children: [
            Container(
              height: 12,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
            ),
            Center(
                child: Text(
              'CREATE 創建',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            )),
            Row(
              children: [
                CreateButtonTemplate(
                  title: '事件 EVENT',
                  descroption: '開啟一個meeting或設立某些重大事件，確保組員們都空出時間。',
                  assestPath: 'assets/images/Event.png',
                  onTap: () => createEvent(model, context),
                ),
                CreateButtonTemplate(    
                  title: '任務 MISSION',
                  descroption: '建立一個新的任務、作業、里程碑，利用狀態來去做追蹤。',
                  assestPath: 'assets/images/Mission.png',
                  onTap: () => createMission(model, context),
                ) // const CreateEvent()
              ],
            ),
            Row(
              children: [
                CreateButtonTemplate(
                  title: '話題 TOPIC',
                  descroption: '與夥伴們任意開啟一個話題、指定任務、事件，或聊聊新的idea吧。',
                  assestPath: 'assets/images/topic.png',
                  onTap: () => createTopic(model, context),
                ),
                CreateButtonTemplate(
                  title: '筆記 NOTE',
                  descroption: '與夥伴們建立共同筆記，共享知識庫，合作編輯會議記錄。',
                  assestPath: 'assets/images/Note.png',
                  onTap: () => createNote(model, context),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}


// class CreateTopic extends StatelessWidget {
//   const CreateTopic({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(5),
//       onTap: () {
//         debugPrint('create Topic');
//       },
//       splashFactory: InkRipple.splashFactory,
//       child: Card(
//         child: Container(
//           width: 190,
//           height: 300,
//           color: const Color(0xFFFFE3E5),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.asset('assets/images/topic.png'),
//               const SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 padding: const EdgeInsets.only(left: 5),
//                 child: const Text(
//                   '話題 TOPIC',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//               ),
//               Container(
//                   padding: const EdgeInsets.all(5),
//                   child: const Text(
//                     '與夥伴們任意開啟一個話題、指定任務、事件，或聊聊新的idea吧。',
//                     softWrap: true,
//                     style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CreateNote extends StatelessWidget {
//   const CreateNote({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(5),
//       onTap: () {
//         debugPrint('create Note');
//       },
//       splashFactory: InkRipple.splashFactory,
//       child: Card(
//         child: Container(
//           width: 190,
//           height: 300,
//           color: const Color(0xFFFEFFF8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.asset('assets/images/Note.png'),
//               const SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 padding: const EdgeInsets.only(left: 5),
//                 child: const Text(
//                   '筆記 NOTE',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//               Container(
//                   padding: const EdgeInsets.all(5),
//                   child: const Text(
//                     '與夥伴們建立共同筆記，共享知識庫，合作編輯會議記錄。',
//                     softWrap: true,
//                     style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
