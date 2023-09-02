import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/auth/web_login_view.dart';

class AuthView extends StatelessWidget{
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return WebLoginView();
    }
    else{
      return const Scaffold(
        body: Text('Currently not supporting mobile login'),
      );
    }
  }
}