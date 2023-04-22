import 'package:flutter/material.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/components/color_tag_chip.dart';

import 'package:provider/provider.dart';

class EventCardViewTemplate extends StatefulWidget {
  const EventCardViewTemplate({super.key});

  @override
  State<EventCardViewTemplate> createState() => _EventCardViewTemplateState();
}

class _EventCardViewTemplateState extends State<EventCardViewTemplate> {
  void onClick(WorkspaceDashBoardViewModel workspaceVM,
      EventSettingViewModel eventSettingVM) async {
    debugPrint('open event page');
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
                ], child: const ExpandedCardView())));
    if (isNeedRefresh != null && isNeedRefresh) {
      await workspaceVM.getAllData();
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
            tag: "${model.eventData.id}",
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ColorTagChip(
                              tagString: model.ownerAccountName,
                              color: themeData.colorScheme.primary),
                          Text(model.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: themeData.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                          Text(
                            model.introduction,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: themeData.textTheme.titleSmall!.copyWith(
                                // color: themeData.colorScheme.secondary,
                                fontSize: 16),
                          ),
                          Row(
                            children: [
                              Text(model.formattedStartTime),
                              const Icon(Icons.arrow_right_rounded),
                              Text(model.formattedEndTime),
                            ],
                          )
                        ],
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

class ExpandedCardView extends StatefulWidget {
  const ExpandedCardView({Key? key}) : super(key: key);
  // const ExpandedCardView({super.key});

  @override
  State<ExpandedCardView> createState() => _ExpandedCardViewState();
}

class _ExpandedCardViewState extends State<ExpandedCardView> {
  Widget getInformationDisplay(EventSettingViewModel model, ThemeData themeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ColorTagChip(
            tagString: model.ownerAccountName,
            color: themeData.colorScheme.primary
        ),
        Text(model.title,
            style: themeData.textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 24)),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(model.formattedStartTime),
            const Icon(Icons.arrow_right_rounded),
            Text(model.formattedEndTime),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    void onDelete(EventSettingViewModel model) async {
      final isNeedRefresh = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('確認'),
              content: const Text('本当に削除しますか？'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('いいえ')),
                TextButton(
                    onPressed: () async {
                      await model.deleteEvent();
                      if (context.mounted) {
                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text('はい')),
              ],
            );
          });
      if (context.mounted) {
        Navigator.pop(context, isNeedRefresh);
      }          
    }
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, workspaceVM, child) =>
          Consumer<EventSettingViewModel>(builder: (context, model, child) {
        ThemeData themeData = ThemeData(
            colorSchemeSeed: model.color,
            brightness: context.watch<ThemeManager>().brightness);
        return Hero(
            tag: '${model.eventData.id}',
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: themeData.colorScheme.surface,
                elevation: 2,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_rounded,
                      color: themeData.colorScheme.onSurfaceVariant),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      debugPrint('edit event');
                    },
                    icon: Icon(Icons.edit,
                        color: themeData.colorScheme.onSurfaceVariant),
                  ),
                  IconButton(
                    onPressed: () => onDelete(model),
                    icon: Icon(Icons.delete_rounded,
                        color: themeData.colorScheme.onSurfaceVariant),
                  )
                ],
              ),
              // display all event data
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getInformationDisplay(model, themeData),
                        Text(model.introduction,
                            style: themeData.textTheme.bodyMedium!
                                .copyWith(fontSize: 20)),
                      ]),
                ),
              ),
            ));
      }),
    );
  }
}


// class _Shrink extends StatelessWidget {
//   const _Shrink();
//   @override
//   Widget build(BuildContext context) {
//     //debugPrint('it is shrink');
//     return Consumer<EventSettingViewModel>(
//       builder: (context, model, child) => 
//     );
//   }
// }

// class _Enlarge extends StatelessWidget {
//   const _Enlarge({required this.detail, required this.usingColor});

//   final EventInformationEnlarge detail;
//   final Color usingColor;

//   @override
//   Widget build(BuildContext context) {
//     //debugPrint('it is enlarge');
//     return Scaffold(
//       body: Hero(
//         tag: 'change${detail.eventModel.id}',
//         child: Material(
//           type: MaterialType.transparency,
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black45,
//                     spreadRadius: 0.5,
//                     blurRadius: 2,
//                   )
//                 ]),
//             child: Stack(
//               children: [
//                 // 上方的矩形方塊
//                 Positioned(
//                   child: Container(
//                     height: 15,
//                     decoration: BoxDecoration(
//                         color: usingColor,
//                         borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10))),
//                   ),
//                 ),
//                 Positioned(
//                   left: 10,
//                   top: 18,
//                   // 放入各個 card view descript
//                   child: detail,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

