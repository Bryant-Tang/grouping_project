import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/workspace/EditableCard/mission_card_view.dart';
import 'package:grouping_project/View/app/workspace/EditableCard/event_card_view.dart';
import 'package:grouping_project/View/components/button/overview_choice_button.dart';
import 'package:grouping_project/View/theme/theme_manager.dart';
import 'package:grouping_project/ViewModel/workspace/event_view_model.dart';
import 'package:grouping_project/ViewModel/workspace/mission_view_model.dart';
import 'package:grouping_project/ViewModel/workspace/workspace_dashboard_view_model.dart';
import 'package:provider/provider.dart';

// progress card

// show frame of widget

class WorkspaceDashboardPageView extends StatefulWidget {
  const WorkspaceDashboardPageView({super.key});

  @override
  State<WorkspaceDashboardPageView> createState() =>
      _WorkspaceDashboardPageViewState();
}

class _WorkspaceDashboardPageViewState
    extends State<WorkspaceDashboardPageView> {
  @override
  Widget build(BuildContext context) {
    // show the form of widget
    // debugPaintSizeEnabled = true;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          // adjust child size
          // ref. https://stackoverflow.com/questions/52645944/flutter-expanded-vs-flexible
          // TODO: or just use device size to detemine the flex?
          Flexible(flex: 1, child: Progress()),
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
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (_, model, child) {
        List<Widget> _allObject = [];
        _allObject.addAll(model.events
            .map((eventModel) => ChangeNotifierProvider<EventSettingViewModel>(
                create: (context) => EventSettingViewModel()
                  ..initializeDisplayEvent(
                      model: eventModel, user: model.personalprofileData),
                child: const EventProgressingCard()))
            .toList());
        _allObject.addAll(model.missions
            .map((missionModel) =>
                ChangeNotifierProvider<MissionSettingViewModel>(
                    create: (context) => MissionSettingViewModel()
                      ..initializeDisplayMission(
                          model: missionModel, user: model.personalprofileData),
                    child: const MissionProgressingCard()))
            .toList());
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          // TODO: give minimul height
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.23),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('PROGRESSING',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
                )),
                const Divider(
          thickness: 2,
                ),
                Expanded(
            child: _allObject.isNotEmpty
            ? PageView(children: _allObject)
            : const Center(child:Text('你還未建立任何事件或任務'))
                ),
              ]),
        );
      },
    );
  }
}

class EventProgressingCard extends StatefulWidget {
  const EventProgressingCard({super.key});

  @override
  State<EventProgressingCard> createState() => _EventProgressingCardState();
}

class _EventProgressingCardState extends State<EventProgressingCard> {
  // final colorSeed = const Color(0xFF38A0FF);
  ThemeData themeData = ThemeData();

  Widget getTagWidget(String tagName) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 6, 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            // color: themeData.colorScheme.primaryContainer,
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
                tagName,
                style: themeData.textTheme.labelSmall!.copyWith(
                    color: themeData.colorScheme.onPrimaryContainer,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }

  Widget getTitle(String title) {
    return Text(
      title,
      style: themeData.textTheme.titleLarge!.copyWith(
          color: themeData.colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.bold),
    );
  }

  Widget getDashBoard(EventSettingViewModel model) {
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
            model.eventModel.relatedMissionIds.length.toString(),
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
            model.eventModel.notifications.length.toString(),
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
            model.eventModel.notifications.length.toString(),
            style: numberStyle,
          ),
        ],
      ),
    );
  }

  Widget getCircularProgresIndicator(EventSettingViewModel model) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              value: model.onTimePercentage(),
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
            '${(model.onTimePercentage() * 100).round()}%',
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
    return Consumer<EventSettingViewModel>(
      builder: (context, model, child) {
        themeData = ThemeData(
            colorSchemeSeed: model.color,
            brightness: context.watch<ThemeManager>().brightness);
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
                          flex: 3,
                          // data part of the info card
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getTagWidget(
                                  '${model.eventModel.ownerAccount.nickname} - 事件'),
                              Text(
                                model.title,
                                style: themeData.textTheme.titleLarge!.copyWith(
                                    color: themeData.colorScheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.timer,
                                      color: themeData.colorScheme.secondary,
                                      size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    model.getTimerCounter(),
                                    style: themeData.textTheme.labelSmall!
                                        .copyWith(
                                            fontSize: 12,
                                            color:
                                                themeData.colorScheme.secondary,
                                            fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              getDashBoard(model),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Center(
                              child: model.onTime()
                                  ? getCircularProgresIndicator(model)
                                  : const SizedBox(),
                            )),
                      ],
                    ),
                  ));
            });
      },
    );
  }
}

class MissionProgressingCard extends StatefulWidget {
  const MissionProgressingCard({super.key});

  @override
  State<MissionProgressingCard> createState() =>
      _MissionProgressingCardCardState();
}

class _MissionProgressingCardCardState extends State<MissionProgressingCard> {
  // final colorSeed = const Color(0xFF38A0FF);
  ThemeData themeData = ThemeData();

  Widget getTagWidget(String tagName) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 6, 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            // color: themeData.colorScheme.primaryContainer,
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
                tagName,
                style: themeData.textTheme.labelSmall!.copyWith(
                    color: themeData.colorScheme.onPrimaryContainer,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }

  Widget getTitle(String title) {
    return Text(
      title,
      style: themeData.textTheme.titleLarge!.copyWith(
          color: themeData.colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.bold),
    );
  }

  Widget getDashBoard(MissionSettingViewModel model) {
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
            model.missionModel.childMissionIds.length.toString(),
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
            model.missionModel.notifications.length.toString(),
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
            model.missionModel.notifications.length.toString(),
            style: numberStyle,
          ),
        ],
      ),
    );
  }

  Widget getCircularProgresIndicator(MissionSettingViewModel model) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              value: 0,
              // TODO : implement this progressbar value
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
            '${0}%',
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
    return Consumer<MissionSettingViewModel>(
      builder: (context, model, child) {
        themeData = ThemeData(
            colorSchemeSeed: model.stageColorMap[model.stateModel.stage],
            brightness: context.watch<ThemeManager>().brightness);
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
                          flex: 3,
                          // data part of the info card
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getTagWidget(
                                  '${model.ownerAccountName} - ${model.stateModel.stateName}'),
                              Text(
                                model.title,
                                style: themeData.textTheme.titleLarge!.copyWith(
                                    color: themeData.colorScheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.timer,
                                      color: themeData.colorScheme.secondary,
                                      size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    model.getTimerCounter(),
                                    style: themeData.textTheme.labelSmall!
                                        .copyWith(
                                            fontSize: 12,
                                            color:
                                                themeData.colorScheme.secondary,
                                            fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              getDashBoard(model),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Center(
                                child: getCircularProgresIndicator(model))),
                      ],
                    ),
                  ));
            });
      },
    );
  }
}

class OverView extends StatefulWidget {
  const OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  List<Widget> pages = const [
    EventListView(),
    MissionListView(),
    // MissionListView(),
    // Image.asset('assets/images/technical_support.png'),
    Center(
      child: Text("TO BE CONTINUE"),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Consumer<WorkspaceDashBoardViewModel>(
        builder: (context, model, child) {
          final buttonInfo = {
            'event': {
              'label': '事件-即將到來',
              'icon': 'assets/icons/calendartick.svg',
              'number': model.dashboardEventNumber,
              'index': 0,
            },
            'mission': {
              'label': '任務-追蹤中',
              'icon': 'assets/icons/task.svg',
              'number': model.dashboardeMissionNumber,
              'index': 1,
            },
            'group': {
              'label': '對話-已開啟',
              'icon': 'assets/icons/messagetick.svg',
              'number': 0,
              'index': 2,
            },
          };
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('OVERVIEW',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              const Divider(height: 2, thickness: 2),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: buttonInfo.entries
                      .map((entry) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: OverViewChoiceButton(
                                onTap: () {
                                  model.updateOverViewIndex(entry
                                      .value['index']! as int); // setEnable(0);
                                },
                                labelText: entry.value['label']! as String,
                                iconPath: entry.value['icon']! as String,
                                numberText: entry.value['number']! as int,
                                isSelected: entry.value['index']! as int ==
                                    model.overView,
                              ),
                            ),
                          ))
                      .toList()),
              Expanded(
                flex: 4,
                child: pages[model.overViewIndex],
              )
            ],
          );
        },
      ),
    );
  }
}

class EventListView extends StatefulWidget {
  const EventListView({super.key});
  @override
  State<EventListView> createState() => EventListViewState();
}

class EventListViewState extends State<EventListView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, model, child) => ListView(
          children: model.events
              .map((eventModel) =>
                  ChangeNotifierProvider<EventSettingViewModel>(
                      create: (context) => EventSettingViewModel()
                        ..initializeDisplayEvent(
                            model: eventModel, user: model.personalprofileData),
                      child: const EventCardViewTemplate()))
              .toList()),
    );
  }
}

class MissionListView extends StatefulWidget {
  const MissionListView({super.key});
  @override
  State<MissionListView> createState() => MissionListViewState();
}

class MissionListViewState extends State<MissionListView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, model, child) => ListView(
          children: model.missions
              .map((missionModel) =>
                  ChangeNotifierProvider<MissionSettingViewModel>(
                      create: (context) => MissionSettingViewModel()
                        ..initializeDisplayMission(
                            model: missionModel,
                            user: model.personalprofileData),
                      child: const MissionCardViewTemplate()))
              .toList()),
    );
  }
}

// class MissionListView extends StatefulWidget {
//   const MissionListView({super.key});
//   @override
//   State<MissionListView> createState() => MissionListViewState();
// }

// class MissionListViewState extends State<MissionListView> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WorkspaceDashBoardViewModel>(
//       builder: (context, model, child) => ListView(
//           children: model.dashboardMissionList
//               .map((missionModel) => 
//                   ChangeNotifierProvider<MissionSettingViewModel>(
//                     create: (context) => MissionSettingViewModel.display(missionModel),
//                   child: const EventCardViewTemplate()
//                 )).toList()),
//     );
//   }
// }
