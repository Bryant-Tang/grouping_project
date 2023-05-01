import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/components/color_tag_chip.dart';
import 'package:grouping_project/model/model_lib.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EventCardViewTemplate extends StatefulWidget {
  const EventCardViewTemplate({super.key});

  @override
  State<EventCardViewTemplate> createState() => _EventCardViewTemplateState();
}

class _EventCardViewTemplateState extends State<EventCardViewTemplate> {
  void onClick(WorkspaceDashBoardViewModel workspaceVM,
      EventSettingViewModel eventSettingVM) async {
    // debugPrint('open event page');
    context.read<ThemeManager>().updateColorSchemeSeed(eventSettingVM.color);
    const animationDuration = Duration(milliseconds: 400);
    final isNeedRefresh = await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: animationDuration,
            reverseTransitionDuration: animationDuration,
            pageBuilder: (BuildContext context, __, ___) =>
                MultiProvider(providers: [
                  ChangeNotifierProvider<EventSettingViewModel>.value(
                      value: eventSettingVM),
                  ChangeNotifierProvider<WorkspaceDashBoardViewModel>.value(
                      value: workspaceVM)
                ], child: const EventEditCardView())));
    if (isNeedRefresh != null && isNeedRefresh) {
      await workspaceVM.getAllData();
    }
    if(mounted){
      context.read<ThemeManager>().updateColorSchemeSeed(Color(workspaceVM.accountProfileData.color));
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, workspaceVM, child) => Consumer<EventSettingViewModel>(
        builder: (context, model, child) {
          ThemeData themeData = ThemeData(
              colorSchemeSeed: model.color,
              brightness: context.watch<ThemeManager>().brightness);
          return Hero(
            tag: "${model.eventModel.id}",
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: AspectRatio(
                aspectRatio: 3.3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: themeData.colorScheme.surface,
                      foregroundColor: themeData.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 4,
                      padding: const EdgeInsets.all(3)),
                  onPressed: () => onClick(workspaceVM, model),
                  child: Row(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            color: themeData.colorScheme.surfaceVariant),
                        width: 12,
                        // color: Theme.of(context).colorScheme.primary
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                ColorTagChip(
                                    tagString: model.eventOwnerAccount.nickname,
                                    color: themeData.colorScheme.primary),
                              ],
                            ),
                            Text(model.title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: themeData.textTheme.titleMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                            Text(
                              model.introduction,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: themeData.textTheme.titleSmall!.copyWith(
                                  // color: themeData.colorScheme.secondary,
                                  fontSize: 14),
                            ),
                            Row(
                              children: [
                                Text(model.formattedStartTime),
                                const Icon(Icons.arrow_right_rounded),
                                Expanded(
                                  child: Text(model.formattedEndTime,
                                      maxLines: 1, overflow: TextOverflow.fade),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class EventEditCardView extends StatefulWidget {
  const EventEditCardView({Key? key}) : super(key: key);
  // const ExpandedCardView({super.key});

  @override
  State<EventEditCardView> createState() => _EditCardViewCardViewState();
}

class _EditCardViewCardViewState extends State<EventEditCardView> {
  // late ThemeData themeData;

  Widget getDateTime(EventSettingViewModel model) {
    return Row(
      children: [
        Icon(Icons.timer,
            color: Theme.of(context).colorScheme.secondary, size: 16),
        const SizedBox(width: 4),
        Text(
          model.getTimerCounter(),
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
              fontSize: 14,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget generateContentDisplayBlock(String blockTitle, Widget child) {
    TextStyle blockTitleTextStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.secondary);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(blockTitle, style: blockTitleTextStyle),
            const Divider(thickness: 3),
            child
          ],
        ));
  }

  Widget getInformationDisplay(EventSettingViewModel model) {
    TextStyle titleTextStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.bold, fontSize: 28);
    Widget eventOwnerLabel = Row(
      children: [
        ColorTagChip(
            tagString: "事件 - ${model.eventModel.ownerAccount.nickname} 的工作區",
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        eventOwnerLabel,
        TextFormField(
          initialValue: model.title == "事件標題" ? "" : model.title,
          style: titleTextStyle,
          onChanged: model.updateTitle,
          decoration: const InputDecoration(
              hintText: "事件標題",
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 2),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              )),
          validator: model.titleValidator,
        ),
        getDateTime(model)
      ],
    );
  }

  Widget getEventDescriptionDisplay(EventSettingViewModel model) {
    TextStyle textStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.bold, fontSize: 16);
    return generateContentDisplayBlock(
        '事件介紹',
        TextFormField(
          initialValue: model.introduction == "事件介紹" ? "" : model.introduction,
          style: textStyle,
          onChanged: model.updateIntroduction,
          maxLines: null,
          decoration: const InputDecoration(
              hintText: "事件介紹",
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 2),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              )),
          validator: model.introductionValidator,
        ));
  }

  void showTimePicker(
      Function callBack, BuildContext context, DateTime initialTime) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: const Text('選擇時間'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.height * 0.8,
              child: SfDateRangePicker(
                onSubmit: (value) {
                  debugPrint(value.toString());
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    showPicker(
                        is24HrFormat: true,
                        value: Time(
                            hour: initialTime.hour, minute: initialTime.minute),
                        onChange: (newTime) {
                          debugPrint(value.runtimeType.toString());
                          debugPrint(newTime.toString());
                          callBack((value as DateTime).copyWith(
                            hour: newTime.hour,
                            minute: newTime.minute,
                          ));
                        }),
                  );
                },
                onCancel: () {
                  Navigator.pop(context);
                },
                initialSelectedDate: initialTime,
                showActionButtons: true,
              ),
            ),
          );
        }));
  }

  Widget getStartTimeBlock(EventSettingViewModel model) {
    return generateContentDisplayBlock(
        '開始時間',
        ElevatedButton(
            onPressed: () =>
                showTimePicker(model.updateStartTime, context, model.startTime),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 10),
                Text(model.formattedStartTime),
              ],
            )));
  }

  Widget getEndTimeBlock(EventSettingViewModel model) {
    return generateContentDisplayBlock(
        '結束時間',
        ElevatedButton(
            onPressed: () =>
                showTimePicker(model.updateEndTime, context, model.endTime),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 10),
                Text(model.formattedEndTime),
              ],
            )));
  }

  Widget getContributorButton(
      EventSettingViewModel model, AccountModel account) {
    return Padding(
        padding: const EdgeInsets.all(6.0),
        child: RawChip(
            onPressed: () => model.updateContibutor(account),
            // onDeleted: () => model.updateContibutor(account),
            // deleteIcon: model.isContributors(account) ? const Icon(Icons.delete) : const Icon(Icons.add),
            selected: model.isContributors(account),
            elevation: 3,
            label: Text(account.nickname),
            avatar: CircleAvatar(
                backgroundImage: account.photo.isEmpty
                    ? Image.asset('assets/images/profile_male.png').image
                    : Image.memory(account.photo).image)));
  }

  void onUpdateContributor(EventSettingViewModel model) {
    showModalBottomSheet(
        context: context,
        builder: (context) =>
            ChangeNotifierProvider<EventSettingViewModel>.value(
              value: model,
              child: Consumer<EventSettingViewModel>(
                builder: (context, model, child) => SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                          child: model.contributorCandidate.isEmpty
                              ? const Center(child: Text('無其他成員'))
                              : Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Wrap(
                                      children: List.generate(
                                          model.contributorCandidate.length,
                                          (index) => getContributorButton(
                                              model,
                                              model.contributorCandidate[
                                                  index]))),
                                )),
                    ],
                  ),
                ),
              ),
            ));
    // debugPrint(model.contributors.length.toString());
  }

  Widget getContributorBlock(EventSettingViewModel model) {
    return generateContentDisplayBlock(
        '參與者',
        MaterialButton(
          onPressed: () async {
            // debugPrint(model.eventModel.contributorIds.length.toString());
            onUpdateContributor(model);
          },
          child: model.contributors.isEmpty
              ? const Text('沒有參與者')
              : Wrap(
                  children: List.generate(
                      model.contributors.length,
                      (index) => getContributorButton(
                          model, model.contributors[index])),
                ),
        ));
  }

  void onFinish(EventSettingViewModel model) async {
    if (formKey.currentState!.validate()) {
      final isNeedRefresh = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('確認'),
              content: const Text('是否確認編輯?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('否')),
                TextButton(
                    onPressed: () async {
                      await model.createEvent();
                      if (context.mounted) {
                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text('確認')),
              ],
            );
          });
      if (context.mounted && isNeedRefresh) {
        Navigator.pop(context, isNeedRefresh);
      }
    }
  }

  void onDelete(EventSettingViewModel model) async {
    final isNeedRefresh = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('確認'),
            content: const Text('是否確認刪除?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('否')),
              TextButton(
                  onPressed: () async {
                    await model.deleteEvent();
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text('是')),
            ],
          );
        });
    if (context.mounted) {
      // context
      //     .watch<ThemeManager>()
      //     .updateColorSchemeSeed(Color(context.watch<WorkspaceDashBoardViewModel>().accountProfileData.color));
      Navigator.pop(context, isNeedRefresh);
    }
  }

  final formKey = GlobalKey<FormState>();
  Stream<DateTime> currentTimeStream = Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, theme, child) => Consumer<WorkspaceDashBoardViewModel>(
        builder: (context, workspaceVM, child) =>
            Consumer<EventSettingViewModel>(builder: (context, model, child) {
          return StreamBuilder<DateTime>(
            stream: currentTimeStream,
            builder: (context, snapshot) => GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Hero(
                tag: "${model.eventModel.id}",
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    elevation: 2,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_rounded,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () => onFinish(model),
                        icon: Icon(Icons.check,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      IconButton(
                          onPressed: () => onDelete(model),
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                  // display all event data
                  body: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getInformationDisplay(model),
                              getEventDescriptionDisplay(model),
                              getStartTimeBlock(model),
                              getEndTimeBlock(model),
                              getContributorBlock(model),
                              generateContentDisplayBlock(
                                  '子任務', const Text('沒有子任務')),
                              // relation note
                              generateContentDisplayBlock(
                                  '關聯筆記', const Text('沒有關聯筆記')),
                              // relation message
                              generateContentDisplayBlock(
                                  '關聯話題', const Text('沒有關聯話題')),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
