import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroupingLogo extends StatelessWidget {
  const GroupingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/images/logo.svg",
        semanticsLabel: 'Acme Logo');
  }
}
