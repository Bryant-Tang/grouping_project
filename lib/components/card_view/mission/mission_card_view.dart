import 'package:flutter/material.dart';

import 'package:grouping_project/components/card_view/mission_information.dart';
import 'package:grouping_project/model/model_lib.dart';

class MissionCardViewTemplate extends StatelessWidget {
  const MissionCardViewTemplate(
      {super.key, required this.missionModel});

  final MissionModel missionModel;

  @override
  Widget build(BuildContext context) {
    final Color color = Color(missionModel.color);
    final MissionInformationShrink detailShrink = MissionInformationShrink(missionModel: missionModel);
    final MissionInformationEnlarge detailEnlarge = MissionInformationEnlarge(missionModel: missionModel);
    return Container(
      // TODO: use padding
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 700),
                    reverseTransitionDuration:
                        const Duration(milliseconds: 700),
                    pageBuilder: (_, __, ___) => _Enlarge(
                        detail: detailEnlarge, usingColor: color)));
          },
          child: Hero(
            tag: 'change${detailShrink.missionModel.id}',
            child: Material(
              type: MaterialType.transparency,
              child: _Shrink(
                detail: detailShrink,
                usingColor: color,
                height: 84,
              ),
            ),
          )),
    );
  }
}

class _Shrink extends StatelessWidget {
  const _Shrink(
      {required this.detail,
      required this.usingColor,
      required this.height});

  final MissionInformationShrink detail;
  final Color usingColor;

  // height should vary according to detailed of differet card(Upcoming, mission, message)
  final double height;

  @override
  Widget build(BuildContext context) {
    //debugPrint('it is shrink');
    return Container(
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

  final MissionInformationEnlarge detail;
  final Color usingColor;

  @override
  Widget build(BuildContext context) {
    //debugPrint('it is enlarge');
    return Scaffold(
      body: Hero(
        tag: 'change${detail.missionModel.id}',
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
