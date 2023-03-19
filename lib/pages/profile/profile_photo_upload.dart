import 'package:flutter/material.dart';
import 'package:grouping_project/components/component_lib.dart';
import 'dart:math';

class PersonProfileImageUpload extends StatefulWidget {
  const PersonProfileImageUpload({super.key});

  Map<String, String?> get content => {'Image': "no image"};

  @override
  State<PersonProfileImageUpload> createState() =>
      _PersonProfileImageUploadgState();
}

class _PersonProfileImageUploadgState extends State<PersonProfileImageUpload> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        HeadlineWithContent(
            headLineText: "個人資訊設定", content: "新增全名、暱稱、自我介紹與心情小語，讓大家更快認識你"),
        ShakeWidget(
          child: Center(
            child: Text("SHAKE IT"),
          ),
        )
      ],
    );
  }
}

class ShakeWidget extends StatefulWidget {
  final Widget child;

  ShakeWidget({required this.child});

  @override
  _ShakeWidgetState createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -0.05, end: 0.05).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: _animation.value,
          child: child,
        );
      },
    );
  }
}
