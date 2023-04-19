import 'package:flutter/material.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:provider/provider.dart';

class GroupingLogo extends StatefulWidget {
  const GroupingLogo({super.key});
  @override
  State<GroupingLogo> createState() => _GroupingLogoState();
}

class _GroupingLogoState extends State<GroupingLogo> {
  @override
  Widget build(BuildContext context) {
    // debugPrint(Theme.of(context).brightness.toString());
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return themeManager.coverLogo;
      },
    );
  }
}
