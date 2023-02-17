import 'package:flutter/material.dart';
import 'package:grouping_project/components/headline_with_content.dart';
import 'package:grouping_project/components/navigation_toggle_bar.dart';

class SignUpPageTemplate extends StatefulWidget {
  final HeadlineWithContent titleWithContent;
  final Widget body;
  final NavigationToggleBar toggleBar;
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 150.0, 30.0, 150.0),
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
