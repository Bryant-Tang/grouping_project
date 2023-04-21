import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/View/profile/profile_display_view.dart';
import 'package:grouping_project/components/button/overview_choice_button.dart';

// progress card

// show frame of widget
// import 'package:flutter/rendering.dart';

// 測試新功能用，尚未完工，請勿使用或刪除
import 'package:grouping_project/View/testing/empty.dart';

import 'package:flutter/material.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_event_page.dart';
import 'package:grouping_project/pages/home/personal_dashboard/personal_mission_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({Key? key}) : super(key: key);

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   @override
//   Widget build(BuildContext context) {
//     return PageView(
//       scrollDirection: Axis.vertical,
//       controller: PageController(initialPage: 1),
//       children: const [
//         ProfileDispalyPageView(),
//         PeronalDashboardPage(),
//       ],
//     );
//   }
// }

class WorkspaceDashboardPageView extends StatefulWidget {
  const WorkspaceDashboardPageView({super.key});
  @override
  State<WorkspaceDashboardPageView> createState() =>
      _PeosonalDashboardPageState();
}

class _PeosonalDashboardPageState extends State<WorkspaceDashboardPageView> {
  @override
  Widget build(BuildContext context) {
    // show the from of widget
    // debugPaintSizeEnabled = true;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Expanded(flex: 1, child: Progress()),
          Expanded(flex: 3, child: OverView()),
        ]);
  }
}

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PRGRESSING',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const Divider(
            thickness: 2,
          ),
          const Expanded(
            child: ProgressingPageView(),
          )
        ],
      ),
    );
  }
}

class ProgressingPageView extends StatefulWidget {
  const ProgressingPageView({super.key});

  @override
  State<ProgressingPageView> createState() => _ProgressingPageViewState();
}

class _ProgressingPageViewState extends State<ProgressingPageView> {
  @override
  Widget build(BuildContext context) {
    return PageView(children: const [
      ProgressingCard(
        colorSeed: Color(0xFF38A0FF),
      ),
      ProgressingCard(
        colorSeed: Colors.red,
      ),
      ProgressingCard(
        colorSeed: Colors.green,
      ),
      ProgressingCard(
        colorSeed: Colors.amber,
      ),
      ProgressingCard(
        colorSeed: Colors.black,
      ),
    ]);
  }
}

class ProgressingCard extends StatefulWidget {
  const ProgressingCard({super.key, required this.colorSeed});
  final Color colorSeed;

  @override
  State<ProgressingCard> createState() => _ProgressingCardState();
}

class _ProgressingCardState extends State<ProgressingCard> {
  final objectType = 'Event';

  final relatedMissionNumber = 10;

  final relatedMissionFinishedNumber = 4;

  final relatedNoteNumber = 3;

  final relatedMessageNumber = 4;

  final eventTitle = '教授meeting 報告';

  // final colorSeed = const Color(0xFF38A0FF);
  ThemeData themeData = ThemeData();

  Widget getTagWidget() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 6, 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: themeData.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: themeData.colorScheme.primary, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: themeData.colorScheme.onPrimaryContainer,
                radius: 3,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                '個人專區 - 事件',
                style: themeData.textTheme.labelSmall!.copyWith(
                    color: themeData.colorScheme.onPrimaryContainer,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }

  Widget getTitle() {
    return Text(
      eventTitle,
      style: themeData.textTheme.titleLarge!.copyWith(
          color: themeData.colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.bold),
    );
  }

  Widget getDateTime() {
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formatted = formatter.format(DateTime.now());
    final endDate = DateTime(2023, 4, 18, 9, 30, 0);
    final startDate = DateTime.now();
    final duration = endDate.difference(startDate);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return Row(
      children: [
        Icon(Icons.timer, color: themeData.colorScheme.secondary, size: 16),
        const SizedBox(width: 4),
        Text(
          '${days.toString().padLeft(2, '0')} D ${hours.toString().padLeft(2, '0')} H ${minutes.toString().padLeft(2, '0')} M ${seconds.toString().padLeft(2, '0')} S',
          style: themeData.textTheme.labelSmall!.copyWith(
              fontSize: 12,
              color: themeData.colorScheme.secondary,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget getDashBoard() {
    final filter =
        ColorFilter.mode(themeData.colorScheme.secondary, BlendMode.srcIn);
    const iconSize = 25.0;
    final iconLabelStyle =
        themeData.textTheme.labelSmall!.copyWith(fontSize: 8);
    final numberStyle = themeData.textTheme.titleLarge!.copyWith(
        fontSize: 20,
        color: themeData.colorScheme.primary,
        fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SvgPicture.asset(
                'assets/icons/task.svg',
                width: iconSize,
                colorFilter: filter,
              ),
              Text('相關任務', style: iconLabelStyle)
            ],
          ),
          Text(
            relatedMissionNumber.toString(),
            style: numberStyle,
          ),
          Column(
            children: [
              SvgPicture.asset(
                'assets/icons/messagetick.svg',
                width: iconSize,
                colorFilter: filter,
              ),
              Text('相關話題', style: iconLabelStyle)
            ],
          ),
          Text(
            relatedMessageNumber.toString(),
            style: numberStyle,
          ),
          Column(
            children: [
              SvgPicture.asset(
                'assets/icons/appBar/note.svg',
                width: iconSize,
                colorFilter: filter,
              ),
              Text('相關筆記', style: iconLabelStyle)
            ],
          ),
          Text(
            relatedNoteNumber.toString(),
            style: numberStyle,
          ),
        ],
      ),
    );
  }

  Widget getCircularProgresIndicator() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              value: (relatedMissionFinishedNumber / relatedMissionNumber),
              strokeWidth: 8,
              backgroundColor: themeData.colorScheme.primary.withOpacity(0.2),
              valueColor:
                  AlwaysStoppedAnimation<Color>(themeData.colorScheme.primary),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            '${(relatedMissionFinishedNumber / relatedMissionNumber * 100).round()}%',
            style: themeData.textTheme.titleSmall!.copyWith(
                color: themeData.colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  final Stream<DateTime> _currentTimeStream = Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
  @override
  Widget build(BuildContext context) {
    // DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    // String formatted = formatter.format(DateTime.now());

    return Consumer<ThemeManager>(builder: (context, themeManager, _) {
      themeData = ThemeData(
          colorSchemeSeed: widget.colorSeed,
          brightness: themeManager.brightness);
      return StreamBuilder<DateTime>(
          stream: _currentTimeStream,
          builder: (context, snapshot) {
            return Card(
                color: themeData.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        // data part of the info card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getTagWidget(),
                            getTitle(),
                            getDateTime(),
                            getDashBoard(),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Center(
                            child: getCircularProgresIndicator(),
                          )),
                    ],
                  ),
                ));
          });
    });
  }
}

class OverView extends StatefulWidget {
  const OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  int overViewIndex = 0;
  late int eventNumbers = 0;
  late int missionNumbers = 0;

  // DatabaseService db = DatabaseService();

  List<Widget> pages = [
    const EventPage(),
    const MissionPage(),
    ListView(
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        ),
      ],
    ),
  ];

  final line = const Divider(
    height: 1,
    thickness: 2,
  );

  final buttonInfo = {
    'event': {
      'label': '事件 - 即將到來',
      'icon': 'assets/icons/calendartick.svg',
      'number': '0',
    },
    'mission': {
      'label': '任務 - 即將到來',
      'icon': 'assets/icons/task.svg',
      'number': '1',
    },
    'group': {
      'label': '群組 - 即將到來',
      'icon': 'assets/icons/messagetick.svg',
      'number': '2',
    },
  };
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Consumer<WorkspaceDashBoardViewModel>(
        builder: (context, model, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('OVERVIEW',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            line,
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: buttonInfo.entries
                    .map((entry) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: OverViewChoiceButton(
                              onTap: () {
                                model.updateOverViewIndex(int.parse(
                                    entry.value['number']!)); // setEnable(0);
                              },
                              labelText: entry.value['label']!,
                              iconPath: entry.value['icon']!,
                              numberText: model.dashboardEventList.length,
                              isSelected: int.parse(entry.value['number']!) ==
                                  model.overView,
                            ),
                          ),
                        ))
                    .toList()),
            Expanded(
              flex: 4,
              child: Container(child: pages[model.overViewIndex]),
            )
          ],
        ),
      ),
    );
  }
}

// 待確認是否應該是要將 listview 放在 container 裡面
// List<Widget> pages = [
// Expanded(child: ListView(children: const [EventPage()])),
// Expanded(child: ListView(
//   children: const [MissionPage()],
// )),
// ListView(
//   children: [
//     Container(
//       height: 100,
//       decoration: BoxDecoration(border: Border.all(color: Colors.black)),
//     ),
//     const EventPage(),
//     // CardViewTemplate(detailShrink: EventInformationShrink(eventModel: EventModel()), detailEnlarge: EventInformationEnlarge(eventModel: EventModel()))
//   ],
// ),
//   const EventPage(),
//   ListView(
//     children: [
//       Container(
//         height: 100,
//         decoration: BoxDecoration(border: Border.all(color: Colors.red)),
//       ),
//     ],
//   ),
//   ListView(
//     children: [
//       Container(
//         height: 100,
//         decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
//       ),
//     ],
//   ),
// ];