import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationAppBar extends StatefulWidget {
  final int currentIndex;
  final void Function(int) onTap;
  const NavigationAppBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  State<NavigationAppBar> createState() => _NavigationAppBarState();
}

class _NavigationAppBarState extends State<NavigationAppBar> {
  int currentPageIndex = 0;
  final filename = ["home", "calendar", "messages", "note"];

  Widget getSvgIcon(
      {required String path, required BuildContext context}) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return SvgPicture.asset(path,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
  }

  String getPath(filename) {
    return "assets/icons/appBar/$filename.svg";
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (index) {
        setState(() {
          currentPageIndex = index;
        });
        widget.onTap(index);
      },
      selectedIndex: currentPageIndex,
      destinations: filename
          .map((name) => NavigationDestination(
                icon: getSvgIcon(path: getPath(name), context: context),
                // color: Colors.black,
                label: name,
              ))
          .toList(),
    );
  }
}
