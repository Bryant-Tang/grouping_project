import 'package:flutter/material.dart';
import 'package:grouping_project/View/components/auth_view/auth_view_components_lib.dart';

class SignUpPageTemplate extends StatefulWidget {
  final HeadlineWithContent titleWithContent;
  final Widget body;
  final Widget toggleBar;
  const SignUpPageTemplate({
    super.key,
    required this.titleWithContent,
    required this.body,
    required this.toggleBar,
  });
  @override
  State<SignUpPageTemplate> createState() => _SignUpPageTemplateState();
}

class _SignUpPageTemplateState extends State<SignUpPageTemplate> {
  // bool loading = false;
  // final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    var verticalHeight = MediaQuery.of(context).size.height * 0.15;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: verticalHeight),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            widget.titleWithContent,
            // const SizedBox(width: 10, height: 30),
            widget.body,
            //const SizedBox(width: 10, height: 30),
            widget.toggleBar,
          ],
        ),
      ),
    );
  }
}

