import 'package:flutter/material.dart';
import 'package:grouping_project/VM/event_setting_view_model.dart';
import 'package:grouping_project/VM/workspace/workspace_dashboard_view_model.dart';
import 'package:grouping_project/View/event_setting_view.dart';
import 'package:grouping_project/View/mission_setting_view.dart';
import 'package:provider/provider.dart';

class CreateButtonTemplate extends StatelessWidget {
  final Color color;
  final String title;
  final String assestPath;
  final Widget child;
  const CreateButtonTemplate(
      {Key? key,
      required this.color,
      required this.title,
      required this.assestPath,
      required this.child})
      : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
}

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
          // color: Color(0xFFFFFFFF),
          size: 30,
        ),
      ),
    );
  }
}

class CreateButtonSheetView extends StatelessWidget {
  const CreateButtonSheetView({Key? key}) : super(key: key);
  final List<Widget> createsPng = const [
    CreateTopic(), //not yet
    CreateEvent(),
    CreateNote(), //not yet
    CreateMission()
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, model, child) => SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
          child: Column(children: [
            Container(
              // width: MediaQuery.of(context).size.width,
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
              children: const [CreateMission(), CreateEvent()],
            ),
            Row(
              children: const [CreateNote(), CreateTopic()],
            )
            // GridView.count(
            //     crossAxisCount: 2, // 設置每行顯示的元素個數
            //     childAspectRatio: 1.0, // 設置元素的寬高比例為1:1
            //     children: List.generate(6, (index) =>
            //       Container(
            //         color: Colors.blue,
            //         margin: EdgeInsets.all(8.0),
            //       )
            //     )
            // ),
          ]),
        ),
      ),
    );
  }
}

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, model, child) => InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () async {
          // debugPrint('create event');
          // debugPrint(model.accountProfileData.id);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider<
                              WorkspaceDashBoardViewModel>.value(
                            value: model,
                          ),
                          ChangeNotifierProvider<EventSettingViewModel>(
                            create: (context) => EventSettingViewModel.create(
                                accountProfile: model.accountProfileData)
                              ..isForUser = model.isPersonalAccount,
                          ),
                        ],
                        child: EventSettingPageView(),
                      ))));
          // Implement data refreash
          await model.getAllData();
          if (mounted) {
            Navigator.pop(context);
          }
        },
        splashFactory: InkRipple.splashFactory,
        child: Card(
          child: Container(
            width: 190,
            height: 300,
            color: const Color(0xFFD9EDFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/Event.png'),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: const Text(
                    '事件 EVENT',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                      '開啟一個meeting或設立某些重大事件，確保組員們都空出時間。',
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateMission extends StatefulWidget {
  const CreateMission({super.key});

  @override
  State<CreateMission> createState() => _CreateMissionState();
}

class _CreateMissionState extends State<CreateMission> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, model, child) => InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () async {
          debugPrint('create mission');
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => MissionSettingPageView.create(
                        accountProfile: model.accountProfileData,
                      ))));
          setState(() {});
        },
        splashFactory: InkRipple.splashFactory,
        child: Card(
          child: Container(
            width: 190,
            height: 300,
            color: const Color(0xFFFFE8D8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/Mission.png'),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: const Text(
                    '任務 MISSION',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                      '建立一個新的任務、作業、里程碑，利用狀態來去做追蹤。',
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateTopic extends StatelessWidget {
  const CreateTopic({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () {
        debugPrint('create Topic');
      },
      splashFactory: InkRipple.splashFactory,
      child: Card(
        child: Container(
          width: 190,
          height: 300,
          color: const Color(0xFFFFE3E5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/topic.png'),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: const Text(
                  '話題 TOPIC',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    '與夥伴們任意開啟一個話題、指定任務、事件，或聊聊新的idea吧。',
                    softWrap: true,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class CreateNote extends StatelessWidget {
  const CreateNote({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () {
        debugPrint('create Note');
      },
      splashFactory: InkRipple.splashFactory,
      child: Card(
        child: Container(
          width: 190,
          height: 300,
          color: const Color(0xFFFEFFF8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/Note.png'),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: const Text(
                  '筆記 NOTE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    '與夥伴們建立共同筆記，共享知識庫，合作編輯會議記錄。',
                    softWrap: true,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
