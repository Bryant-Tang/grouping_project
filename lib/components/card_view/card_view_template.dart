import 'package:flutter/material.dart';
import 'dart:math';

List<Color> randomColor = [
  Colors.amber,
  Colors.redAccent,
  Colors.lightBlue,
  Colors.greenAccent,
  Colors.orangeAccent,
  Colors.pinkAccent,
  Colors.purple
];

class CardViewTemplate extends StatefulWidget {
  const CardViewTemplate({super.key, required this.detail});

  final StatelessWidget detail;

  @override
  State<CardViewTemplate> createState() => _CardViewTemplateState();
}

class _CardViewTemplateState extends State<CardViewTemplate> {
  late final StatelessWidget detail;
  late StatelessWidget show;

  /// 隨機選擇使用的顏色
  final Color usingColor = randomColor[Random().nextInt(randomColor.length)];

  int state = 0;

  @override
  void initState() {
    super.initState();
    detail = widget.detail;
    show = _shrink(
      detail: detail,
      usingColor: usingColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
          onTap: () {
            if (state == 0) {
              show = _enlarge(
                detail: detail,
                usingColor: usingColor,
              );
              state = 1;
            } else {
              show = _shrink(
                detail: detail,
                usingColor: usingColor,
              );
              state = 0;
            }
            setState(() {});
          },
          child: show),
    );
  }
}

class _shrink extends StatelessWidget {
  _shrink({super.key, required this.detail, required this.usingColor});

  final StatelessWidget detail;
  final Color usingColor;



  // height should vary according to detailed of differet card(Upcoming, mission, message)
  var height = 84.0;

  @override
  Widget build(BuildContext context) {
    //debugPrint('it is shrink');
    return Ink(
        width: MediaQuery.of(context).size.width - 20,
        height: height,
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

class _enlarge extends StatelessWidget {
  _enlarge({super.key, required this.detail, required this.usingColor});

  final StatelessWidget detail;
  final Color usingColor;

  // height should vary according to detailed of differet card(Upcoming, mission, message)
  var height = 84.0;

  @override
  Widget build(BuildContext context) {
    //debugPrint('it is enlarge');
    return Ink(
        width: MediaQuery.of(context).size.width - 20,
        height: height,
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
                height: 20,
                decoration: BoxDecoration(
                    color: usingColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
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
