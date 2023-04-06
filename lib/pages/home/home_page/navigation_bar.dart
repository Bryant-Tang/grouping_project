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

class _NavigationAppBarState extends State<NavigationAppBar>{
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/appBar/home.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                // color: Colors.grey,
              ),
              activeIcon: SvgPicture.asset(
                "assets/icons/appBar/home.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                // color: Colors.black,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/appBar/calendar.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                // color: Colors.grey,
              ),
              activeIcon: SvgPicture.asset(
                "assets/icons/appBar/calendar.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                // color: Colors.black,
              ),
              label: 'Calendar'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/appBar/messages1.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                // color: Colors.grey,
              ),
              activeIcon: SvgPicture.asset(
                "assets/icons/appBar/messages1.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                // color: Colors.black,
              ),
              label: 'Message'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/appBar/note1.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                // color: Colors.grey,
              ),
              activeIcon: SvgPicture.asset(
                "assets/icons/appBar/note1.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                // color: Colors.black,
              ),
              label: 'Note'),
        ],
        currentIndex: widget.currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: widget.onTap);
  }
}
