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
  // "assets/icons/appBar/home.svg"
  final Color selectedColor = Colors.white;
  final Color unselectedColor = Colors.black;
  final homeSvgPath = "assets/icons/appBar/home.svg";
  final calendarSvgPath = "assets/icons/appBar/calendar.svg";
  final messagesPath = "assets/icons/appBar/messages1.svg";
  final noteSvgPath = "assets/icons/appBar/note1.svg";
  Widget getSelectedSvgIcon({required String path}) {
    return SvgPicture.asset(path,
        colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn));
  }

  Widget getUnselectedSvgIcon({required String path}) {
    return SvgPicture.asset(path,
        colorFilter: ColorFilter.mode(unselectedColor, BlendMode.srcIn));
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
      destinations: [
        NavigationDestination(
          icon: getUnselectedSvgIcon(path: homeSvgPath),
          selectedIcon: getSelectedSvgIcon(path: homeSvgPath),
          // color: Colors.black,
          label: 'Home',
        ),
        NavigationDestination(
            icon: getUnselectedSvgIcon(path: calendarSvgPath),
            selectedIcon: getSelectedSvgIcon(path: calendarSvgPath),
            label: 'Calendar'),
        NavigationDestination(
            icon: getUnselectedSvgIcon(path: messagesPath),
            selectedIcon: getSelectedSvgIcon(path: messagesPath),
            label: 'Message'),
        NavigationDestination(
            icon: getUnselectedSvgIcon(path: noteSvgPath),
            selectedIcon: getSelectedSvgIcon(path: noteSvgPath),
            label: 'Note')
      ],
    );
  }
}
