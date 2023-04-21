import 'package:flutter/material.dart';
import 'package:grouping_project/VM/event_setting_view_model.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/components/card_view/event/event_information_enlarge.dart';
import 'package:grouping_project/components/card_view/event/event_information_shrink.dart';
import 'package:grouping_project/components/color_tag_chip.dart';

import 'package:grouping_project/model/model_lib.dart';
import 'package:provider/provider.dart';

class EventCardViewTemplate extends StatefulWidget {
  const EventCardViewTemplate({super.key});

  @override
  State<EventCardViewTemplate> createState() => _EventCardViewTemplateState();
}

class _EventCardViewTemplateState extends State<EventCardViewTemplate> {
  @override
  Widget build(BuildContext context) {
    // final Color color = Color(eventModel.color);
    // final EventInformationShrink detailShrink =
    //     EventInformationShrink(eventModel: eventModel);
    // final EventInformationEnlarge detailEnlarge =
    //     EventInformationEnlarge(eventModel: eventModel);
    return Consumer<EventSettingViewModel>(
      builder: (context, model, child) {
        ThemeData themeData = ThemeData(
            colorSchemeSeed: model.color,
            brightness: context.watch<ThemeManager>().brightness);
        return Card(
            color: themeData.colorScheme.surface,
            elevation: 2,
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                debugPrint('open event page');
                // Navigator.push(
                //     context,
                //     PageRouteBuilder(
                //         transitionDuration: const Duration(milliseconds: 400),
                //         reverseTransitionDuration:
                //             const Duration(milliseconds: 400),
                //         pageBuilder: (_, __, ___) => _Enlarge(
                //             detail: detailEnlarge, usingColor: color)));
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(3, 3, 0, 3),
                child: Row(
                  children:[
                   Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                      color: themeData.colorScheme.primary),
                     height: 100,
                     width: 12,
                     // color: Theme.of(context).colorScheme.primary
                   ),
                   const SizedBox(width: 10,),
                   Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Text(model.)
                        ColorTagChip(tagString: "臨時tag", color: themeData.colorScheme.primary),
                        Text(
                          model.title,
                           overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          style: themeData.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 16)
                        ),
                        Text(
                          model.introduction,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: themeData.textTheme.titleSmall!.copyWith(
                            color: themeData.colorScheme.secondary,
                            fontSize: 14
                          ),
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
              // child: Hero(
              //   tag: 'change${detailShrink.eventModel.id}',
              //   child: _Shrink(
              //     detail: detailShrink,
              //     usingColor: color,
              //     height: 84,
              //   ),
              // )),
            ));
      },
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
