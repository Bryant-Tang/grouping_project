import 'package:flutter/material.dart';

class NavigationToggleBar extends StatelessWidget {
  final String goToNextButtonText;
  final String goBackButtonText;
  final goToNextButtonIcon = Icons.keyboard_arrow_right_rounded;
  final goBackButtonIcon = Icons.keyboard_arrow_left_rounded;
  final void Function() goToNextButtonHandler;
  final void Function() goBackButtonHandler;
  const NavigationToggleBar({
    super.key,
    required this.goBackButtonText,
    required this.goToNextButtonText,
    required this.goToNextButtonHandler,
    required this.goBackButtonHandler,
    // this.goToNextButtonIcon,
    // this.goBackButtonIcon,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        MaterialButton(
          onPressed: goBackButtonHandler,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  goBackButtonIcon,
                  color: Colors.amber,
                ),
                Text(
                  goBackButtonText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        ),
        MaterialButton(
            onPressed: goToNextButtonHandler,
            color: Colors.amber,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    goToNextButtonText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    goToNextButtonIcon,
                    color: Colors.white,
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
