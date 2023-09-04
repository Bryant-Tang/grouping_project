import 'package:flutter/material.dart';
// import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:grouping_project/View/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class GroupingLogo extends StatelessWidget {
  const GroupingLogo({super.key});
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
