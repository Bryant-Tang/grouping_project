import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroupingLogo extends StatefulWidget {
  const GroupingLogo({super.key});

  @override
  State<GroupingLogo> createState() => _GroupingLogoState();
}

class _GroupingLogoState extends State<GroupingLogo> {
  @override
  Widget build(BuildContext context) {
    debugPrint(Theme.of(context).brightness.toString());
    return Theme.of(context).brightness == Brightness.dark
        ? SvgPicture.asset(
            "assets/images/logo_dark.svg",
            semanticsLabel: 'Grouping Logo',
          )
        : SvgPicture.asset(
            "assets/images/logo_light.svg",
            semanticsLabel: 'Grouping Logo',
          );
  }
}
