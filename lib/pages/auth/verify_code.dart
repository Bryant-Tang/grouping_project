import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grouping_project/pages/home/home_page.dart';
import 'package:grouping_project/service/auth_service.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({super.key});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  AuthService _authService = AuthService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String code = (100000 + Random().nextInt(99999)).toString();
  //_authService.sendCode(code);
  String _answer = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (value) {
              setState(() {
                _answer = value;
              });
            },
          ),
          TextButton(
              onPressed: () {
                print('Submit answe: ${_answer}');
                print('Real code: ${code}');
                if (_answer == code) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()));
                }
              },
              child: Text('Submit code')),
          TextButton(
              onPressed: () {
                print('Send: ${code.toString()}');
                _authService.sendCode(code);
              },
              child: Text('Send Login Code'))
        ],
      ),
    );
  }
}
