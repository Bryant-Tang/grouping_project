import 'package:grouping_project/components/auth_view/grouping_logo.dart';
import 'package:grouping_project/View/auth/login_view.dart';

import 'package:flutter/material.dart';

class CoverPage extends StatefulWidget {
  const CoverPage({super.key});

  @override
  State<CoverPage> createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> with TickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        setState(() {
          if (controller.isCompleted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        });
      });
    controller.forward();
    // controller.repeat(reverse: true, period: const Duration(seconds: 3));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(Theme.of(context).colorScheme.primary.toString());
    return Scaffold(
        // decoration: BoxDecoration(
        //     // color: Colors.white,
        //     image: DecorationImage(
        //         image: const AssetImage("assets/images/cover.png"),
        //         fit: BoxFit.cover,
        //         colorFilter: ColorFilter.mode(
        //             Colors.white.withOpacity(0.1), BlendMode.modulate))),
        body: SafeArea(
      child: Column(
        children: [
          const SizedBox(width: 10, height: 315),
          const GroupingLogo(),
          const SizedBox(width: 10, height: 210),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(
                  value: controller.value,
                  minHeight: 8,
                  semanticsLabel: 'Linear progress indicator',
                ),
                // FlowButton(
                //     buttonText: "登入 LOGIN",
                //     onPressed: () {
                //       Navigator.pushReplacement(context,
                //           MaterialPageRoute(builder: (context) => LoginPage()));
                //     }),
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class FlowButton extends StatelessWidget {
  final String buttonText;
  final Color? textColor;
  final Color? backgroundColor;
  final void Function()? onPressed;
  const FlowButton(
      {super.key,
      required this.onPressed,
      this.buttonText = "button",
      this.textColor = Colors.white,
      this.backgroundColor = Colors.amber});

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.black12.withOpacity(0.0),
      shadowColor: Colors.grey.withOpacity(0.4),
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      elevation: 8.0,
      child: MaterialButton(
        color: backgroundColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontFamily: "NotoSansTC",
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
