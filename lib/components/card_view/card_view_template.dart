import 'package:flutter/material.dart';
import 'dart:math';

List<Color> randomColor = const [
  /// 顏色固定用色碼
  Color(0xFFFCBF49),
  Color(0xFFFF5252),
  Color(0xFF03A9F4),
  Color(0xFF69F0AE),
  Color(0xFFFFAB40),
  Color(0xFFFF4081),
  Color(0xFF972CB0)
];

class CardViewTemplate extends StatefulWidget {
  /// 這個 class 將會創立一個點擊能放大的 card view template，再點擊則能縮小
  /// 因此要使用這個 widget 必須要給予實現縮小的 widget (也就是 shrink) 
  /// 以及放大的 widget (也就是 enlarge)
  /// 
  const CardViewTemplate({super.key, required this.detailShrink, required this.detailEnlarge});

  final StatelessWidget detailShrink;
  final StatelessWidget detailEnlarge;

  @override
  State<CardViewTemplate> createState() => _CardViewTemplateState();
}

class _CardViewTemplateState extends State<CardViewTemplate> {
  late final StatelessWidget detail;
  late Widget show;

  /// 隨機選擇使用的顏色
  final Color usingColor = randomColor[Random().nextInt(randomColor.length)];

  int state = 0;

  @override
  void initState() {
    super.initState();
    // ~~~~~~~
    detail = widget.detailShrink;
    show = AnimatedContainer(
      duration: Duration(milliseconds: 250),
      height: 84,
      child: _shrink(
        detail: widget.detailShrink,
        usingColor: usingColor,
        height: 84,
      )
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
              
              show = AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 405,
                child: _enlarge(
                  detail: widget.detailEnlarge,
                  usingColor: usingColor,
                  height: 405,
                )
              );
              state = 1;
            } else {
              show = AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 84,
                child: _shrink(
                  detail: widget.detailShrink,
                  usingColor: usingColor,
                  height: 84,
                )
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
  _shrink({super.key, required this.detail, required this.usingColor, required this.height});

  final StatelessWidget detail;
  final Color usingColor;



  // height should vary according to detailed of differet card(Upcoming, mission, message)
  final double height;

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
  _enlarge({super.key, required this.detail, required this.usingColor, required this.height});

  final StatelessWidget detail;
  final Color usingColor;

  // height should vary according to detailed of differet card(Upcoming, mission, message)
  final double height;

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
        ));
  }
}
