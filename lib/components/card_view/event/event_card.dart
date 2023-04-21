import 'package:flutter/material.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/components/card_view/event/event_information_enlarge.dart';
import 'package:grouping_project/components/card_view/event/event_information_shrink.dart';

import 'package:grouping_project/model/model_lib.dart';
import 'package:provider/provider.dart';

class EventCardViewTemplate extends StatelessWidget {
  const EventCardViewTemplate({super.key, required this.eventModel});

  final EventModel eventModel;

  @override
  Widget build(BuildContext context) {
    final Color color = Color(eventModel.color);
    final EventInformationShrink detailShrink =
        EventInformationShrink(eventModel: eventModel);
    final EventInformationEnlarge detailEnlarge =
        EventInformationEnlarge(eventModel: eventModel);
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        ThemeData themeData = ThemeData(
            colorSchemeSeed: Color(eventModel.color),
            brightness: themeManager.brightness
        );
        return Card(
          color: themeData.colorScheme.surface,
          elevation: 2,
          child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        reverseTransitionDuration:
                            const Duration(milliseconds: 400),
                        pageBuilder: (_, __, ___) => _Enlarge(
                            detail: detailEnlarge, usingColor: color)));
              },
              child: Hero(
                tag: 'change${detailShrink.eventModel.id}',
                child: _Shrink(
                  detail: detailShrink,
                  usingColor: color,
                  height: 84,
                ),
              )),
        );
      },
    );
  }
}

class _Shrink extends StatelessWidget {
  const _Shrink({required this.detail, required this.usingColor, required this.height});

  final EventInformationShrink detail;
  final Color usingColor;

  // height should vary according to detailed of differet card(Upcoming, mission, message)
  final double height;

  @override
  Widget build(BuildContext context) {
    //debugPrint('it is shrink');
    return Container(
        // TODO: use padding
        width: MediaQuery.of(context).size.width - 20,
        height: height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 0.5,
                blurRadius: 2,
              )
            ]),
        child: Stack(
          children: [
            // 左方的矩形方塊
            Positioned(
              child: Container(
                width: 8,
                height: height,
                decoration: BoxDecoration(
                    color: usingColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),
            ),
            Positioned(
              left: 15,
              top: 3,
              // 放入各個 card view descript
              child: detail,
            )
          ],
        ));
  }
}

class _Enlarge extends StatelessWidget {
  const _Enlarge({required this.detail, required this.usingColor});

  final EventInformationEnlarge detail;
  final Color usingColor;

  @override
  Widget build(BuildContext context) {
    //debugPrint('it is enlarge');
    return Scaffold(
      body: Hero(
        tag: 'change${detail.eventModel.id}',
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    spreadRadius: 0.5,
                    blurRadius: 2,
                  )
                ]),
            child: Stack(
              children: [
                // 上方的矩形方塊
                Positioned(
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(
                        color: usingColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 18,
                  // 放入各個 card view descript
                  child: detail,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
