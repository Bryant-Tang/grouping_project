import 'package:flutter/material.dart';
import 'package:grouping_project/pages/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:grouping_project/model/user_model.dart';
import 'package:grouping_project/pages/auth/cover.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel?>(context);
    if (userModel == null) {
      return CoverPage();
    } else {
      print(userModel);
      return MyHomePage();
    }
  }
}
