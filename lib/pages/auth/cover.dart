import 'package:grouping_project/pages/auth/login.dart';
import 'package:grouping_project/pages/auth/sign_up.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CoverPage extends StatefulWidget {
  const CoverPage({super.key});

  @override
  State<CoverPage> createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> {
  // _onLogin() {
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => LoginPage()));
  // }

  // _onSignUp() {
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => const SignUp()));
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: const AssetImage("assets/images/cover.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.1), BlendMode.modulate))),
      child: Column(
        children: [
          const SizedBox(width: 10, height: 315),
          SvgPicture.asset(
            "assets/images/logo.svg",
            semanticsLabel: 'Acme Logo',
          ),
          const SizedBox(width: 10, height: 210),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FlowButton(
                    buttonText: "登入 LOGIN",
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    }),
                FlowButton(
                    buttonText: "註冊 SIGNUP",
                    backgroundColor: Colors.white,
                    textColor: Colors.grey[600],
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    }),
              ],
            ),
          )
        ],
      ),
    );
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
